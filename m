Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab0DWPlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:41:12 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:45576 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab0DWPlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:41:08 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz14e0M62a3Lzz1202hzz6ff19hz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L1C684-01-DEK-02
X-M-MSG: 
Date: Fri, 23 Apr 2010 17:40:51 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] updates for oprofile
Message-ID: <20100423154050.GN6450@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 15:40:51.0430 (UTC) FILETIME=[5A5EA060:01CAE2FB]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

You might want to pull from 'for-next' instead that includes an
additional merge with tip/tracing/core to resolve conflicts with that
branch.

Thanks.

-Robert

--

commit b971f06187d83b5c03d2b597cccdfef421c0ca91
Merge: cb6e943 c1ab9ca
Author: Robert Richter <robert.richter@amd.com>
Date:   Fri Apr 23 16:47:51 2010 +0200

    Merge commit 'tip/tracing/core' into oprofile/core
    
    Conflicts:
        drivers/oprofile/cpu_buffer.c
    
    Signed-off-by: Robert Richter <robert.richter@amd.com>

commit cb6e943ccf19ab6d3189147e9d625a992e016084
Author: Andi Kleen <andi@firstfloor.org>
Date:   Thu Apr 1 03:17:25 2010 +0200

    oprofile: remove double ring buffering
    
    oprofile used a double buffer scheme for its cpu event buffer
    to avoid races on reading with the old locked ring buffer.
    
    But that is obsolete now with the new ring buffer, so simply
    use a single buffer. This greatly simplifies the code and avoids
    a lot of sample drops on large runs, especially with call graph.
    
    Based on suggestions from Steven Rostedt
    
    For stable kernels from v2.6.32, but not earlier.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: stable <stable@kernel.org>
    Signed-off-by: Robert Richter <robert.richter@amd.com>

commit a36bf32e9e8a86f291f746b7f8292e042ee04a46
Merge: bc078e4 01bf0b6
Author: Robert Richter <robert.richter@amd.com>
Date:   Fri Apr 23 14:30:22 2010 +0200

    Merge commit 'v2.6.34-rc5' into oprofile/core

commit bc078e4eab65f11bbaeed380593ab8151b30d703
Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date:   Tue Mar 2 16:01:10 2010 +0100

    oprofile: convert oprofile from timer_hook to hrtimer
    
    Oprofile is currently broken on systems running with NOHZ enabled.
    A maximum of 1 tick is accounted via the timer_hook if a cpu sleeps
    for a longer period of time. This does bad things to the percentages
    in the profiler output. To solve this problem convert oprofile to
    use a restarting hrtimer instead of the timer_hook.
    
    Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Robert Richter <robert.richter@amd.com>

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

