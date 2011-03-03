Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab1CCWh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:37:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758618Ab1CCWh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:37:57 -0500
MIME-Version: 1.0
In-Reply-To: <87hbbj96yh.fsf@devron.myhome.or.jp>
References: <20110303032454.GI22723@ZenIV.linux.org.uk> <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
 <20110303060352.GK22723@ZenIV.linux.org.uk> <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
 <87tyfk7x0c.fsf@devron.myhome.or.jp> <AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
 <87lj0v9984.fsf@devron.myhome.or.jp> <AANLkTinSiD3YakBTNfYXrE12YDsDREHX3GzLzCncduTV@mail.gmail.com>
 <87hbbj96yh.fsf@devron.myhome.or.jp>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Mar 2011 14:37:36 -0800
Message-ID: <AANLkTintTRHmAfvBwFszNyqbssbX91k17u=0kh+V7N7D@mail.gmail.com>
Subject: Re: [RFC] st_nlink after rmdir() and rename()
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 2:26 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
>
> I don't know much about NFS though, I imaged the NFS just fill the
> stat.st_nlink to return to userland by 0 if sillyrenamed dentry? (of
> course, I'm not saying let's emulate "i_nlink >= 1" on all
> filesystems. just about i_nlink == 0) I was thinking Al is working for
> it...

So even if we did that, WHAT WOULD BE THE UPSIDE?

Code that cares wouldn't run on any other Unix, or on any older
version of Linux.

And I claim that there is not a single reason to do it anyway. That
whole "code that cares" is totally theoretical. Such code simply
doesn't exist.

If you just opened a directory, and then did a "rmdir()" on that
directory, then you're just a f*cking moron if you go around saying
"ok, let me now do an fstat() on that fd to see if it really got
deleted or not". That's just _stupid_.

Really. There is absolutely no point in introducing a new rule that
nobody cares about, that we haven't followed ourselves historically,
and that would require us to play insane hacky games.

WHY DO IT? WHY CARE? WHY, WHY, WHY?

                        Linus
