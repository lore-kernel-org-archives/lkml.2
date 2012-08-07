Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2HGQ13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:27:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:9905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab2HGQ12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:27:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="182744189"
Subject: Re: do_IRQ: 1.55 No irq handler for vector (irq -1)
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Robert Richter <robert.richter@amd.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        "Petkov, Borislav" <borislav.petkov@amd.com>
Date: Tue, 07 Aug 2012 09:24:21 -0700
In-Reply-To: <20120807154134.GA7456@aftab.osrc.amd.com>
References: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	 <tip-332afa656e76458ee9cf0f0d123016a0658539e4@git.kernel.org>
	 <20120807153149.GI3732@erda.amd.com>
	 <20120807154134.GA7456@aftab.osrc.amd.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1344356662.2041.48.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 17:41 +0200, Borislav Petkov wrote:
> On Tue, Aug 07, 2012 at 05:31:49PM +0200, Robert Richter wrote:
> > On 06.06.12 08:03:58, tip-bot for Suresh Siddha wrote:
> > > Commit-ID:  332afa656e76458ee9cf0f0d123016a0658539e4
> > > Gitweb:     http://git.kernel.org/tip/332afa656e76458ee9cf0f0d123016a0658539e4
> > > Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> > > AuthorDate: Mon, 21 May 2012 16:58:01 -0700
> > > Committer:  Ingo Molnar <mingo@kernel.org>
> > > CommitDate: Wed, 6 Jun 2012 09:51:22 +0200
> > > 
> > > x86/irq: Update irq_cfg domain unless the new affinity is a subset of the current domain
> > 
> > This commit causes a sata error and thus a boot failure:
> > 
> >  ACPI: Invalid Power Resource to register!ata1: lost interrupt (Status 0x50)
> >  ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x40000000 action 0x6 frozen
> >  ata1: SError: { }
> >  ata1.00: failed command: READ DMA
> > 
> > Reverting it as following helped:
> > 
> >  $ git revert d872818dbbeed1bccf58c7f8c7db432154c802f9
> >  $ git revert 1ac322d0b169c95ce34d55b3ed6d40ce1a5f3a02
> >  $ git revert 332afa656e76458ee9cf0f0d123016a0658539e4
> 
> Right,
> 
> and it is a good thing Robert and I were talking about his issue and I
> mentioned seeing funny do_IRQ messages during 3.6-rc1 boot:
> 
> [    0.170256] AMD PMU driver.
> [    0.170451] ... version:                0
> [    0.170683] ... bit width:              48
> [    0.170906] ... generic registers:      6
> [    0.171125] ... value mask:             0000ffffffffffff
> [    0.171399] ... max period:             00007fffffffffff
> [    0.171673] ... fixed-purpose events:   0
> [    0.171902] ... event mask:             000000000000003f
> [    0.172687] MCE: In-kernel MCE decoding enabled.
> [    0.184214] [Firmware Info]: CPU: Re-enabling disabled Topology Extensions Support
> [    0.186687] do_IRQ: 1.55 No irq handler for vector (irq -1)				<---
> [    0.198126] [Firmware Info]: CPU: Re-enabling disabled Topology Extensions Support
> [    0.200579] do_IRQ: 2.55 No irq handler for vector (irq -1)				<---
> [    0.173040] smpboot: Booting Node   0, Processors  #1 #2 #3 OK
> [    0.212083] [Firmware Info]: CPU: Re-enabling disabled Topology Extensions Support
> [    0.214538] do_IRQ: 3.55 No irq handler for vector (irq -1)				<---
> [    0.214864] Brought up 4 CPUs
> 
> of it now having IRQ handler for vector 55.
> 
> And guess what: reverting those three above make the message go away
> too.
> 

Boris, Robert, Can you please send me the complete dmesg
and /proc/interrupts on a successful boot?

thanks,
suresh

