Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889Ab2HQJda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:33:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56560 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964862Ab2HQJdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:33:23 -0400
Date: Fri, 17 Aug 2012 10:32:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH v2 15/31] arm64: SMP support
Message-ID: <20120817093250.GB24389@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-16-git-send-email-catalin.marinas@arm.com>
 <20120817092133.GR11011@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817092133.GR11011@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:21:33AM +0100, Tony Lindgren wrote:
> * Catalin Marinas <catalin.marinas@arm.com> [120814 11:05]:
> > This patch adds SMP initialisation and spinlocks implementation for
> > AArch64. The spinlock support uses the new load-acquire/store-release
> > instructions to avoid explicit barriers. The architecture also specifies
> > that an event is automatically generated when clearing the exclusive
> > monitor state to wake up processors in WFE, so there is no need for an
> > explicit DSB/SEV instruction sequence. The SEVL instruction is used to
> > set the exclusive monitor locally as there is no conditional WFE and a
> > branch is more expensive.
> 
> Do we always have SMP hardware on arm64? Or are we going to need to
> again add smp_on_up support later on?

There isn't anything in the architecture specs that mandates multiple
cores but given the current trend it's very likely that we'll always
have MP.

An improvement in AArch64 is that we can use the SMP cache/TLB ops (the
inner shareable variants) even on a UP system so there is no need for
run-time code patching for correct execution.

-- 
Catalin
