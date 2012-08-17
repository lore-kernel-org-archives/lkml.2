Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030378Ab2HQJjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:39:19 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:58395 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833Ab2HQJjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:39:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/FKbBRbBaUVNBtXnA03QB4
Date: Fri, 17 Aug 2012 02:39:12 -0700
From: Tony Lindgren <tony@atomide.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH v2 15/31] arm64: SMP support
Message-ID: <20120817093912.GW11011@atomide.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-16-git-send-email-catalin.marinas@arm.com>
 <20120817092133.GR11011@atomide.com>
 <20120817093250.GB24389@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817093250.GB24389@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Catalin Marinas <catalin.marinas@arm.com> [120817 02:33]:
> On Fri, Aug 17, 2012 at 10:21:33AM +0100, Tony Lindgren wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> [120814 11:05]:
> > > This patch adds SMP initialisation and spinlocks implementation for
> > > AArch64. The spinlock support uses the new load-acquire/store-release
> > > instructions to avoid explicit barriers. The architecture also specifies
> > > that an event is automatically generated when clearing the exclusive
> > > monitor state to wake up processors in WFE, so there is no need for an
> > > explicit DSB/SEV instruction sequence. The SEVL instruction is used to
> > > set the exclusive monitor locally as there is no conditional WFE and a
> > > branch is more expensive.
> > 
> > Do we always have SMP hardware on arm64? Or are we going to need to
> > again add smp_on_up support later on?
> 
> There isn't anything in the architecture specs that mandates multiple
> cores but given the current trend it's very likely that we'll always
> have MP.
> 
> An improvement in AArch64 is that we can use the SMP cache/TLB ops (the
> inner shareable variants) even on a UP system so there is no need for
> run-time code patching for correct execution.

That's good to hear!

Tony
