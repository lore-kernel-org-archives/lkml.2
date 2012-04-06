Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab2DFLvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 07:51:17 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:43360 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab2DFLvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 07:51:16 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	<1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	<m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	<20120402202848.1EB833E02A7@localhost>
	<20120402215524.GM24211@n2100.arm.linux.org.uk>
	<1333406005.30734.61.camel@pasglop>
	<20120402225223.GN24211@n2100.arm.linux.org.uk>
	<1333409927.30734.62.camel@pasglop>
X-Yow: What UNIVERSE is this, please??
Date: Fri, 06 Apr 2012 13:51:14 +0200
In-Reply-To: <1333409927.30734.62.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Tue, 03 Apr 2012 09:38:47 +1000")
Message-ID: <m24nsx9iz1.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> Ok. Doesn't matter anyway, this shouldn't be the problem in this
> specific case. IE. we shouldn't be setting that interrupt to NONE.

After removinge the call to irq_set_irq_type in mpic_host_map the irq
problem disappears.

Instead of the irq_set_irq_type(,NONE) calls from mpic_host_map I see
corresponding irq_set_irq_type(,LEVEL_LOW) calls now.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
