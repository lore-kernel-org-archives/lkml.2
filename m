Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2E3O5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:57:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39688 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2E3O5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:57:18 -0400
Date: Wed, 30 May 2012 10:50:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Andre Przywara <andre.przywara@amd.com>, Jan Beulich <JBeulich@suse.com>,
        mingo@elte.hu, jeremy@goop.org, tglx@linutronix.de,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530145005.GI3207@phenom.dumpdata.com>
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
 <4FC62888.9010407@amd.com>
 <20120530144851.GA12184@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530144851.GA12184@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 09:48:51AM -0500, Jacob Shin wrote:
> On Wed, May 30, 2012 at 04:02:48PM +0200, Andre Przywara wrote:
> > On 05/30/2012 03:33 PM, Jan Beulich wrote:
> > >>>>On 30.05.12 at 15:10, Andre Przywara<andre.przywara@amd.com>  wrote:
> > >>Because we are behind a family check before tweaking the topology
> > >>bit, we can use the standard rd/wrmsr variants for the CPUID feature
> > >>register.
> > >>This fixes a crash when using the kernel as a Xen Dom0 on affected
> > >>Trinity systems. The wrmsrl_amd_safe is not properly paravirtualized
> > >>yet (this will be fixed in another patch).
> > >
> > >I'm not following: If the AMD variants (putting a special value into
> > >%edi) can be freely replaced by the non-AMD variants, why did
> > >the AMD special ones get used in the first place?
> > 
> > Older CPUs (K8) needed the AMD variants, starting with family 10h we
> > can use the normal versions.
> > 
> > >Further, I can't see how checking_wrmsrl() is being paravirtualized
> > >any better than wrmsrl_amd_safe() - both have nothing but an
> > >exception handling fixup attached to the wrmsr invocation. Care
> > >to point out what actual crash it is that was seen?
> > 
> > AFAIK, the difference is between the "l" and the regs version for
> > rd/wrmsr. We have a patch already here to fix this. Will send it out
> > soon. Jacob, can you comment on this?
> 
> Right, the checking_wrmsrl turns into wrmsr_safe which is paravirtualized
> but the rdmsrl_amd_safe which turns into rdmsr_regs is not paravirtualized
> by enlighten.

So would a patch to implements the rdmsr_regs fix this crash?
