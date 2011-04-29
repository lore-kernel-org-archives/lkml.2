Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab1D2QQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:16:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:47434 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759868Ab1D2QQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:16:38 -0400
Message-ID: <4DBAE461.7000307@linutronix.de>
Date: Fri, 29 Apr 2011 18:16:33 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/6] General device tree irq domain infrastructure
References: <20110428192227.8979.49181.stgit@ponder>
In-Reply-To: <20110428192227.8979.49181.stgit@ponder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> I'd really like to get patches 1-4 merged into 2.6.40.  Please test.
> I'm also running through build testing here, and when it's complete
> I'll push it out to a 'devicetree/irq-domain' branch on
> git://git.secretlab.ca/git/linux-2.6

I pulled this, built and booted my x86-dt box and nothing exploded so far.

If you merge Linus' tree then you will get a conflict (sooner or later) in
ioapic_of_irq_map() in arch/x86/kernel/devicetree.c:

-       return io_apic_setup_irq_pin_once(*out_hwirq, cpu_to_node(0), &attr);
  -      if (io_apic_setup_irq_pin(hwirq, cpu_to_node(0), &attr))
++      if (io_apic_setup_irq_pin_once(hwirq, cpu_to_node(0), &attr))

Sebastian
