Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab1CRIjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:39:23 -0400
Received: from www.tglx.de ([62.245.132.106]:39492 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1CRIjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:39:16 -0400
Date: Fri, 18 Mar 2011 09:38:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
cc: davidb@codeaurora.org, dwalker@fifo99.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-msm-owner@vger.kernel.org,
        linux-arm-kernel@lists.intradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PM8921 MFD V4 2/6] mfd: pm8xxx: Add irq support
In-Reply-To: <1300422118-13888-3-git-send-email-adharmap@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1103180935530.2787@localhost6.localdomain6>
References: <1300422118-13888-1-git-send-email-adharmap@codeaurora.org> <1300422118-13888-3-git-send-email-adharmap@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, adharmap@codeaurora.org wrote:
> +static struct irq_chip pm8xxx_irq_chip = {
> +	.name		= "pm8xxx",
> +	.irq_mask_ack	= pm8xxx_irq_mask_ack,
> +	.irq_unmask	= pm8xxx_irq_unmask,
> +	.irq_set_type	= pm8xxx_irq_set_type,
> +	.flags		= IRQCHIP_MASK_ON_SUSPEND,
> +};

Ok, that looks sane now. One problem remains. You have removed the
set_wake function, which will cause the core to bail when an irq is
marked wake. So you want an set_wake() function which does nothing
else than return 0 for now. I'll have a look that we can handle that
case with a chip flag in the core.

Thanks,

	tglx


