Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0KGXAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:00:32 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:35714 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab0KGXAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:00:31 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 7 Nov 2010 14:59:27 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Matt Helsley <matthltc@us.ibm.com>
cc: Tejun Heo <tj@kernel.org>, Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
In-Reply-To: <20101106101209.GD11535@count0.beaverton.ibm.com>
Message-ID: <alpine.DEB.2.00.1011071032001.29896@davide-lnx1>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <4CD23087.30900@cs.columbia.edu> <4CD28033.1000700@kernel.org> <20101106101209.GD11535@count0.beaverton.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Nov 2010, Matt Helsley wrote:

> Yes, our patches touch a wide variety of kernel code. You have just failed
> to appreciate how "wide" the kernel ABI truly is. You can't really count
> it by number of syscalls, number of pseudo-filesystems, etc. There's
> also the intended behavior of those interfaces to consider. Each piece
> of checkpoint/restart code is relatively self-contained. This can be
> confirmed merely by looking at many of the patches we've already posted
> enabling checkpoint/restart of that feature. Until you've tried to
> implement checkpoint/restart for an interface or until you've bothered
> to review a patch for one of them (my favorite on is eventfd:
> http://www.mail-archive.com/devel@openvz.org/msg21565.html ) please
> don't tell us it's too complex. Then compare that with your proposed
> ghastly stack of userspace cards -- ptrace (really more like strace) +
> LD_PRELOAD + a daemon...
> 
> Incidentally, 20k lines of code is less than many pieces of the kernel.
> It's less than many:
> 
> Filesystems (I've selected ones designed for rotating media or networks usually..)
> 	ext4, nfs, ocfs2, xfs, reiserfs, ntfs, gfs2, jfs, cifs, ubifs, nilfs2, btrfs
> 
> Non-filesystem file-system support code:
> 	nfsd, nls
> 
> It's less than one of the simpler DRM graphics drivers -- i915:
> 	$ cd drivers/gpu/drm/i915
> 	$ wc -l *.[ch]
> 	...
> 	41481 total
> 
> It's less than any one of the lpfc, bfa, aic7xxx, qla2xxx, and mpt2sas
> drivers I see under scsi. Perhaps a more fair comparison might be to compare
> a single driver to a single checkpointable kernel interface but it's
> a more-fair comparison that skews even more in our favor.

Please, do not compare things like single file systems, drivers, or 
otherwise fairly isolated components, with this "thing".
This thing touches a freaky-large number of subsystems, effectively 
adding a glueage between them, which can might end up causing problems 
(and/or restrict design choices) in the future.
The naked patch looks like just a sugar coating to me, which left out 300+ 
lines of extra logic in epoll alone.
This is one of the widest, deepest, intrusive patches I have seen in a 
while, whose inclusion would require a little bit more than handwaving and 
continuous re-posting IMO.



- Davide


