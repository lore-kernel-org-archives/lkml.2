Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2HCJ1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:27:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5143 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2HCJ1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:27:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 03 Aug 2012 02:27:47 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Vikram Pandita <vikram.pandita@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kay@vrfy.org" <kay@vrfy.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Date: Fri, 3 Aug 2012 14:57:42 +0530
Subject: RE: [PATCH v2] printk: add option to print cpu id
Thread-Topic: [PATCH v2] printk: add option to print cpu id
Thread-Index: Ac1xWMtvTs8UoHTwQBiUNqGfW2tFVwAALGNQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDCAC49AB@BGMAIL02.nvidia.com>
References: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com>
In-Reply-To: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Vikram Pandita
> Sent: Friday, August 03, 2012 2:46 PM
> To: gregkh@linuxfoundation.org; kay@vrfy.org
> Cc: linux-kernel@vger.kernel.org; Vikram Pandita; Mike Turquette; Vimarsh
> Zutshi
> Subject: [PATCH v2] printk: add option to print cpu id
> 
> From: Vikram Pandita <vikram.pandita@ti.com>
> 
> Introduce config option to enable CPU id reporting for printk() calls.
> 
> Example logs with this option enabled look like:
>  [1] [    2.328613] usbcore: registered new interface driver libusual
>  [1] [    2.335418] usbcore: registered new interface driver usbtest
>  [1] [    2.342803] mousedev: PS/2 mouse device common for all mice
>  [0] [    2.352600] twl_rtc twl_rtc: Power up reset detected.
>  [0] [    2.359191] twl_rtc twl_rtc: Enabling TWL-RTC
>  [1] [    2.367797] twl_rtc twl_rtc: rtc core: registered twl_rtc as rtc0
>  [1] [    2.375274] i2c /dev entries driver
>  [1] [    2.382324] Driver for 1-wire Dallas network protocol.
> 
> Its sometimes very useful to have printk also print the CPU Identifier
> that executed the call. This has helped to debug various SMP issues on
> shipping
> products.

Is it not better to have macros which will have wrapper to printk with required
debug info added? E.g. cpu# in your case.
If by default we add cupid, is it not over head in each message getting
printed with printk?

> 
> Known limitation is if the system gets preempted between function call and
> actual printk, the reported cpu-id might not be accurate. But most of the
> times its seen to give a good feel of how the N cpu's in the system are
> getting loaded.
> 
