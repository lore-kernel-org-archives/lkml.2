Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab2KTI1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:27:40 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:48839 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513Ab2KTI1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:27:39 -0500
From: Mathias LEBLANC <Mathias.LEBLANC@st.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>
Date: Tue, 20 Nov 2012 09:26:40 +0100
Subject: RE: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
Thread-Topic: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
Thread-Index: Ac3CtGwi/JQ7RVPiRR6VpEzITQov5AEQ3ToQ
Message-ID: <35286B1AE75A7C47BFF0870081A31B4B3A990A7BE0@SAFEX1MAIL4.st.com>
References: <1352903504-3364-1-git-send-email-mathias.leblanc@st.com>
 <20121114220647.GA533@ennui.austin.ibm.com>
In-Reply-To: <20121114220647.GA533@ennui.austin.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAK8RjHP020492

Hello,

Does anyone can say me when the driver will be integrated on linux kernel and where can we get it  from the linux source code?

Thanks,

Mathias Leblanc

-----Original Message-----
From: Kent Yoder [mailto:key@linux.vnet.ibm.com] 
Sent: 14 November, 2012 23:07
To: Mathias LEBLANC
Cc: Rajiv Andrade; Marcel Selhorst; Sirrix AG; tpmdd-devel@lists.sourceforge.net; Debora Velarde; linux-kernel@vger.kernel.org; Jean-Luc BLANC
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C

Hi Mathias,

On Wed, Nov 14, 2012 at 03:31:42PM +0100, Mathias Leblanc wrote:
>  * STMicroelectronics version 1.2.0, Copyright (C) 2010
>  * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
>  * This is free software, and you are welcome to redistribute it
>  * under certain conditions.
> 
> This is the driver for TPM chip from ST Microelectronics.
> 
> If you have a TPM security chip from STMicroelectronics working with 
> an I2C, in menuconfig or .config choose the tpm driver on device --> 
> tpm and activate the protocol of your choice before compiling the 
> kernel.
> The driver will be accessible from within Linux.
> 
> Tested on linux x86/x64, beagleboard REV B & XM REV C and CHROMIUM OS

  Getting some build errors here:

drivers/char/tpm/tpm_stm_st33_i2c.c: In function â€˜__check_interruptsâ€™:
drivers/char/tpm/tpm_stm_st33_i2c.c:615:1: warning: return from incompatible pointer type [enabled by default]
drivers/char/tpm/tpm_stm_st33_i2c.c: In function â€˜__check_power_mgtâ€™:
drivers/char/tpm/tpm_stm_st33_i2c.c:619:1: warning: return from incompatible pointer type [enabled by default]
drivers/char/tpm/tpm_stm_st33_i2c.c: In function â€˜tpm_st33_i2c_probeâ€™:
drivers/char/tpm/tpm_stm_st33_i2c.c:725:3: warning: suggest parentheses around arithmetic in operand of â€˜|â€™ [-Wparentheses]
drivers/char/tpm/tpm_stm_st33_i2c.c: In function
â€˜tpm_st33_i2c_pm_suspendâ€™:
drivers/char/tpm/tpm_stm_st33_i2c.c:826:3: error: too many arguments to function â€˜tpm_pm_suspendâ€™
In file included from drivers/char/tpm/tpm_stm_st33_i2c.h:55:0,
                 from drivers/char/tpm/tpm_stm_st33_i2c.c:35:
		 drivers/char/tpm/tpm.h:326:12: note: declared here
		 drivers/char/tpm/tpm_stm_st33_i2c.c: In function
		 â€˜tpm_st33_i2c_pm_resumeâ€™:
		 drivers/char/tpm/tpm_stm_st33_i2c.c:855:3: error:
		 implicit declaration of function
		 â€˜tpm_continue_selftestâ€™
		 [-Werror=implicit-function-declaration]

[cut]
> +/*
> + * _wait_for_interrupt_serirq_timeout
> + * @param: tpm, the chip description
> + * @param: timeout, the timeout of the interrupt
> + * @return: the status of the interruption.
> + */
> +static int _wait_for_interrupt_serirq_timeout(struct tpm_chip *chip,
> +						unsigned long timeout)
> +{
> +	int status;
> +	struct i2c_client *client;
> +	struct st33zp24_platform_data *pin_infos;
> +
> +	client = (struct i2c_client *) chip->vendor.iobase;
> +	pin_infos = client->dev.platform_data;
> +
> +	status = wait_for_completion_interruptible_timeout(
> +					&pin_infos->irq_detection,
> +						timeout);

  status should be a long here.

[cut]
> +
> +	if (client == NULL) {
> +		pr_info("client is NULL. exiting.\n");
> +		err = -ENODEV;
> +		goto end;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		pr_info("client not i2c capable\n");
> +		err = -ENODEV;
> +		goto end;
> +	}
> +
> +	chip = tpm_register_hardware(&client->dev, &st_i2c_tpm);
> +	if (!chip) {
> +		pr_info("fail chip\n");

  Please use dev_info() in place of pr_info().

Thanks,
Kent

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
