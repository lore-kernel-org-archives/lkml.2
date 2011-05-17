Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab1EQJIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:08:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab1EQJIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:08:44 -0400
Date: Tue, 17 May 2011 11:08:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        daniel.blueman@gmail.com
Subject: Re: [patch 4/4] x86, ioapic: remove duplicate code for
 saving/restoring RTEs
Message-ID: <20110517090838.GH22093@elte.hu>
References: <20110516185646.282418545@sbsiddha-MOBL3.sc.intel.com>
 <20110516185646.559690403@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516185646.559690403@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ok, this series looks better, but as this bug has demonstrated it we need to do 
better to keep the ioapic code clean.

Firstly, please introduce a 'struct ioapic' structure that starts out with a 
nr_registers field, and add an ioapics[] array and consolidate 
nr_ioapic_registers into this.

The consolidate other ioapic driver state as well:

 - add a *saved_registers field and consolidate ioapic_saved_data into it

 - add a 'struct mpc_ioapic mp_config' entry and consolidate mp_ioapics[]

 - add a 'struct mp_ioapic_gsi gsi_config' entry and consolidate mp_gsi_routing[]

 - add a 'int pin_programmed' field and consolidate mp_ioapic_routing[] into it

ioapics[] itself should be static to io_apic.c.

Please create a separate patch for each change: that way it's bisectable and 
reviewable.

These changes alone will make the IO-APIC code a *lot* more readable, more 
extensible - and hopefully much less prone to suspend/resume bugs as well.

Feel free to do this on top of your current queue to keep your patch-shuffling 
overhead low.

Thanks,

	Ingo
