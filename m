Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2HCJn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:43:26 -0400
Received: from osrc3.amd.com ([217.9.48.20]:46095 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab2HCJnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:43:25 -0400
Date: Fri, 3 Aug 2012 11:43:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [ 33/73] x86, microcode: Sanitize per-cpu microcode reloading
 interface
Message-ID: <20120803094314.GB31792@aftab.osrc.amd.com>
References: <20120731044310.013763753@decadent.org.uk>
 <20120731044316.585695559@decadent.org.uk>
 <87y5lw73eh.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5lw73eh.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 11:04:06AM +0200, Sven Joachim wrote:
> On 2012-07-31 06:43 +0200, Ben Hutchings wrote:
> 
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> Alas, this does not build if CONFIG_SMP is unset:
> 
> ,----
> | arch/x86/kernel/microcode_core.c: In function 'reload_store':
> | arch/x86/kernel/microcode_core.c:304:19: error: 'struct cpuinfo_x86' has no member named 'cpu_index'
> `----

Crap. :-(

3.2 still has this:

<arch/x86/include/asm/processor.h>:
...
#ifdef CONFIG_SMP
        /* number of cores as seen by the OS: */
        u16                     booted_cores;
        /* Physical processor id: */
        u16                     phys_proc_id;
        /* Core id: */
        u16                     cpu_core_id;
        /* Compute unit id */
        u8                      compute_unit_id;
        /* Index into per_cpu list: */
        u16                     cpu_index;
#endif
        u32                     microcode;
} __attribute__((__aligned__(SMP_CACHE_BYTES)));
---

which got removed by

commit 141168c36cdee3ff23d9c7700b0edc47cb65479f
Author: Kevin Winchester <kjwinchester@gmail.com>
Date:   Tue Dec 20 20:52:22 2011 -0400

    x86: Simplify code by removing a !SMP #ifdefs from 'struct cpuinfo_x86'

Ben, you might want to backport this one too... I'll run a couple of 3.2
builds with it ontop of 3.2 to verify nothing else breaks.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
