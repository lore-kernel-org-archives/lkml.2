Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab0K3MvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 07:51:00 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39510 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0K3Mu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 07:50:58 -0500
Message-ID: <5B8D58FB9E1C487FA94F2498E0B9E9AB@wipblrx0099946>
From: "Hemanth V" <hemanthv@ti.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <saaguirre@ti.com>,
        <Shubhrajyoti@ti.com>, "Jonathan Cameron" <jic23@cam.ac.uk>
References: <37129.10.24.255.17.1291028260.squirrel@dbdmail.itg.ti.com> <4CF38E4D.3070309@cam.ac.uk> <20101130075911.GC15731@core.coreip.homeip.net>
Subject: Re: PATCH V4 1/2] input: CMA3000 Accelerometer Driver
Date: Tue, 30 Nov 2010 18:20:43 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5843
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
>
> Yep, almost there.
>
> Hemanth, does the driver still work if you apply the patch below?

Yes works pretty well, Thanks for your efforts

Some minor changes as below required.

<snip>

> +struct cma3000_accl_data {
> + const struct cma3000_bus_ops *bus_ops;
> + const struct cma3000_platform_data *pdata;
> +
> + struct device *dev;
> + struct input_dev *input_dev;
> +
> + int bit_to_mg;
> + int irq;
> +
> + int g_range;
> + u8 mode;
> +
> + struct mutex mutex;

Need a comment to overcome checkpatch warning.

>
> - pr_info("CMA3000 Accelerometer : Revision %x\n", ret);
> + data->dev = dev;
> + data->input_dev = input_dev;
> + data->bus_ops = bops;
> + data->pdata = pdata;

Need to add data->irq = irq, else exit routine will dump stack

>
> - data->input_dev->name = "cma3000-accelerometer";
> + data->g_range = pdata->g_range;
> + if (data->g_range != CMARANGE_2G && data->g_range != CMA3000_RANGE8G) {

Need to change this to "data->g_range != CMARANGE_2G   && data->g_range != 
CMARANGE_8G "

> - input_set_abs_params(data->input_dev, ABS_Z, -g_range,
> - g_range, fuzz_z, 0);
> - input_set_abs_params(data->input_dev, ABS_MISC, 0,
> - 1, 0, 0);

We use this ABS_MISC event to report free fall.



