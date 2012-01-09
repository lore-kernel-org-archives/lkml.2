Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab2AIQNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:13:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:43439 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab2AIQNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:13:32 -0500
Message-ID: <1326125597.2442.90.camel@twins>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Paul Turner <pjt@google.com>
Date: Mon, 09 Jan 2012 17:13:17 +0100
In-Reply-To: <20120109160317.GA29142@dirshya.in.ibm.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	 <1326103578.2442.50.camel@twins> <1326104915.2442.53.camel@twins>
	 <20120109110025.GA7988@dirshya.in.ibm.com> <1326119707.2442.77.camel@twins>
	 <20120109160317.GA29142@dirshya.in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 21:33 +0530, Vaidyanathan Srinivasan wrote:

> Yes, based on the architecture and topology, we do have two sweet
> spots for power vs performance trade offs.  The first level should be
> to reduce power savings with marginal performance impact and second
> one will be to go for the most aggressive power savings.

Colour me unconvinced, cache heavy workloads will suffer greatly from
your 1.

> The first one should generally be recommended as default to have
> a right balance between performance and power savings, while the
> second one should be used for reducing power consumption on
> unimportant workloads or under certain constraints.
> 
> Some example policies:
> 
> sched_powersavings=1:
> 
>         Enable consolidation at MC level
> 
> sched_powersavings=2:
> 
>         Enable aggressive consolidation at MC level and SMT level if
>         available. In case arch can benefit from cross node
>         consolidation, then enable it.

You fail for mentioning MC/SMT..

> Having the above simple split in policy will enable wide adoption
> where the first level can be a recommended default.  Having just
> a boolean enable/disable will mean the end-user will have to decide
> when to turn on and later off for best workload experience.

Picking one of two states is too hard, hence we given them one of three
states to pick from.. How does that make sense?

> Just similar to cpufreq policy of performance, ondemand and powersave.
> They have their unique use cases and this design choice helps us ship
> ondemand as default.

You fail for thinking having multiple cpufreq governors is a good thing.
The result is that they all suck.
