Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2ABLA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:00:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37827 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2ABLAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:00:55 -0500
Date: Mon, 2 Jan 2012 11:58:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
Message-ID: <20120102105856.GA6661@elte.hu>
References: <20111221123624.193898256@goodmis.org>
 <20120101180949.GA25066@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120101180949.GA25066@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Hm, i'm seeing spontaneous reboot crashes with these commits 
> applied. The reboots just happen out of the blue during an 
> allyesconfig bootup (config attached), and they happen at 
> random places.

I've done more testing to pin down which commits are to blame.

To complicate matters, re-testing with the NMI bits applied 
produced a spontaneous reboot as well in one case, after 12 
iterations.

Just to give you an impression of how a failure looks like, the 
serial console just stops printing mid-line:

 [   53.212942] calling  vt1211_init+0x0/0x9b @ 1                                                   
 [   53.212971] initcall vt1211_init+0x0/0x9b returned -19 after 23 usecs                           
 [   53.212975] calling  sm_vt8231_init+0x0/0x1b @ 1                                                
   Booting 'Fedora'

and the next message is GRUB's 'Booting ...' line.

I've tested baseline -tip as well:

    db6ffcaa1306: Merge branch 'out-of-tree'

and it seem to be fine: it has survived 70 allyesconfig bootups 
with the config i sent.

So either the NMI bits or the 'fixes' bits are broken - or the 
bug is somehow kernel image dependent and triggered in these two 
trees and somehow left the baseline kernel unaffected ...

Since each test takes half a day to accomplish and i don't have 
the days to spend on this problem alone, one way we could 
proceed from here is if you cherry-picked the '100% safe' 
commits from your tree. I could pull those and make certain that 
they are not crashing things.

Thanks,

	Ingo
