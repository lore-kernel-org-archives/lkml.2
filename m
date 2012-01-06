Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab2AFC1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:27:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35809 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2AFC1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:27:39 -0500
Date: Thu, 5 Jan 2012 18:27:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Message-ID: <20120106022734.GB6276@google.com>
References: <4EF9291D.7030208@cn.fujitsu.com>
 <20111227163535.GA17712@google.com>
 <4EFAB2E2.4040008@cn.fujitsu.com>
 <20111228163631.GN17712@google.com>
 <4EFBD55E.5030106@cn.fujitsu.com>
 <20111229162313.GD3516@google.com>
 <4EFD531C.50300@cn.fujitsu.com>
 <20120105174507.GC18486@google.com>
 <4F065B6F.6060506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F065B6F.6060506@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 06, 2012 at 10:24:47AM +0800, Li Zefan wrote:
> There's a corner case where "mount --bind" can't be used:
> 
> 	# mount -t cgroup -o none,name=hier1 xxx /mnt
> 	# mkdir /mnt/tmp
> 	# umount /mnt
> 
> Since there's a sub-cgroup in it, umount won't destroy the hierarchy,
> but "hide" it, so the name=xxx is necessary to re-mount it.
>
> > Also, what's the use case for
> > mounting the same cgroup directory multiple times?  Why is that
> > necessary?  Is it useful for some namespace-savvy setup?
> 
> I don't have a use case in real life. It was made so at the very
> beginning of cgroup, and we should't break it without strong reasons.
> We can mount other pseudo filesystems like procfs, sysfs and debugfs
> multiple times, right?

Yeah, we shouldn't break it so I applied the patch with a lot of
grumbling.  This is something which shouldn't have existed at all. :(

Thanks a lot for the explanation and patience.

-- 
tejun
