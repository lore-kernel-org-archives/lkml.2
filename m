Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2AILM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:12:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52694 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab2AILMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:12:55 -0500
Message-ID: <1326107563.2442.65.camel@twins>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Date: Mon, 09 Jan 2012 12:12:43 +0100
In-Reply-To: <20120110001445.GA20542@linux-youquan.bj.intel.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	 <1326103578.2442.50.camel@twins>
	 <20120110001445.GA20542@linux-youquan.bj.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 19:14 -0500, Youquan Song wrote:
> > Yes it is.. also that knob should die! Like i've been saying for way too
> > long. I'm >< close to committing a patch removing all the power_saving
> > magic from the scheduler.
> Sorry. I do not notice it.

I hadn't posted it before, but just about every time people post
something related to smt/mc power balancing I say this needs to get
cleaned up. Since telling people doesn't seem to have any effect what so
ever, stronger measures are needed.

> But currently in many real tests, the knob prove to save power in semi-idle system.
> They are useful in many user scenarios currently.

I'm not saying the stuff is without merit, I'm just saying that a) the
interface is utter crap and b) nobody seems to spend enough time on it
to 1) understand the load-balancer so that 2) he can integrate the power
saving stuff properly.

Instead I get one sporadic band-aid after another.

Also, fundamentally, the split between {smt/mc/numa/book}_power_savings
is completely and fundamentally broken, nobody cares about the actual
topology.
