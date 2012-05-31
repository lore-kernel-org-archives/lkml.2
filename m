Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab2EaQz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:55:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36439 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab2EaQz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:55:28 -0400
Date: Thu, 31 May 2012 18:55:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andre Przywara <andre.przywara@amd.com>, Jacob Shin <jacob.shin@amd.com>,
        mingo@elte.hu, jeremy@goop.org, tglx@linutronix.de,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120531165522.GA3834@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jan Beulich <JBeulich@suse.com>,
	Andre Przywara <andre.przywara@amd.com>,
	Jacob Shin <jacob.shin@amd.com>, mingo@elte.hu, jeremy@goop.org,
	tglx@linutronix.de, xen-devel@lists.xensource.com,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Yinghai Lu <yinghai@kernel.org>
References: <20120530144851.GA12184@jshin-Toonie>
 <20120530145005.GI3207@phenom.dumpdata.com>
 <20120530150334.GA13349@jshin-Toonie>
 <20120530171754.GA5115@phenom.dumpdata.com>
 <20120530173247.GC15635@x1.osrc.amd.com>
 <4FC65D34.1060803@zytor.com>
 <20120530175150.GE15438@x1.osrc.amd.com>
 <4FC66037.6020506@zytor.com>
 <20120530181722.GF15438@x1.osrc.amd.com>
 <4FC73C430200007800087137@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC73C430200007800087137@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 08:39:15AM +0100, Jan Beulich wrote:
> >>> On 30.05.12 at 20:17, Borislav Petkov <bp@alien8.de> wrote:
> > On Wed, May 30, 2012 at 11:00:23AM -0700, H. Peter Anvin wrote:
> > The other place where we use the amd_safe variants is an obscure K8,
> > revC and earlier fix for _some_ BIOSen and this hasn't bitten us yet
> > so I'm assuming people haven't run xen on such boxes yet. Does it need
> > fixing? Probably, if we really really have to.
> 
> This again is something that shouldn't even be attempted under
> Xen. The hypervisor, unless really old, does this (and wouldn't
> allow the write by any domain - privileged or not - anyway).
> 
> There's one more user though - the code triggered by the
> "show_msr=" command line option. This one indeed requires
> rdmsr_safe_regs to be functional (albeit under Xen, once
> again, this won't work currently anyway for those MRS on
> old CPUs where the special key in %edi is required, which the
> emulation code in Xen doesn't support).

This doesn't look right. Yinghai, why does generic x86 code use
rdmsrl_amd_safe - it should simply use rdmsrl_safe.

-- 
Regards/Gruss,
Boris.
