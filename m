Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1IFXTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 19:19:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:58667 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab1IFXTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 19:19:08 -0400
Date: Wed, 7 Sep 2011 01:19:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] clockevents: Use an atomic RCU notifier for
 clockevents
In-Reply-To: <20110906224228.GA5534@alboin.fm.intel.com>
Message-ID: <alpine.LFD.2.02.1109070113090.2723@ionos>
References: <1314652136-11350-1-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109062120420.2723@ionos> <20110906203338.GL7761@one.firstfloor.org> <alpine.LFD.2.02.1109062235530.2723@ionos> <20110906224228.GA5534@alboin.fm.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Sep 2011, Andi Kleen wrote:

> > The idle code, at least the one in drivers/idle/intel_idle.c, does
> > _NOT_ call into that code at all when a reliable lapic timer is
> > available:
> 
> But the ACPI idle doesn't check that, so it still has a scalability problem.
> 
> Hmm ok so could add that check into acpi idle too I guess, but then ACPI
> idle doesn't normally know anything about CPUs.
> 
> > Either you are using different code or your machine does not have that
> > ARAT flag set.
> 
> The second test was using ACPI idle.

And as I said in that very same mail:

> > Same applies for drivers/acpi/processor_idle.c

lapic_timer_check_state()
{
       if (cpu_has(&cpu_data(pr->id), X86_FEATURE_ARAT))
                return;
....

WTF are you talking about? 

Thanks,

	tglx
