Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab1E0IiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:38:25 -0400
Received: from service87.mimecast.com ([94.185.240.25]:60679 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752470Ab1E0IiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:38:23 -0400
Date: Fri, 27 May 2011 09:38:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>, Will Deacon <Will.Deacon@arm.com>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        lkml <linux-kernel@vger.kernel.org>, ak@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when
 CONFIG_ALIGNMENT_TRAP
Message-ID: <20110527083806.GA21100@e102109-lin.cambridge.arm.com>
References: <yw1xipt0p4i9.fsf@unicorn.mansr.com>
 <BANLkTi=xLE9gP5YOdr9dR0DfsY1Ymzxu+w@mail.gmail.com>
 <20110524171331.GA2941@arm.com>
 <20110525111405.GA12010@e102109-lin.cambridge.arm.com>
 <20110525124348.GA2340@arm.com>
 <yw1xaaeanbxe.fsf@unicorn.mansr.com>
 <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com>
 <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
 <alpine.LFD.2.00.1105261650330.3207@xanadu.home>
 <20110526215101.GL24876@n2100.arm.linux.org.uk>
MIME-Version: 1.0
In-Reply-To: <20110526215101.GL24876@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 May 2011 08:38:32.0114 (UTC) FILETIME=[75C81920:01CC1C49]
X-MC-Unique: 111052709381901201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:51:01PM +0100, Russell King - ARM Linux wrote:
> On Thu, May 26, 2011 at 05:03:39PM -0400, Nicolas Pitre wrote:
> > It is possible that -fconserve-stack is still valuable on ARM given that
> > it is also used with -mno-unaligned-access for other things than
> > structure packing on the stack, and therefore its merits can be debated
> > independently from the alignment issue at hand.
> 
> Catalin said in his mail "I haven't tried with -mno-unaligned-access, I
> suspect the variables on the stack would be aligned.".  So I don't think
> we know enough to say whether -mno-unaligned-access avoids the stack
> packing.

OK, I tried this now:

-fconserve-stack: we get unaligned accesses on the stack because the
newer versions of gcc turned unaligned accesses on by default.

-fconserve-stack -mno-unaligned-access: the stack variables are aligned.
We probably get the benefit of -fconserve-stack as well.

So as per the initial post in this thread, we could have
-mno-unaligned-access on ARM always on (when CONFIG_ALIGNMENT_TRAP). As
Nicolas suggested, we could compile some files with -munaligned-access
(and maybe -fno-conserve-stack).

I raised this with the gcc guys so they are looking into it. But it
really doesn't look like a gcc bug as long as -mno-unaligned-access is
taken into account.

-- 
Catalin

