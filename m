Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab1AOJHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 04:07:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46983 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab1AOJHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 04:07:05 -0500
Date: Sat, 15 Jan 2011 09:07:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 15 (Call Trace in fs/dcache.c +
 autofs4)
Message-ID: <20110115090702.GK19804@ZenIV.linux.org.uk>
References: <AANLkTik4JfjBEurjX4T3sAtGf9CPJvQYkV5aZWgE=XD1@mail.gmail.com>
 <AANLkTin0SUG3Q3aHVfBqCV8=iWThy3MTfG90ikMsrox9@mail.gmail.com>
 <20110115075723.GJ19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110115075723.GJ19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 07:57:23AM +0000, Al Viro wrote:
> On Sat, Jan 15, 2011 at 08:46:20AM +0100, Sedat Dilek wrote:
> 
> > Will try the patch from [1] as there was no feedback yet.
> > 
> > - Sedat -
> > 
> > [1] https://lkml.org/lkml/2011/1/12/394
> 
> There's also vfsmount refcounting breakage somewhere in automount series,
> unfortunately caught only when redoing said refcounting on top of it [1] ;-/
> I'm bisecting it right now, will post when it's done.
> 
> [1] with mnt{get,put}_long() variant the breakage is present, but not
> immediately noticable.  With (local) rewrite to saner rules it became
> visible, but I spent quite a while trying to find the bug in the most
> obvious place - i.e. that rewrite.

Argh...  In __do_follow_link() replace

	if (link->mnt != nd->path.mnt)
with
	if (link->mnt == nd->path.mnt)

Mismerge yesterday ;-/  I've pushed fix for that in for-next, will fold
shortly.  As for autofs4 breakage, I've a preliminary fix, testing it
now.
