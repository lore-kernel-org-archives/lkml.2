Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2DPRcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:32:13 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:29460
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab2DPRcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:32:11 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh668h839h944hd25hd2bh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2L21A-02-86W-02
X-M-MSG: 
Date: Mon, 16 Apr 2012 19:31:46 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        <mingo@redhat.com>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <sp@numascale.com>, <bp@amd64.org>, <tglx@linutronix.de>,
        <daniel@numascale-asia.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH resend] x86/platform: Remove incorrect error message in
 x86_default_fixup_cpu_id()
Message-ID: <20120416173146.GA4838@aftab>
References: <20120224153127.GD28921@alberich.amd.com>
 <tip-20b25f03fbd17b4e32b786024a5f9c6306795411@git.kernel.org>
 <20120302110440.GA24019@elte.hu>
 <20120302115130.GA17876@alberich.amd.com>
 <20120402160648.GR27684@alberich.amd.com>
 <20120404123809.GB5193@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120404123809.GB5193@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 02:38:09PM +0200, Borislav Petkov wrote:
> On Mon, Apr 02, 2012 at 06:06:48PM +0200, Andreas Herrmann wrote:
> > 
> > It's only called from amd.c:srat_detect_node(). The introduced
> > condition for calling the fixup code is true for all AMD multi-node
> > processors, e.g. Magny-Cours and Interlagos. There we have 2 NUMA
> > nodes on one socket. Thus there are cores having different
> > numa-node-id but with equal phys_proc_id.
> > 
> > There is no point to print error messages in such a situation.
> > 
> > The confusing/misleading error message was introduced with commit
> > 64be4c1c2428e148de6081af235e2418e6a66dda (x86: Add x86_init platform
> > override to fix up NUMA core numbering).
> > 
> > Remove the default fixup function (especially the error message) and
> > replace it by a NULL pointer check, move the Numascale-specific
> > condition for calling the fixup into the fixup-function itself and
> > slightly adapt the comment.
> > 
> > Cc: <stable@kernel.org>
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  arch/x86/include/asm/x86_init.h      |    1 -
> >  arch/x86/kernel/apic/apic_numachip.c |    7 +++++--
> >  arch/x86/kernel/cpu/amd.c            |    7 ++++---
> >  arch/x86/kernel/cpu/common.c         |    9 ---------
> >  arch/x86/kernel/x86_init.c           |    1 -
> >  5 files changed, 9 insertions(+), 16 deletions(-)
> > 
> > This patch didn't make it into v3.3.
> > But the misleading error message introduced with numachip support was
> > merged.
> 
> Yes, please apply this one, I still get the following on my box with
> 3.4-rc1+:
> 
> [    0.382396] Booting Node   0, Processors  #1 #2 #3 #4 #5 Ok.
> [    0.454471] Booting Node   1, Processors  #6
> [    0.469600] NUMA core number 1 differs from configured core number 0
> [    0.478361]  #7
> [    0.490949] NUMA core number 1 differs from configured core number 0
> [    0.499695]  #8
> [    0.512577] NUMA core number 1 differs from configured core number 0
> [    0.521331]  #9
> [    0.533921] NUMA core number 1 differs from configured core number 0
> [    0.542679]  #10
> [    0.555340] NUMA core number 1 differs from configured core number 0
> [    0.564088]  #11
> [    0.576730] NUMA core number 1 differs from configured core number 0

Still happens on -rc3. Ingo, can we please merge the above fix before 3.4
is out?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

