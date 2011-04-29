Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab1D2OKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:10:33 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:24451 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885Ab1D2OKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:10:30 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzzz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKF3BG-02-2UK-02
X-M-MSG: 
Date: Fri, 29 Apr 2011 16:09:17 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 04/23] sched: Change NODE sched_domain group creation
Message-ID: <20110429140917.GD22001@alberich.amd.com>
References: <20110407120941.400629539@chello.nl>
 <20110407122941.978111700@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20110407122941.978111700@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 08:09:45AM -0400, Peter Zijlstra wrote:
> The NODE sched_domain is 'special' in that it allocates sched_groups
> per CPU, instead of sharing the sched_groups between all CPUs.
> 
> While this might have some benefits on large NUMA and avoid remote
> memory accesses when iterating the sched_groups, this does break
> current code that assumes sched_groups are shared between all
> sched_domains (since the dynamic cpu_power patches).
> 
> So refactor the NODE groups to behave like all other groups.
> 
> (The ALLNODES domain again shared its groups across the CPUs for some
> reason).
> 
> If someone does measure a performance decrease due to this change we

[...]

Will do some performance sniff tests to check this.


Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Alberto Bozzo, Andrew Bowd
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


