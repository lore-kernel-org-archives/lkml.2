Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab1E0Iyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:54:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45667 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1E0Iyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:54:38 -0400
Date: Fri, 27 May 2011 09:54:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Will Deacon <Will.Deacon@arm.com>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        lkml <linux-kernel@vger.kernel.org>, ak@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when
	CONFIG_ALIGNMENT_TRAP
Message-ID: <20110527085414.GP24876@n2100.arm.linux.org.uk>
References: <BANLkTi=xLE9gP5YOdr9dR0DfsY1Ymzxu+w@mail.gmail.com> <20110524171331.GA2941@arm.com> <20110525111405.GA12010@e102109-lin.cambridge.arm.com> <20110525124348.GA2340@arm.com> <yw1xaaeanbxe.fsf@unicorn.mansr.com> <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com> <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com> <alpine.LFD.2.00.1105261650330.3207@xanadu.home> <20110526215101.GL24876@n2100.arm.linux.org.uk> <20110527083806.GA21100@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527083806.GA21100@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 09:38:08AM +0100, Catalin Marinas wrote:
> OK, I tried this now:
> 
> -fconserve-stack: we get unaligned accesses on the stack because the
> newer versions of gcc turned unaligned accesses on by default.
> 
> -fconserve-stack -mno-unaligned-access: the stack variables are aligned.
> We probably get the benefit of -fconserve-stack as well.
> 
> So as per the initial post in this thread, we could have
> -mno-unaligned-access on ARM always on (when CONFIG_ALIGNMENT_TRAP). As
> Nicolas suggested, we could compile some files with -munaligned-access
> (and maybe -fno-conserve-stack).
> 
> I raised this with the gcc guys so they are looking into it. But it
> really doesn't look like a gcc bug as long as -mno-unaligned-access is
> taken into account.

Ok, we need to check one last thing, and that's what the behaviour is
with -mno-unaligned-access and packed structures (such as the ethernet
header).  If it makes no difference, then I suggest we always build
with -mno-unaligned-access.
