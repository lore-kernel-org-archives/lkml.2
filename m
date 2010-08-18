Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab0HRD2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 23:28:52 -0400
Received: from smtp-out.google.com ([74.125.121.35]:50834 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0HRD2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 23:28:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=D9whEex+nqIMQ7VUrZ1djjEI0/asINII1SN5mvP58RvL3eXBInU3N1IiPzmh/4fkt
	Mjn5TvcmIo5IUbvcq/sVQ==
Date: Tue, 17 Aug 2010 20:28:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: hughd@google.com, tim.c.chen@linux.intel.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc1] List corruption when using initrd.
In-Reply-To: <201008180113.o7I1DXg6077317@www262.sakura.ne.jp>
Message-ID: <alpine.LSU.2.00.1008172022140.2868@sister.anvils>
References: <201008170517.o7H5HbCT002910@www262.sakura.ne.jp> <201008170751.o7H7pmAl038739@www262.sakura.ne.jp> <alpine.LSU.2.00.1008171523270.2106@sister.anvils> <201008180113.o7I1DXg6077317@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010, Tetsuo Handa wrote:
> Hugh Dickins wrote:
> > Thanks for reporting and bisecting.  Certainly there's a bug in shmem
> > (that we ought to have caught long before it reached 36-rc1: sorry),
> > and it is probably the cause of your crashes; but it's possible there's
> > a similar bug elsewhere too, something else messing up the percpu_counters
> > list - so please check if the patch below really does fix it for you.
> 
> This patch solved the list_add() corruption messages and

Great.

> "[2.6.36-rc1] Bugs in __free_pipe_info()".

That's good, but puzzling.  I'll mention it in the patch comment, since
that's what you've found: but I've given up trying to understand how.

> 
> > I notice your dmesg also showed fs/inode.c:692 unlock_new_inode()
> > warnings from get_cramfs_inode(): those would be unrelated, and
> > probably from Al Viro's recent changes in cramfs/inode.c - Cc'ed.
> unlock_new_inode() warnings remain after applying this patch.
> 
> Thank you.

Bigger thanks to you.  Patch to Linus follows.

Hugh
