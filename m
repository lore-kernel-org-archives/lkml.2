Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab2LRJwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:52:42 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:23369 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab2LRJwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:52:40 -0500
Date: Tue, 18 Dec 2012 10:52:23 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver i2c-nforce2: fix pointer CodingStyle issues
Message-ID: <20121218105223.0184d4a3@endymion.delvare>
In-Reply-To: <1355778259-8445-1-git-send-email-laurent.navet@gmail.com>
References: <1355778259-8445-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Mon, 17 Dec 2012 22:04:19 +0100, Laurent Navet wrote:
> fix these errors reported by checkpatch.pl
> - drivers/i2c/busses/i2c-nforce2.c:191
> - drivers/i2c/busses/i2c-nforce2.c:193
> ERROR: "foo * bar" should be "foo *bar"
> 
> - drivers/i2c/busses/i2c-nforce2.c:302:
> ERROR: "(foo*)" should be "(foo *)"
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/i2c/busses/i2c-nforce2.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
> index 392303b..9db5ff5 100644
> --- a/drivers/i2c/busses/i2c-nforce2.c
> +++ b/drivers/i2c/busses/i2c-nforce2.c
> @@ -188,9 +188,9 @@ static int nforce2_check_status(struct i2c_adapter *adap)
>  }
>  
>  /* Return negative errno on error */
> -static s32 nforce2_access(struct i2c_adapter * adap, u16 addr,
> +static s32 nforce2_access(struct i2c_adapter *adap, u16 addr,
>  		unsigned short flags, char read_write,
> -		u8 command, int size, union i2c_smbus_data * data)
> +		u8 command, int size, union i2c_smbus_data *data)
>  {
>  	struct nforce2_smbus *smbus = adap->algo_data;
>  	unsigned char protocol, pec;
> @@ -299,7 +299,7 @@ static u32 nforce2_func(struct i2c_adapter *adapter)
>  	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
>  	       I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
>  	       I2C_FUNC_SMBUS_PEC |
> -	       (((struct nforce2_smbus*)adapter->algo_data)->blockops ?
> +	       (((struct nforce2_smbus *)adapter->algo_data)->blockops ?
>  		I2C_FUNC_SMBUS_BLOCK_DATA : 0);
>  }
>  

This is correct, however there are several other checkpatch errors and
warnings in this file and I would appreciate if you could fix them as
well. I'm not asking that you fix them all, but please consider fixing
the following:

WARNING: space prohibited between function name and open parenthesis '('
#63: FILE: i2c/busses/i2c-nforce2.c:63:
+MODULE_AUTHOR ("Hans-Frieder Vogt <hfvogt@gmx.net>");

WARNING: suspect code indent for conditional statements (24, 33)
#226: FILE: i2c/busses/i2c-nforce2.c:226:
+			if (read_write == I2C_SMBUS_WRITE) {
+				 outb_p(data->word, NVIDIA_SMB_DATA);

WARNING: line over 80 characters
#275: FILE: i2c/busses/i2c-nforce2.c:275:
+			data->word = inb_p(NVIDIA_SMB_DATA) | (inb_p(NVIDIA_SMB_DATA+1) << 8);

WARNING: quoted string split across lines
#282: FILE: i2c/busses/i2c-nforce2.c:282:
+				dev_err(&adap->dev, "Transaction failed "
+					"(received block size: 0x%02x)\n",

WARNING: space prohibited between function name and open parenthesis '('
#330: FILE: i2c/busses/i2c-nforce2.c:330:
+MODULE_DEVICE_TABLE (pci, nforce2_ids);

WARNING: line over 80 characters
#380: FILE: i2c/busses/i2c-nforce2.c:380:
+	dev_info(&smbus->adapter.dev, "nForce2 SMBus adapter at %#x\n", smbus->base);

ERROR: space required before the open parenthesis '('
#395: FILE: i2c/busses/i2c-nforce2.c:395:
+	switch(dev->device) {

These are simple coding style issues, very easy to fix.

Thanks,
-- 
Jean Delvare
