Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2FLM5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:57:07 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58152 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117Ab2FLM5E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:57:04 -0400
MIME-Version: 1.0
Date: Tue, 12 Jun 2012 20:57:02 +0800
Message-ID: <CAJRGBZw2TctmBxRuA-byaGNCs=1v+M-1PXSm+OuwWApSqu7UjA@mail.gmail.com>
Subject: What is the right practice to get new code upstream( was Fwd: [patch]
 a simple hardware detector for latency as well as throughput ver. 0.1.0)
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
        sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>,
        jcm@jonmasters.org, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I must have forgotten cc key persons. Sorry to make noise again.
I need to know what the right practice is to get your attention to
accept a new tool upstream like this one.

About the tool:

It's unique. It's simple. But it's valuable, But it's still a starting point.

The tool is based on Jcm's latency testing tool in RT tree to detect
SMI caused problem.
Basically it's a testing tool to measure latency and bandwidth of raw
hardware instructions and component functions exclusively in
stop_machine context. It's a kernel module that can be run separately
from kernel boot. The Goal is to test out hardware/BIOS caused
problems in 2 minutes. To me, capable of measuring the intrinsic of
hardware on which we build our software is always a better idea than
blindly looking for data from any documents. In current version of the
tool, we have a basic sampling facility and TSC test ready for x86. I
plan to add more test into this tool to enrich our tool set in Linux.

Any inputs are appreciated. :-)

Thanks for your time.
/l

---------- Forwarded message ----------
From: Luming Yu <luming.yu@gmail.com>
Date: Tue, Jun 12, 2012 at 11:42 AM
Subject: Fwd: [patch] a simple hardware detector for latency as well
as throughput ver. 0.1.0
To: LKML <linux-kernel@vger.kernel.org>


Hello everyone,

I'm trying to push a new tool upstream. I'd like to hear back from you
what the best practice is to get the job done.

Thanks,
Luming


---------- Forwarded message ----------
From: Luming Yu <luming.yu@gmail.com>
Date: Mon, Jun 11, 2012 at 9:59 PM
Subject: Fwd: [patch] a simple hardware detector for latency as well
as throughput ver. 0.1.0
To: sfr@canb.auug.org.au
Cc: Andrew Morton <akpm@linux-foundation.org>, jcm@jonmasters.org,
linux-next@vger.kernel.org


Hi,

I'd like to know if the patch looks good for linux-next to find its
way upstream in 3.6.

Thanks and regards,
Luming


---------- Forwarded message ----------
From: Luming Yu <luming.yu@gmail.com>
Date: Wed, May 30, 2012 at 7:47 AM
Subject: Fwd: [patch] a simple hardware detector for latency as well
as throughput ver. 0.1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jcm@jonmasters.org


Hello akpm,

I'd like to push the patch to upstream, but I'm not sure if jcm has
extra bandwidth although he is also interested in having the tool
upstream..So I'd like ping you to check if there is any chance to
queue it up in your tree first.I will enhance it further after it's
upstream.

Thanks,
Luming



---------- Forwarded message ----------
From: Luming Yu <luming.yu@gmail.com>
Date: Tue, May 29, 2012 at 4:37 AM
Subject: [patch] a simple hardware detector for latency as well as
throughput ver. 0.1.0
To: jcm@jonmasters.org
Cc: linux-kernel@vger.kernel.org


Hi Jon,

The patch is the fist step to test some basic hardware functions like
TSC to help people understand if there is any hardware latency as well as
throughput problem exposed on bare metal or left behind by BIOS or
interfered by SM. Currently the patch tests hardware features
(tsc,freq, and rdrandom whiich is new instruction to get random
number) in stop_machine context. I will add more after the first step
get merged for those guys who want to directly play with new hardware
functions.

I suppose I can add your signed-off-by as the code is derived from your
hwlat_dector.

I'm also reuqesting if you are going to queue it up somewhere that can
be pulled into 3.5.

Of cause, I will update the patch based upon any comments that you
think must be fixed for 3.5 merge.

Thanks,
Luming


Signed-off-by Luming Yu <luming.yu@intel.com>


 Kconfig   |    7
 Makefile  |    2
 hw_test.c |  954
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 963 insertions(+)
