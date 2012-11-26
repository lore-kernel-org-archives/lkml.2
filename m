Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab2KZPwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:52:44 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46327 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab2KZPwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:52:42 -0500
Date: Mon, 26 Nov 2012 09:51:48 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Mathias LEBLANC <Mathias.LEBLANC@st.com>
Cc: Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
Message-ID: <20121126155148.GA10104@ennui.austin.ibm.com>
References: <1352903504-3364-1-git-send-email-mathias.leblanc@st.com>
 <20121114220647.GA533@ennui.austin.ibm.com>
 <35286B1AE75A7C47BFF0870081A31B4B3A990A7BE0@SAFEX1MAIL4.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35286B1AE75A7C47BFF0870081A31B4B3A990A7BE0@SAFEX1MAIL4.st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112615-5806-0000-0000-00001C2B92BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 09:26:40AM +0100, Mathias LEBLANC wrote:
> Hello,
> 
> Does anyone can say me when the driver will be integrated on linux kernel and where can we get it  from the linux source code?

 Hi Mathias, I'll work with you this week to get this pushed to the
security-next tree.  From there the code is pushed to Linus' tree.

Kent

> Thanks,
> 
> Mathias Leblanc
> 
> -----Original Message-----
> From: Kent Yoder [mailto:key@linux.vnet.ibm.com] 
> Sent: 14 November, 2012 23:07
> To: Mathias LEBLANC
> Cc: Rajiv Andrade; Marcel Selhorst; Sirrix AG; tpmdd-devel@lists.sourceforge.net; Debora Velarde; linux-kernel@vger.kernel.org; Jean-Luc BLANC
> Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
> 
> Hi Mathias,
> 
> On Wed, Nov 14, 2012 at 03:31:42PM +0100, Mathias Leblanc wrote:
> >  * STMicroelectronics version 1.2.0, Copyright (C) 2010
> >  * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> >  * This is free software, and you are welcome to redistribute it
> >  * under certain conditions.
> > 
> > This is the driver for TPM chip from ST Microelectronics.
> > 
> > If you have a TPM security chip from STMicroelectronics working with 
> > an I2C, in menuconfig or .config choose the tpm driver on device --> 
> > tpm and activate the protocol of your choice before compiling the 
> > kernel.
> > The driver will be accessible from within Linux.
> > 
> > Tested on linux x86/x64, beagleboard REV B & XM REV C and CHROMIUM OS
> 
>   Getting some build errors here:
> 
> drivers/char/tpm/tpm_stm_st33_i2c.c: In function ‘__check_interrupts’:
> drivers/char/tpm/tpm_stm_st33_i2c.c:615:1: warning: return from incompatible pointer type [enabled by default]
> drivers/char/tpm/tpm_stm_st33_i2c.c: In function ‘__check_power_mgt’:
> drivers/char/tpm/tpm_stm_st33_i2c.c:619:1: warning: return from incompatible pointer type [enabled by default]
> drivers/char/tpm/tpm_stm_st33_i2c.c: In function ‘tpm_st33_i2c_probe’:
> drivers/char/tpm/tpm_stm_st33_i2c.c:725:3: warning: suggest parentheses around arithmetic in operand of ‘|’ [-Wparentheses]
> drivers/char/tpm/tpm_stm_st33_i2c.c: In function
> ‘tpm_st33_i2c_pm_suspend’:
> drivers/char/tpm/tpm_stm_st33_i2c.c:826:3: error: too many arguments to function ‘tpm_pm_suspend’
> In file included from drivers/char/tpm/tpm_stm_st33_i2c.h:55:0,
>                  from drivers/char/tpm/tpm_stm_st33_i2c.c:35:
> 		 drivers/char/tpm/tpm.h:326:12: note: declared here
> 		 drivers/char/tpm/tpm_stm_st33_i2c.c: In function
> 		 ‘tpm_st33_i2c_pm_resume’:
> 		 drivers/char/tpm/tpm_stm_st33_i2c.c:855:3: error:
> 		 implicit declaration of function
> 		 ‘tpm_continue_selftest’
> 		 [-Werror=implicit-function-declaration]
> 
> [cut]
> > +/*
> > + * _wait_for_interrupt_serirq_timeout
> > + * @param: tpm, the chip description
> > + * @param: timeout, the timeout of the interrupt
> > + * @return: the status of the interruption.
> > + */
> > +static int _wait_for_interrupt_serirq_timeout(struct tpm_chip *chip,
> > +						unsigned long timeout)
> > +{
> > +	int status;
> > +	struct i2c_client *client;
> > +	struct st33zp24_platform_data *pin_infos;
> > +
> > +	client = (struct i2c_client *) chip->vendor.iobase;
> > +	pin_infos = client->dev.platform_data;
> > +
> > +	status = wait_for_completion_interruptible_timeout(
> > +					&pin_infos->irq_detection,
> > +						timeout);
> 
>   status should be a long here.
> 
> [cut]
> > +
> > +	if (client == NULL) {
> > +		pr_info("client is NULL. exiting.\n");
> > +		err = -ENODEV;
> > +		goto end;
> > +	}
> > +
> > +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> > +		pr_info("client not i2c capable\n");
> > +		err = -ENODEV;
> > +		goto end;
> > +	}
> > +
> > +	chip = tpm_register_hardware(&client->dev, &st_i2c_tpm);
> > +	if (!chip) {
> > +		pr_info("fail chip\n");
> 
>   Please use dev_info() in place of pr_info().
> 
> Thanks,
> Kent
> 

