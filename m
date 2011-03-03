Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab1CCVxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:53:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614Ab1CCVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:53:10 -0500
MIME-Version: 1.0
In-Reply-To: <87lj0v9984.fsf@devron.myhome.or.jp>
References: <20110303032454.GI22723@ZenIV.linux.org.uk> <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
 <20110303060352.GK22723@ZenIV.linux.org.uk> <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
 <87tyfk7x0c.fsf@devron.myhome.or.jp> <AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
 <87lj0v9984.fsf@devron.myhome.or.jp>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Mar 2011 13:52:18 -0800
Message-ID: <AANLkTinSiD3YakBTNfYXrE12YDsDREHX3GzLzCncduTV@mail.gmail.com>
Subject: Re: [RFC] st_nlink after rmdir() and rename()
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 1:37 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
>
> And I can't only see is why you refuse to make consistent behavior (if
> you are saying it). It's why I said if it's _really easy_.

The thing is, it really isn't really easy. As mentioned, it's actually
impossible on NFS, and it's possibly impossible on other filesystems
too.

So what I'm objecting to is "try to make something consistent that
CANNOT be consistent anyway", and calling it a bug.

I'm not saying there aren't real bugs there too (the actual races in
i_nlink handling are real bugs). But I _am_ saying that it's simply
not true that i_nlink must be zero if you do an "fstat()" after doing
an rmdir on an fd that you held open. Nobody can reasonably care, and
anybody who _does_ care is better off getting a nasty surprise early
rather than late.

                           Linus
