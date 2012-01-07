Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196Ab2AGDvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 22:51:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52310 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2AGDvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 22:51:50 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-d3-4f07c154cc29
From: Chanho Park <chanho61.park@samsung.com>
To: "'Stephen Warren'" <swarren@nvidia.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
References: <1325882311-7504-1-git-send-email-swarren@nvidia.com>
In-reply-to: <1325882311-7504-1-git-send-email-swarren@nvidia.com>
Subject: RE: [PATCH] pinctrl: Fix pinconf_pins_show iteration
Date: Sat, 07 Jan 2012 12:51:48 +0900
Message-id: <008001ccccef$ae75fd80$0b61f880$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczMsy1pFDMe4ehoSReqdFxD0USZUgAO9Nqw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@nvidia.com]
> Sent: Saturday, January 07, 2012 5:39 AM
> To: Linus Walleij
> Cc: linux-kernel@vger.kernel.org; Chanho Park; Stephen Warren
> Subject: [PATCH] pinctrl: Fix pinconf_pins_show iteration
> 
> Commit 706e852 "pinctrl: correct a offset while enumerating pins"
> modified the variable used by pinconf_pin_show()'s for loop, but didn't
> update the for loop test expression.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/pinctrl/pinconf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
> index 1259872..1892a37 100644
> --- a/drivers/pinctrl/pinconf.c
> +++ b/drivers/pinctrl/pinconf.c
> @@ -236,7 +236,7 @@ static int pinconf_pins_show(struct seq_file *s,
> void *what)
>  	seq_puts(s, "Format: pin (name): pinmux setting array\n");
> 
>  	/* The pin number can be retrived from the pin controller
> descriptor */
> -	for (i = 0; pin < pctldev->desc->npins; i++) {
> +	for (i = 0; i < pctldev->desc->npins; i++) {
>  		struct pin_desc *desc;
> 
>  		pin = pctldev->desc->pins[i].number;
> --
> 1.7.0.4

Oh, I missed it.
Thank you for refining it.

Best Regards,
Chanho Park

