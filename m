Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab1CCVaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:30:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37755 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737Ab1CCVaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:30:18 -0500
Date: Thu, 3 Mar 2011 21:30:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
Message-ID: <20110303213016.GP22723@ZenIV.linux.org.uk>
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
 <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
 <20110303060352.GK22723@ZenIV.linux.org.uk>
 <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
 <87tyfk7x0c.fsf@devron.myhome.or.jp>
 <AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 01:02:50PM -0800, Linus Torvalds wrote:

> > So we have to simulate some levels. I guess you
> > are not saying we don't need to care it at all though.
> 
> I'm saying that it should just work to set i_nlink=1 and not do
> anything at all. Ever. It's a valid model for directory counts.

Sure, no problem.  Just leave that cleaning of i_nlink on victim
in unlink/rmdir/rename; we *really* rely on that in e.g. deciding
when to free the damn inode in fat_evict_inode().

We need to mark them for freeing _anyway_, right?  It doesn't depend
on what exact value do we keep for live directories - "everyone got 1
for as long as they live" is just fine, and IMO it's a win, but it's
an unrelated question.
