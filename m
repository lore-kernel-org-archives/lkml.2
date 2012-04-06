Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab2DFLZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 07:25:27 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:56917 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2DFLZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 07:25:26 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	<1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	<m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	<20120402202848.1EB833E02A7@localhost> <m2y5qdow0v.fsf@igel.home>
	<20120404154020.40C513E09D5@localhost> <m2r4w1akz4.fsf@igel.home>
	<alpine.LFD.2.02.1204061315040.2542@ionos>
X-Yow: ..I just walked into th' HOUSE OF REPRESENTATIVES with fourteen WET
 DOLPHINS and an out-of-date MARRIAGE MANUAL...
Date: Fri, 06 Apr 2012 13:25:19 +0200
In-Reply-To: <alpine.LFD.2.02.1204061315040.2542@ionos> (Thomas Gleixner's
	message of "Fri, 6 Apr 2012 13:17:04 +0200 (CEST)")
Message-ID: <m2bon59k68.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> And it looks like the irqdomain code is the real culprit.
>
> void irq_set_virq_count(unsigned int count)
> {
>         pr_debug("irq: Trying to set virq count to %d\n", count);
>
>         BUG_ON(count < NUM_ISA_INTERRUPTS);
>         if (count < NR_IRQS)
>                 irq_virq_count = count;
> }
>
> That looks simply wrong.....

There is a single use of irq_set_virq_count, which is only relevant to
the PS3.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
