Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2FFJm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:42:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57420 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab2FFJm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:42:57 -0400
Date: Wed, 6 Jun 2012 11:42:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120606094254.GA4990@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Konrad Rzeszutek Wilk <konrad@darnok.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Jacob Shin <jacob.shin@amd.com>,
	Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
	xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
	Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
References: <20120530171754.GA5115@phenom.dumpdata.com>
 <20120530173247.GC15635@x1.osrc.amd.com>
 <4FC65D34.1060803@zytor.com>
 <20120530175150.GE15438@x1.osrc.amd.com>
 <4FC66037.6020506@zytor.com>
 <20120530181722.GF15438@x1.osrc.amd.com>
 <4FC664E1.9050504@zytor.com>
 <20120530223334.GB28417@andromeda.dapyr.net>
 <4FC6A897.6020005@zytor.com>
 <20120606092713.GB9495@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120606092713.GB9495@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:27:13AM +0200, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 05/30/2012 03:33 PM, Konrad Rzeszutek Wilk wrote:
> > > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > > index 75f33b2..e74df95 100644
> > > --- a/arch/x86/xen/enlighten.c
> > > +++ b/arch/x86/xen/enlighten.c
> > > @@ -1116,7 +1116,10 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
> > >  	.wbinvd = native_wbinvd,
> > >  
> > >  	.read_msr = native_read_msr_safe,
> > > +	.rdmsr_regs = native_rdmsr_safe_regs,
> > >  	.write_msr = xen_write_msr_safe,
> > > +	.wrmsr_regs = native_wrmsr_safe_regs,
> > > +
> > >  	.read_tsc = native_read_tsc,
> > >  	.read_pmc = native_read_pmc,
> > >  
> > 
> > Okay, tell me again:
> > 
> > why do we have these hooks again?  Can we please weed out 
> > paravirt methods that have no users?
> 
> ping?

I think we solved all that and hpa wanted to queue them up shortly:

http://marc.info/?l=linux-kernel&m=133856342618027&w=2

If it's easier, I can send you a pull request later.

Thanks.

-- 
Regards/Gruss,
    Boris.
