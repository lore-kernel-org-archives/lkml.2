Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1JNR4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:56:02 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65441 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1JNR4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:56:01 -0400
Date: Fri, 14 Oct 2011 10:55:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, JBeulich@novell.com
Subject: Re: WARNING: at arch/x86/kernel/apic/apic.c:1239
 setup_local_APIC+...
Message-ID: <20111014175556.GE4294@google.com>
References: <20111014135516.GC11990@aftab>
 <20111014165604.GA14286@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014165604.GA14286@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing Jan Beulich)

On Fri, Oct 14, 2011 at 06:56:04PM +0200, Borislav Petkov wrote:
> On Fri, Oct 14, 2011 at 09:55:16AM -0400, Borislav Petkov wrote:
> > So, in the end, and AFAICR, the warning triggers because we're comparing
> > logical APIC IDs from the APIC Logical Destination Register (0xD0) which
> > have been assigned by BIOS with "1 << cpu" shifted values which wrap on
> > 32-bit.
> > 
> > I'd very much like to know why?
> 
> Update: upon a second thought, we think we know why: The WARN_ON
> cannot stomach the switch to bigsmp apic because, on the one hand,
> bigsmp_init_apic_ldr() "normalizes" the APIC ids by using the BIOS
> values (x86_bios_cpu_apicid) but OTOH, x86_cpu_to_logical_apicid
> contains the early percpu value which got assigned by the default apic,
> i.e. the shifting thing as it is spec'ed for the LDR register.
> 
> So, the way we see it, the WARN_ON should know whether we switched apics
> or should be removed completely. Btw, why was it added in the first
> place, the commit message doesn't quite explain why.

Jan hit similar problem a while back.

  http://thread.gmane.org/gmane.linux.kernel/1180954

I can't seem to find the patch in mainline.  Jan, Ingo?  Borislav,
would the patch there resolve the warning you're seeing too?

Anyways, to summarize, the early apic thing isn't necessary anymore
and can be ripped out and the warning is pretty much bogus at this
point.  I'll rip it out soonish.

Thank you.

-- 
tejun
