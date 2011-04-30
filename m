Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab1D3AR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:17:58 -0400
Received: from trent.utfs.org ([194.246.123.103]:37176 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759252Ab1D3AR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:17:57 -0400
Date: Fri, 29 Apr 2011 17:17:53 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110429201701.GA13166@x4.trippels.de>
Message-ID: <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <20110424234655.GC12436@dastard> <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org> <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org> <20110427022655.GE12436@dastard>
 <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org> <20110427102824.GI12436@dastard> <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org> <20110428233751.GR12436@dastard> <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
 <20110429201701.GA13166@x4.trippels.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 at 22:17, Markus Trippelsdorf wrote:
> I could be the hrtimer bug again. Would you try to reproduce the issue
> with this patch applied?
> http://git.us.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=ce31332d3c77532d6ea97ddcb475a2b02dd358b4

With that patch applied, the OOm killer still kicks in, this time the OOM 
messages were written to the syslog agian:

   http://nerdbynature.de/bits/2.6.39-rc4/oom/
   (The -9 files are the current ones)

Also, this time xfs did not show up in the backtrace:

ssh invoked oom-killer: gfp_mask=0x44d0, order=2, oom_adj=0, oom_score_adj=0
Call Trace:
[c22bfae0] [c0009d30] show_stack+0x70/0x1bc (unreliable)
[c22bfb20] [c009cd3c] T.545+0x74/0x1d0
[c22bfb70] [c009cf6c] T.543+0xd4/0x2a0
[c22bfbb0] [c009d3b4] out_of_memory+0x27c/0x360
[c22bfc00] [c00a199c] __alloc_pages_nodemask+0x6f8/0x708
[c22bfca0] [c00a19c8] __get_free_pages+0x1c/0x44
[c22bfcb0] [c00d283c] __kmalloc_track_caller+0x1c0/0x1dc
[c22bfcd0] [c036ff1c] __alloc_skb+0x74/0x140
[c22bfd00] [c0369b08] sock_alloc_send_pskb+0x23c/0x37c
[c22bfd70] [c03e8974] unix_stream_sendmsg+0x354/0x478
[c22bfde0] [c0364118] sock_aio_write+0x170/0x180
[c22bfe50] [c00d580c] do_sync_write+0xb8/0x144
[c22bfef0] [c00d68d0] vfs_write+0x1b8/0x1c0
[c22bff10] [c00d6a10] sys_write+0x58/0xc8
[c22bff40] [c00127d4] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0x2044cc14


Thanks,
Christian.
-- 
BOFH excuse #144:

Too few computrons available.
