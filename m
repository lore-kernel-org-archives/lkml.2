Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab1LKH66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 02:58:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49645 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1LKH65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 02:58:57 -0500
Date: Sun, 11 Dec 2011 08:57:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Berck E. Nash" <flyboy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: x2apic boot failure on recent sandy bridge system
Message-ID: <20111211075713.GA20790@elte.hu>
References: <4EE2BC33.80902@gmail.com>
 <CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> so kernel can not enable interrput remapping, then it will panic..
> 
> [    0.085717] Kernel panic - not syncing: x2apic: enabled by BIOS but
> kernel init failed.
> [    0.093697] Pid: 1, comm: swapper/0 Not tainted 3.2.0-rc5 #2
> [    0.099337] Call Trace:
> [    0.101788]  [<ffffffff8137b7ce>] ? panic+0x95/0x18e
> [    0.106755]  [<ffffffff81016259>] ? __ioapic_write_entry+0x16/0x32
> [    0.112925]  [<ffffffff8152d5bf>] ? enable_IR_x2apic+0x19a/0x1d7
> [    0.118913]  [<ffffffff8152f281>] ? default_setup_apic_routing+0xd/0x71
> [    0.125506]  [<ffffffff8152c536>] ? native_smp_prepare_cpus+0x2f1/0x325
> [    0.132102]  [<ffffffff81522abf>] ? kernel_init+0x46/0x10f
> [    0.137571]  [<ffffffff813841f4>] ? kernel_thread_helper+0x4/0x10
> [    0.143650]  [<ffffffff81522a79>] ? start_kernel+0x341/0x341
> [    0.149297]  [<ffffffff813841f0>] ? gs_change+0xb/0xb
> 
> your bios should not enable x2apic in this case.
> 
> please get one bios update.
> 
> also I have one old patch that could disable apic. but it is 
> not get merged and it may not be applied to current tree.

What we want is not a nox2apic option but a good fall-back 
mechanism that is able to boot the system automatically and 
safely, without the user having to tweak *anything* ...

Tanks,

	Ingo
