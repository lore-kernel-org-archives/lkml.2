Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2E2S64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 14:58:56 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:30293
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029Ab2E2S6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 14:58:55 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h93fhd25hf0ah)
X-WSS-ID: 0M4SSPY-01-3WP-02
X-M-MSG: 
Date: Tue, 29 May 2012 20:58:43 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
Message-ID: <20120529185843.GA20289@alberich.amd.com>
References: <1337857490.7300.19.camel@marge.simpson.net>
 <1337865431.9783.148.camel@laptop>
 <1337865641.9783.149.camel@laptop>
 <1337926468.5415.48.camel@marge.simpson.net>
 <1338014259.7302.26.camel@marge.simpson.net>
 <1338017364.14636.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1338017364.14636.9.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 09:29:24AM +0200, Peter Zijlstra wrote:
> On Sat, 2012-05-26 at 08:37 +0200, Mike Galbraith wrote:
> 
> > Ew. 3.4 went broke for Q6600, and performance went... far far away.
> > 
> > [    0.200057] CPU0 attaching sched-domain:
> > [    0.204016]  domain 0: span 0-3 level MC
> > [    0.208015]   groups: 0 1 2 3
> > [    0.210970] CPU1 attaching sched-domain:
> > [    0.212014]  domain 0: span 0-3 level MC
> > [    0.216016]   groups: 1 2 3 0
> > [    0.220016] CPU2 attaching sched-domain:
> > [    0.224015]  domain 0: span 0-3 level MC
> > [    0.228016]   groups: 2 3 0 1
> > [    0.232015] CPU3 attaching sched-domain:
> > [    0.236016]  domain 0: span 0-3 level MC
> > [    0.240017]   groups: 3 0 1 2
> 
> 
> Oh yikes, I guess I wrecked
> arch/x86/kernel/smpboot.c:cpu_coregroup_mask() in
> 8e7fbcbc22c12414bcc9dfdd683637f58fb32759.
> 
> That should very much always return llc mask, I just got that AMD case
> confused. It looks like it should look like:
> 
> 
> const struct cpumask *cpu_coregroup_mask(int cpu)
> {
> 	return cpu_llc_mask(cpu);
> }
> 
> And the AMD_DCM check was just to undo powersavings damage on
> Magny-Cours or somesuch.

IIRC returning cpu_core_mask() could even cause a panic in the
scheduler, because the hierarchy of scheduling groups/domains was
broken.
 
> Andreas?

Returning cpu_llc_mask is the right thing to do on AMD.



Andreas


