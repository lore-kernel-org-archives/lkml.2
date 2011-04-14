Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab1DNRaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:30:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281Ab1DNRaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:30:24 -0400
MIME-Version: 1.0
In-Reply-To: <201104141914.23529.bonganilinux@mweb.co.za>
References: <201104051858.20304.bonganilinux@mweb.co.za> <201104141914.23529.bonganilinux@mweb.co.za>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Apr 2011 10:29:34 -0700
Message-ID: <BANLkTin=xwfr5aVhzyL_FFo3K3SNMW9OQw@mail.gmail.com>
Subject: Re: [Regression] 2.6.38 ncpfs
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: npiggin@kernel.dk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>,
        Petr Vandrovec <petr@vandrovec.name>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 10:14 AM, Bongani Hlope <bonganilinux@mweb.co.za> wrote:
>
> The bug is caused by commit fb2d5b86aff355a27ebfc132d3c99f4a940cc3fe, which
> was committed by Nick. Can you please either revert Nick's changes or include
> the attached patch (or a better version, because I'm not that clued up with
> ncpfs).

Hmm. Your patch isn't correct. You can't just do

   if (!mutex_is_locked(&dentry->d_inode->i_mutex)) {
      mutex_lock(&inode->i_mutex);

because code like that makes no sense - maybe it was locked by
somebody _else_, and you would need to lock it.

That said, I do think that the

  BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));

is wrong, since even the comment above it talks about the _parent_
dentry, not the dentry that is actually being modified.

So there's clearly a bug somewhere, and the fix may be to just remove
that BUG_ON().

Added some more people to the cc.

                                   Linus
