Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935510Ab1ETLhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:37:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab1ETLhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:37:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] clk: Add simple gated clock
Date: Fri, 20 May 2011 13:37:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1305876469.327589.409938867568.4.gpush@pororo>
In-Reply-To: <1305876469.327589.409938867568.4.gpush@pororo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105201337.03501.arnd@arndb.de>
X-Provags-ID: V02:K0:zzR2yDR6Hqp2gsZKS2oeZ3ADfrYAIbCVxmQ4APncmLu
 Bm4IRYP5qBOiVSpFUpVtrQ3HcZ1iFcDhI5+5PYEHh8yPYCZFG9
 aSsyabufd/FTvgJWnPzRfl947b7QIHWr3tZnk1nhFuOqx5lJpF
 fjSUXvhzRasvH6TcxhAs81BdffCGsmwq1mYRubMGg+97ccPCO5
 e5q1nzvdsEp7x6mL/YeyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 May 2011 09:27:49 Jeremy Kerr wrote:
> +static int clk_gate_enable(struct clk_hw *clk)
> +{
> +       struct clk_gate *gate = to_clk_gate(clk);
> +       u32 reg;
> +
> +       reg = __raw_readl(gate->reg);
> +       reg |= 1 << gate->bit_idx;
> +       __raw_writel(reg, gate->reg);
> +
> +       return 0;
> +}

__raw_readl/__raw_writel is a rather bad choice for a common driver,
it might not do what you need. Unfortunately, readl() also wouldn't
do the right thing on all architectures, because it might only
be available on PCI buses. Maybe iowrite32 would be best here?

Instead of the bit_idx, a mask value might be better to avoid
confusion with the different ways of counting bits from one or
the other end.

	Arnd
