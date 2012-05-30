Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab2E3O7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:59:07 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23432 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2E3O7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:59:03 -0400
Date: Wed, 30 May 2012 10:51:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andre Przywara <andre.przywara@amd.com>, mingo@elte.hu, tglx@linutronix.de,
        jeremy@goop.org, xen-devel@lists.xensource.com,
        stable@vger.kernel.org#3.4+, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530145155.GJ3207@phenom.dumpdata.com>
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <20120530143937.GF3207@phenom.dumpdata.com>
 <4FC633A7.1050406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC633A7.1050406@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 07:50:15AM -0700, H. Peter Anvin wrote:
> On 05/30/2012 07:39 AM, Konrad Rzeszutek Wilk wrote:
> > On Wed, May 30, 2012 at 03:10:02PM +0200, Andre Przywara wrote:
> >> Because we are behind a family check before tweaking the topology
> >> bit, we can use the standard rd/wrmsr variants for the CPUID feature
> >> register.
> >> This fixes a crash when using the kernel as a Xen Dom0 on affected
> >> Trinity systems. The wrmsrl_amd_safe is not properly paravirtualized
> >> yet (this will be fixed in another patch).
> > 
> > So with a rdmsrl_amd_safe and wrmsrl_amd_safe being implemented in
> > the pv_cpu_ops - would this patch even be neccessary?
> > 
> 
> That is still bogus;  a better thing would be to implement the _regs
> interface.  Even better would be to trap and emulate rdmsr/wrmsr!

That is what I meant - implement these two:

	rdmsr_regs = native_rdmsr_safe_regs,
        .wrmsr_regs = native_wrmsr_safe_regs,

Xen already traps the rdmsr/wrms - I believe it just didn't do
anything for this specific MSR.
