Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0FXOTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:19:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53868 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0FXOTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:19:16 -0400
To: Andy Lutomirski <luto@mit.edu>
CC: npiggin@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       drepper@redhat.com, torvalds@linux-foundation.org
In-reply-to: <4C2366F7.5010200@mit.edu> (message from Andy Lutomirski on Thu,
	24 Jun 2010 10:08:55 -0400)
Subject: Re: [rfc] new stat*fs-like syscall?
References: <20100624131455.GA10441@laptop> <4C2366F7.5010200@mit.edu>
Message-Id: <E1ORnGc-0008CL-Uo@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Jun 2010 16:18:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010, Andy Lutomirski wrote:
> Something like fsid but actually specified to uniquely identify a 
> superblock.  (Currently, fsid seems to be set by the filesystem, and 
> nothing in particular ensures that two different filesystems couldn't 
> have collisions.)  We could guarantee (or have a flag guaranteeing) that 
> (fsid, st_inode) actually uniquely identifies an inode.
> 
> Similarly, something like fsid that uniquely identifies the vfsmount 
> could be useful, although I don't know how easy that would be to provide 
> for fstat?fs.
> 
> If we could expose the complete set of filesystem mount options so that 
> mount(1) didn't have to look at /proc/self/mounts or /etc/mtab, then 
> playing with chroots would be that much easier.
> 
> Should we expose superblock and vfsmount options separately?  We have 
> read-only bind mounts now, but the way they work is rather inscrutable, 
> and if stat?fs could say "superblock is read-write but vfsmount is 
> readonly" then people might be able to make more sense of what's going on.

You'll find all of those things in /proc/self/mountinfo.

Thanks,
Miklos
