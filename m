Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1D0HCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 03:02:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45843 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1D0HCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 03:02:32 -0400
Message-ID: <1F65A5A7A9494B73A22BDA7D64355767@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Sergei Shtylyov" <sshtylyov@mvista.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        "Kevin Hilman" <khilman@ti.com>, <sachi@mistralsolutions.com>,
        "Russell King" <linux@arm.linux.org.uk>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>, <m-watkins@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-12-git-send-email-subhasish@mistralsolutions.com> <4DB6A509.2010009@mvista.com>
In-Reply-To: <4DB6A509.2010009@mvista.com>
Subject: Re: [PATCH v4 11/11] da850: pruss CAN board specific additions.
Date: Wed, 27 Apr 2011 12:33:08 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +static int __init da850_evm_pruss_can_setup(void)
>> +{
>> + int ret, val = 0;
>> + void __iomem *cfg_chip3_reg;
>> +
>> + ret = davinci_cfg_reg_list(da850_evm_pruss_can_pins);
>> + if (ret)
>> + pr_warning("%s: da850_evm_pruss_can_pins mux setup "
>> + "failed:%d\n", __func__, ret);
>
>    Yet you continue to initialize... you should stop here I think.

SG - Ok, will ret error.

>
>> + /* value = 0 to enable the CAN transceiver */
>> + ret = gpio_request_one(DA850_PRUSS_CAN_TRX_PIN,
>> + GPIOF_OUT_INIT_LOW, "pruss_can_en");
>> + if (ret) {
>> + pr_warning("Cannot setup GPIO %d\n", DA850_PRUSS_CAN_TRX_PIN);
>> + gpio_free(DA850_PRUSS_CAN_TRX_PIN);
>
>    Doesn't gpio_request_one() handle freeing GPIO on error?

SG - It does handle error, will remove. But I have another problem,
        Suppose the init failed due to some other reason during probe.
        How can I do a gpio_free, do I need some kind of deinit for the 
setup ?

 

