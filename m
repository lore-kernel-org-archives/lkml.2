Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2AIQDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:03:39 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:36887 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2AIQDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:03:36 -0500
Date: Mon, 9 Jan 2012 21:33:17 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120109160317.GA29142@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
 <1326103578.2442.50.camel@twins>
 <1326104915.2442.53.camel@twins>
 <20120109110025.GA7988@dirshya.in.ibm.com>
 <1326119707.2442.77.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1326119707.2442.77.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010916-9574-0000-0000-000000D8AE40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-01-09 15:35:07]:

> On Mon, 2012-01-09 at 16:30 +0530, Vaidyanathan Srinivasan wrote:
> > Lets combine the MC/SMT options and create sched_powersavings={0,1,2}
> > That will make it only one sysfs knob without any dependencies.
> > 
> Is there really any sane rationale to keep the 1/2 thing? Why not have a
> single boolean knob that says performance/power?

Yes, based on the architecture and topology, we do have two sweet
spots for power vs performance trade offs.  The first level should be
to reduce power savings with marginal performance impact and second
one will be to go for the most aggressive power savings.

The first one should generally be recommended as default to have
a right balance between performance and power savings, while the
second one should be used for reducing power consumption on
unimportant workloads or under certain constraints.

Some example policies:

sched_powersavings=1:

        Enable consolidation at MC level

sched_powersavings=2:

        Enable aggressive consolidation at MC level and SMT level if
        available. In case arch can benefit from cross node
        consolidation, then enable it.

Having the above simple split in policy will enable wide adoption
where the first level can be a recommended default.  Having just
a boolean enable/disable will mean the end-user will have to decide
when to turn on and later off for best workload experience.

Just similar to cpufreq policy of performance, ondemand and powersave.
They have their unique use cases and this design choice helps us ship
ondemand as default.

--Vaidy

