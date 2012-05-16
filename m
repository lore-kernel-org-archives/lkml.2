Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567Ab2EPTlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:41:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:52182 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab2EPTlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:41:08 -0400
Message-ID: <1337197242.4281.6.camel@twins>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Vincent Guittot <vincent.guittot@linaro.org>, paulmck@linux.vnet.ibm.com,
        smuckle@quicinc.com, khilman@ti.com, Robin.Randhawa@arm.com,
        suresh.b.siddha@intel.com, thebigcorporation@gmail.com,
        venki@google.com, panto@antoniou-consulting.com, mingo@elte.hu,
        paul.brett@intel.com, pdeschrijver@nvidia.com, pjt@google.com,
        efault@gmx.de, fweisbec@gmail.com, geoff@infradead.org,
        rostedt@goodmis.org, tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
Date: Wed, 16 May 2012 21:40:42 +0200
In-Reply-To: <20120516184956.GA23058@dirshya.in.ibm.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	 <1337084609.27020.156.camel@laptop>
	 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	 <1337086834.27020.162.camel@laptop>
	 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	 <1337096141.27694.82.camel@twins>
	 <20120516184956.GA23058@dirshya.in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 00:19 +0530, Vaidyanathan Srinivasan wrote:

> Let me take a case of two-socket,quad-core,HT x86 (Nehalem):
> 
> SDTL_SHARE_POWERLINE should be passed along with a cpumask that
> represents sd_init_CPU or cpu_cpu_mask today.  So the number of
> domains we build per-cpu will depend on the topology and the
> sched_powersavings settings. 

No, the topology should at all time be independent of powersavings,
current x86's topology depending on that is one of the biggest warts
ever. Also sched_powersavings, doesn't actually exist anymore.

The NHM-EP from your example should do just two levels since mc and cpu
are identical, I guess we could add a pass that merges identical masks
so you can still specify 3 levels if you want.

The NUMA stuff is done automatically based on SLIT, so you don't need to
go above the socket level.
