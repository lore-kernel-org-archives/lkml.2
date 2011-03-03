Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091Ab1CCXMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 18:12:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49160 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784Ab1CCXMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 18:12:36 -0500
Date: Thu, 3 Mar 2011 23:12:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
Message-ID: <20110303231234.GS22723@ZenIV.linux.org.uk>
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
 <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
 <20110303060352.GK22723@ZenIV.linux.org.uk>
 <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
 <87tyfk7x0c.fsf@devron.myhome.or.jp>
 <AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
 <87lj0v9984.fsf@devron.myhome.or.jp>
 <AANLkTinSiD3YakBTNfYXrE12YDsDREHX3GzLzCncduTV@mail.gmail.com>
 <87hbbj96yh.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hbbj96yh.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 07:26:14AM +0900, OGAWA Hirofumi wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Thu, Mar 3, 2011 at 1:37 PM, OGAWA Hirofumi
> > <hirofumi@mail.parknet.co.jp> wrote:
> >>
> >> And I can't only see is why you refuse to make consistent behavior (if
> >> you are saying it). It's why I said if it's _really easy_.
> >
> > The thing is, it really isn't really easy. As mentioned, it's actually
> > impossible on NFS, and it's possibly impossible on other filesystems
> > too.
> 
> I don't know much about NFS though, I imaged the NFS just fill the
> stat.st_nlink to return to userland by 0 if sillyrenamed dentry? (of
> course, I'm not saying let's emulate "i_nlink >= 1" on all
> filesystems. just about i_nlink == 0) I was thinking Al is working for
> it...

No.  I don't really care much about what NFS does with st_nlink.  It might
be possible to fake for directories, but you'll have a hell of a time doing
that accurately for regular files.  Not worth doing.
