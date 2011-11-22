Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1KVNL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:11:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61686 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1KVNLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:11:24 -0500
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH v3 4/5] clk: basic gateable and fixed-rate clks
Date: Tue, 22 Nov 2011 13:11:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, aul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, eric.miao@linaro.org, richard.zhao@linaro.org,
        Mike Turquette <mturquette@linaro.org>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-5-git-send-email-mturquette@linaro.org>
In-Reply-To: <1321926047-14211-5-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111221311.00117.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:0y5IxVjmenx2bci+1u3NlnJ10gBIuhYdudnNWhV1jzN
 JbpCbb3Nq0RWEZuW7+j0XIFpbHDGeOFzfdjCxRev8bvCVz4YGz
 Kr/om6XNPZzhSj5vk3Y1j50NgfsqUVrjqd7Sha7Vpu4G3GfO1H
 T/zQzCiUc9a5jv1/92elMIQGMB0E2eyzcUShpwFaxkXr3WEnzY
 jBVVNdcNsT6wOKyWaF54TGscaNpxee8XmYNzOgVxqhFNO8z5wS
 ydNJFVPiMBzBmbDqm4cWOm1xf118MVR9VWXgDHgpKc6xZJR/jD
 5PP3nT+xmMwvoWjCzerCl61jBfWRq9fBYjvuG94gxN5+gzFATO
 5beIf8fE0hsGOVI2l/Q10DVVWKzFiAX62osQQe4jX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 November 2011, Mike Turquette wrote:
> +static void clk_hw_gate_set_bit(struct clk *clk)
> +{
> +       struct clk_hw_gate *gate = to_clk_hw_gate(clk);
> +       u32 reg;
> +
> +       reg = __raw_readl(gate->reg);
> +       reg |= BIT(gate->bit_idx);
> +       __raw_writel(reg, gate->reg);
> +}

You cannot rely on __raw_readl() to do the right thing, especially
in architecture independent code. The safe (but slightly inefficient)
solution would be readl/writel. For ARM-only code, it would be best
to use readl_relaxed()/writel_relaxed(), but most architectures do
not implement that. We can probably add a set of helpers in asm-generic/
to define them to the default functions, like "#define readl_relaxed(x)
readl(x)", which I think is a good idea anyway.

	Arnd
