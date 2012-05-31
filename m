Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2EaPfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:35:38 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:38270 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab2EaPfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:35:36 -0400
Date: Thu, 31 May 2012 11:27:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andre Przywara <andre.przywara@amd.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, jeremy@goop.org,
        xen-devel@lists.xensource.com, Jacob Shin <jacob.shin@amd.com>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120531152702.GC9876@phenom.dumpdata.com>
References: <20120530150334.GA13349@jshin-Toonie>
 <20120530171754.GA5115@phenom.dumpdata.com>
 <20120530173247.GC15635@x1.osrc.amd.com>
 <4FC65D34.1060803@zytor.com>
 <20120530175150.GE15438@x1.osrc.amd.com>
 <4FC66037.6020506@zytor.com>
 <20120530181722.GF15438@x1.osrc.amd.com>
 <4FC664E1.9050504@zytor.com>
 <20120530223334.GB28417@andromeda.dapyr.net>
 <4FC762F8.902@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC762F8.902@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> >index 75f33b2..e74df95 100644
> >--- a/arch/x86/xen/enlighten.c
> >+++ b/arch/x86/xen/enlighten.c
> >@@ -1116,7 +1116,10 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
> >  	.wbinvd = native_wbinvd,
> >
> >  	.read_msr = native_read_msr_safe,
> >+	.rdmsr_regs = native_rdmsr_safe_regs,
> >  	.write_msr = xen_write_msr_safe,
> >+	.wrmsr_regs = native_wrmsr_safe_regs,
> >+
> >  	.read_tsc = native_read_tsc,
> >  	.read_pmc = native_read_pmc,
> >
> >
> 
> Acked-by: Andre Przywara <andre.przywara@amd.com>
> 
> This works on the test machine.

Great! Thanks for doing a quick test for this.
> 
> Though I'd still like to have my original patch applied, because it
> makes the thing a bit cleaner.

OK. Please re-send with an up-to-date git commit as suggested
by Peter.

> 
> And I made a patch to remove the {rd,wr}msr_regs hooks from
> paravirt_ops completely. Shall I send it out or do you want to make
> this part of larger patch series to clean up pvops?

Please do send it out. Thanks again!
