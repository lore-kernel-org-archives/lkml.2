Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0JNGbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 02:31:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34727 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab0JNGbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 02:31:41 -0400
Date: Thu, 14 Oct 2010 08:31:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
Message-ID: <20101014063127.GA3664@elte.hu>
References: <20101014164925.4fa16b75.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014164925.4fa16b75.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> After merging the final tree, linux-next builds (arm corgi_defconfig,
> spitz_defconfig) fail like this:
> 
> arch/arm/kernel/perf_event.c: In function 'armpmu_event_init':
> arch/arm/kernel/perf_event.c:543: error: request for member 'num_events' in something
 not a structure or union
> 
> Caused by commit 15ac9a395a753cb28c674e7ea80386ffdff21785 ("perf: Remove
> the sysfs bits").

Thanks, fixed.

> This seems to have broken in next-20100913 and noone has noticed/bothered
> to fix it.

What appears to have happened is the following: the build bug depends on 
CONFIG_HW_PERF_EVENTS=y, which is off by default on ARM (which default 
to a v5 CPU type - while hw pmu support is for v6+ cpus).

So the regular ARM defconfig built fine both in -next and here in the 
latest perf/core tree:

  testing        arm:  -git:  pass (    0),  -tip:  pass (    4)

Some new change in linux-next appears to have turned on HW_PERF_EVENTS 
elsewhere which you thus tested for the first time - which triggered the 
build bug.

Thanks,

	Ingo
