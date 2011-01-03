Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1ACOoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:44:34 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:49738
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762Ab1ACOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:44:33 -0500
X-SpamScore: -22
X-BigFish: VPS-22(zzbb2cK146fK1432N98dN148cMzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEGBLV-01-DV5-02
X-M-MSG: 
Date: Mon, 3 Jan 2011 15:44:20 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        "atswartz@gmail.com" <atswartz@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Dan Carpenter <error27@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] arch/x86/oprofile/op_model_amd.c: perform
 initialisation on a single CPU
Message-ID: <20110103144420.GN4739@erda.amd.com>
References: <20101230173847.GA2734@elte.hu>
 <20110103111514.GM4739@erda.amd.com>
 <20110103120310.GA23927@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110103120310.GA23927@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I tested your patch and it fixes the bug too.

On 03.01.11 07:03:10, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> >  static void init_ibs(void)
> >  {
> >  	ibs_caps = get_ibs_caps();
> 
> this get_ibs_caps() call is percpu too - still it now runs with preempt off.

get_ibs_caps() uses the cpuid instruction and this is percpu. But
mixed silicon support does not allow the use of different cpus with
different cpuid features in one system, so it should be save to use it
with preemption enabled.

Also, since the check uses a combination of boot_cpu_has() and
cpuid_eax(), disabling preemption would not help here. We would have
to pin the init code to the boot cpu then. Suppose a boot cpu with ibs
enabled and a secondary (init) cpu with ibs disabled. This will crash
the system when accessing ibs msrs.

Anyway, I am fine with your change.

> 
> > +		printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n",
> > +		       (unsigned)ibs_caps);
> 
> that cast looks ugly and unnecessary.

Yes, this cast is unnecessary.

> 
> I fixed both in the commit below. (not tested yet)

Thanks for looking at this,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

