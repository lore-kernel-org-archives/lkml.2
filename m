Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab1IGR51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:57:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:39696 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1IGR5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:57:25 -0400
Date: Wed, 7 Sep 2011 19:57:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: yong.zhang0@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        joe@perches.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH 20/62] sparc: irq: Remove IRQF_DISABLED
In-Reply-To: <20110907.135110.2069876782156753239.davem@davemloft.net>
Message-ID: <alpine.LFD.2.02.1109071954200.2723@ionos>
References: <20110907.131217.2301665763990232637.davem@davemloft.net> <alpine.LFD.2.02.1109071924510.2723@ionos> <alpine.LFD.2.02.1109071933080.2723@ionos> <20110907.135110.2069876782156753239.davem@davemloft.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011, David Miller wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 7 Sep 2011 19:33:52 +0200 (CEST)
> 
> We had big problems when openning thousands of virtual network
> devices, each with their own unique IRQ, and pointed all at the same
> cpu, and we'd get IRQ stack overflows.
> 
> See commit c58543c869606532c2382f027d6466f4672ea756
> 
> So this change to make IRQF_DISABLED a nop has reintroduced this bug.

See commit e58aa3d2d0cc01ad8d6f7f640a0670433f794922

We run ALL interrupt handlers with interrupts disabled for that reason
and we even check and yell when an interrupt handler returns with
interrupts enabled. That's why IRQF_DISABLED became meaningless.

Thanks,

	tglx

