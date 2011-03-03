Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1CCFRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 00:17:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab1CCFRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 00:17:36 -0500
MIME-Version: 1.0
In-Reply-To: <20110303032454.GI22723@ZenIV.linux.org.uk>
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Mar 2011 21:17:15 -0800
Message-ID: <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
Subject: Re: [RFC] st_nlink after rmdir() and rename()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 7:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Surprisingly, the results are *NOT* identical wrt fstat(); for most of
> the filesystems we will get 0 in both cases (as expected), but some will
> leave 1 in buf2.st_nlink.

Why do we care? Some filesystems don't support i_nlink at all, so it's
always 1. Others won't do the real delete until later (nfs
sillyrename), so returning 0 would be wrong and insane.

So the fact is, expecting 0,0 seems to be an incorrect expectation,
and I don't understand why you would really care. Does it matter?

                        Linus
