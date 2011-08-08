Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1HHV5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:57:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53189 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1HHV5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:57:18 -0400
Date: Mon, 8 Aug 2011 23:57:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC][PATCH 2/2] x86, cpu, amd: Add a per-vendor BSP function
Message-ID: <20110808215713.GB22088@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
	X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	Borislav Petkov <borislav.petkov@amd.com>
References: <1312829872-20260-1-git-send-email-bp@amd64.org>
 <1312829872-20260-3-git-send-email-bp@amd64.org>
 <4E404D68.5060507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E404D68.5060507@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 03:56:08PM -0500, H. Peter Anvin wrote:
> On 08/08/2011 01:57 PM, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Add a per-vendor function which runs everything that needs to run once
> > on the BSP during boot. Concentrate AMD-specific functionality there.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> >  
> > +static void __init vendor_run_on_bsp(struct cpuinfo_x86 *c)
> > +{
> > +	switch (c->x86_vendor) {
> > +	case X86_VENDOR_AMD:
> > +		amd_run_on_bsp(c);
> > +		break;
> > +
> > +	default:
> > +		break;
> > +	}
> > +}
> > +
> 
> This is totally going backwards.  We *should* be using struct cpu_dev
> rather than switch statements for this.

Right, but all the cpu_dev things are annotated with __cpuinitconst
because they're used in CONFIG_HOTPLUG_CPU. __init, OTOH, will be
discarded once we're done booting. So, we can't convert cpu_dev
to __initdata because we need it for cpu hotplug and we want the
run_on_bsp() functionality to be __init since it runs once on boot.

Maybe leave cpu_dev in __cpuinit let it have an __init member which is
the ->run_on_bsp()? Does that even work?

Hmm..

-- 
Regards/Gruss,
    Boris.
