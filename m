Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2DXHCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:02:31 -0400
Received: from londo.lunn.ch ([80.238.139.98]:49888 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab2DXHCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:02:30 -0400
Date: Tue, 24 Apr 2012 09:04:26 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: viresh.kumar@st.com
Cc: akpm@linux-foundation.org, linux@arm.linux.org.uk, sshtylyov@mvista.com,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, viresh.linux@gmail.com,
        mturquette@linaro.org, jgarzik@redhat.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH V2 4/9] ata/sata_mv: Remove conditional compilation of clk
 code
Message-ID: <20120424070426.GA24089@lunn.ch>
Mail-Followup-To: viresh.kumar@st.com, akpm@linux-foundation.org,
	linux@arm.linux.org.uk, sshtylyov@mvista.com,
	spear-devel@list.st.com, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, viresh.linux@gmail.com,
	mturquette@linaro.org, jgarzik@redhat.com,
	linux-arm-kernel@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh

> With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
> there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
> macros.
> 
> ...
> 
> -#if defined(CONFIG_HAVE_CLK)
>         hpriv->clk = clk_get(&pdev->dev, NULL);
>         if (IS_ERR(hpriv->clk))
>                 dev_notice(&pdev->dev, "cannot get clkdev\n");
>         else
>                 clk_enable(hpriv->clk);
> -#endif

I don't think this change is correct. With the old semantics, it was:

If we have CLK support, we expect there to be a clock for sata_mv, and
if there is no such clock, output a notice message, something is
probably wrong, i expected there to be a clock.

The new semantics are:

We expect there to be a clock for sata_mv, and if there is no such
clock, output a notice message, something is probably wrong, i
expected there to be a clock.

We are going to see this notice message much more, when it is not
expected.

	Andrew
