Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2HPKvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:51:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44996 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255Ab2HPKvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:51:42 -0400
Date: Thu, 16 Aug 2012 11:51:34 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 25/31] arm64: Performance counters support
Message-ID: <20120816105134.GJ31784@mudshark.cambridge.arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-26-git-send-email-catalin.marinas@arm.com>
 <201208151511.11612.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151511.11612.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:11:11PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> > From: Will Deacon <will.deacon@arm.com>
> > 
> > This patch adds support for the AArch64 performance counters.
> > 
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >  arch/arm64/include/asm/perf_event.h |   22 +
> >  arch/arm64/include/asm/pmu.h        |   82 +++
> >  arch/arm64/kernel/perf_event.c      | 1368 +++++++++++++++++++++++++++++++++++
> >  tools/perf/perf.h                   |    6 +
> 
> Can you explain how AArch64 performance counters differ from the 32
> bit ones? Do they work for AArch32 user space under AArch64 kernels?
> Is it possible to share parts of the implementation with arch/arm?

Perf should work for compat tasks, yes. I'd like to share some of the code
with arch/arm/ and I've started reworking the arch/arm/ stuff to accomodate
this better:

  git://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git perf/updates

I'm not sure how well it will fit in drivers/ but I'm certainly willing to
give it a try.

Will
