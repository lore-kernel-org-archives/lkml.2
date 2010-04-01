Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0DAJQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:16:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55837 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754145Ab0DAJQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:16:09 -0400
Date: Thu, 1 Apr 2010 10:20:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pavan_savoy@ti.com
Cc: Greg KH <gregkh@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging: sources for ST core
Message-ID: <20100401102005.4fba7cc2@lxorguk.ukuu.org.uk>
In-Reply-To: <836055.3581.qm@web94915.mail.in2.yahoo.com>
References: <20100331202442.GC12995@suse.de>
	<836055.3581.qm@web94915.mail.in2.yahoo.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * function to return whether the firmware response was proper
> + * in case of error don't complete so that waiting for proper
> + * response times out
> + */
> +void validate_firmware_response(struct sk_buff *skb)
> +{
> +	if (unlikely(skb->data[5] != 0)) {
> +		pr_err("no proper response during fw download");
> +		pr_err("data6 %x", skb->data[5]);

In this driver you do know the device so you need to be using dev_ and
passing around dev (or something that gives you dev).

> +static int kim_probe(struct platform_device *pdev)
> +{
> +	long status;
> +	long proto;
> +	long *gpios = pdev->dev.platform_data;
> +
> +	status = st_core_init(&kim_gdata->core_data);

I would expect any truely global data to be configured in the module init
and then device specific data you want to do something like this

	kim_data = kzalloc(sizeof(something), GFP_KERNEL);

	..

	kim_data_init(&pdev->dev, kim_data);
	dev_set_drvdata(&pdev->dev, kim_data);

Elsewhere you can now do

	kim_data = dev_get_drvdata(&pdev->dev);

to get it back
