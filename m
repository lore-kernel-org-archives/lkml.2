Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979Ab0HREKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 00:10:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50374 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab0HREKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 00:10:09 -0400
X-Nat-Received: from [202.181.97.72]:50327 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1282104591.5403
Message-Id: <201008180409.o7I49pof033727@www262.sakura.ne.jp>
Subject: Re: [2.6.36-rc1] List corruption when using initrd.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: hughd@google.com
Cc: tim.c.chen@linux.intel.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 18 Aug 2010 13:09:51 +0900
References: <201008170517.o7H5HbCT002910@www262.sakura.ne.jp> <201008170751.o7H7pmAl038739@www262.sakura.ne.jp> <alpine.LSU.2.00.1008171523270.2106@sister.anvils> <201008180113.o7I1DXg6077317@www262.sakura.ne.jp> <alpine.LSU.2.00.1008172022140.2868@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1008172022140.2868@sister.anvils>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 17082010 #4137160, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> > "[2.6.36-rc1] Bugs in __free_pipe_info()".
> 
> That's good, but puzzling.  I'll mention it in the patch comment, since
> that's what you've found: but I've given up trying to understand how.

Yeah, it's puzzling. What I was doing is

  ./newns ./foo | grep -vF OK

where "./newns" calls mount("tmpfs") after clone(CLONE_NEWNS)
and ./foo calls chroot()/mount("tmpfs")/umount()/pivot_root() etc.

After applying your patch, I can no longer reproduce __free_pipe_info() errors.
I don't know why __free_pipe_info() errors are reported on "grep" rather than
"newns" or "foo". But if the cause of __free_pipe_info() errors was memory
corruption by the bug in shmem, it is possible that fixing the bug in shmem
solves __free_pipe_info() errors.

Thanks.
