Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab1DNUXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:23:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308Ab1DNUXc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:23:32 -0400
MIME-Version: 1.0
In-Reply-To: <201104142217.12478.bonganilinux@mweb.co.za>
References: <201104051858.20304.bonganilinux@mweb.co.za> <201104141914.23529.bonganilinux@mweb.co.za>
 <BANLkTin=xwfr5aVhzyL_FFo3K3SNMW9OQw@mail.gmail.com> <201104142217.12478.bonganilinux@mweb.co.za>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Apr 2011 13:22:38 -0700
Message-ID: <BANLkTikMyokqzTm=-bqymePwbgmEar=qhQ@mail.gmail.com>
Subject: Re: [Regression] 2.6.38 ncpfs
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: npiggin@kernel.dk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>,
        Petr Vandrovec <petr@vandrovec.name>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 1:17 PM, Bongani Hlope <bonganilinux@mweb.co.za> wrote:
>
> Looking at the changes,  you are right. The BUG_ON() seems to be what is not
> suppose to be there. The attached patch only removes the BUG_ON(). I'll test
> on my work PC tomorrow and see if that also fixes the bug.

You might also try to replace it with

    BUG_ON(!mutex_is_locked(&dentry->d_parent->d_inode->i_mutex))

ie add that "d_parent" there. Just for testing - I think the real fix
really is to remove it, but I'd personally be happier knowing that
_if_ it were to have that d_parent there, it would have worked.

It would also be interesting to hear if that name length could
possibly ever change, and we'd hit that test too. It looks like the
original code actually checked that the length was the same before
doing the overwrite.

ncpfs doesn't seem to be very actively maintained, I suspect Petr
isn't really using it any more.

                   Linus

                Linus
