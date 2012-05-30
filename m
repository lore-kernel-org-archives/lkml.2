Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2E3Rcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:32:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36269 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab2E3Rcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:32:51 -0400
Date: Wed, 30 May 2012 19:32:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Andre Przywara <andre.przywara@amd.com>,
        jeremy@goop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@suse.com>,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530173247.GC15635@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Jacob Shin <jacob.shin@amd.com>,
	Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
	xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
	Jan Beulich <JBeulich@suse.com>, hpa@zytor.com, mingo@elte.hu,
	tglx@linutronix.de
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
 <4FC62888.9010407@amd.com>
 <20120530144851.GA12184@jshin-Toonie>
 <20120530145005.GI3207@phenom.dumpdata.com>
 <20120530150334.GA13349@jshin-Toonie>
 <20120530171754.GA5115@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120530171754.GA5115@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 01:17:54PM -0400, Konrad Rzeszutek Wilk wrote:
> > Yes, the following patch also fixed the crash for us:
> > 
> > Implement rdmsr_regs and wrmsr_regs for Xen pvops.
> 
> That needs more data. Such as the reason for it, the crash
> tombstone, and an analysis of the bug.
> 
> But at this point I am not sure what we are going to do.
> 
> I think Peter leans towards ripping the .rdmsr_regs/wdmsr_regs
> function out altogether (so altering the amd_rdmsr... to use the
> .rdmsr/.wrdmsr). At which point I think this would all work
> just fine?

I wouldn't do that. Andre's patch switches to the
rdmsrl_safe/checking_wrmsrl functions so you don't need to implement the
_regs functions for pvops.

I'll send it now with corrected commit message.

> I am tempted to write a patch that checks all the pv-cpu-ops to see if
> there are any that are NULL and throw a warning so that this does not
> hit us in the future - to be at least more proactive about this sort
> of thing.

This could be a prudent thing to do.

-- 
Regards/Gruss,
Boris.
