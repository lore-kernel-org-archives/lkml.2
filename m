Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab2DMFXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 01:23:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61418 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2DMFXf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 01:23:35 -0400
MIME-Version: 1.0
In-Reply-To: <1328741722-1254-1-git-send-email-robherring2@gmail.com>
References: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
	<1328741722-1254-1-git-send-email-robherring2@gmail.com>
Date: Fri, 13 Apr 2012 10:53:33 +0530
Message-ID: <CAJuYYwQ+1_i6ZVvJp-a3vpmNuqC7WWCMS6sDAEaMBHOUVwYrrw@mail.gmail.com>
Subject: Re: [PATCH v6] irq: add irq_domain support to generic-chip
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, b-cousson@ti.com,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 9 February 2012 04:25, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> Add irq domain support to irq generic-chip. This enables users of
> generic-chip to support dynamic irq assignment needed for DT interrupt
> binding.
>
> Thanks to Shawn Guo for fixes and testing.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
> Here's the latest version. This has fixes from Shawn Guo, so should be
> working. This version is also available here:
>
> git://sources.calxeda.com/kernel/linux.git pl061-domain-v6.
>
>  include/linux/irq.h       |   15 +++++
>  kernel/irq/generic-chip.c |  152 ++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 145 insertions(+), 22 deletions(-)
>

[...]

> diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
> index c89295a..3ac7fa1 100644
> --- a/kernel/irq/generic-chip.c
> +++ b/kernel/irq/generic-chip.c

[...]

> +static const struct irq_domain_ops irq_gc_irq_domain_ops = {
> +       .map = irq_gc_irq_domain_map,
> +       .xlate = irq_domain_xlate_onetwocell,
> +};

Is there anyway to use a custom xlate function instead of the fixed
'irq_domain_xlate_onetwocell' xlate function. I am using this patchset
with Exynos4 interrupt combiner controller whose interrupt specifier
format is two cell but has different meaning. The first cell is the
interrupt combiner number and the second cell is the interrupt number
within that combiner.

Thanks,
Thomas.

[...]
