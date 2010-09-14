Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab0INRGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:06:39 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:59653 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab0INRGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:06:37 -0400
Subject: Re: [PATCH 1/2] drivers/char/tpm/tpm_stm_st19_i2c.c: Use pr_fmt,
 pr_<level> and FUNC_ENTER
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Christophe Henri RICARD <christophe-h.ricard@st.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, tpmdd-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b64d9478978867b8bdd059522af008463b8e26ad.1283556028.git.joe@perches.com>
References: <0B9F1C5B86169C4EA9D042C251022E49105CD81DE1@SAFEX1MAIL3.st.com>
	 <cover.1283556028.git.joe@perches.com>
	 <b64d9478978867b8bdd059522af008463b8e26ad.1283556028.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 14:06:28 -0300
Message-ID: <1284483988.17585.0.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

On Fri, 2010-09-03 at 16:29 -0700, Joe Perches wrote:
> Add FUNC_ENTER to emit pr_info("%s\n", __func_) with #DEBUG
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/char/tpm/tpm_stm_st19_i2c.c |   57 ++++++++++++++++++-----------------
>  1 files changed, 29 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_stm_st19_i2c.c b/drivers/char/tpm/tpm_stm_st19_i2c.c
> index 35307d2..cdf2eb3 100644
> --- a/drivers/char/tpm/tpm_stm_st19_i2c.c
> +++ b/drivers/char/tpm/tpm_stm_st19_i2c.c
> @@ -58,6 +58,8 @@
>   * ----------------------------------------------------------------------
>   */
> 
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/delay.h>
> @@ -81,6 +83,12 @@
> 
>  #include "tpm_stm_st19_i2c.h"
> 
> +#ifdef DEBUG
> +#define FUNC_ENTER()	pr_info("%s\n", __func__)
> +#else
> +#define FUNC_ENTER()	do {} while (0)
> +#endif
> +
>  /*
>   * @Comments: tpm_stm_st19_platform_specific.h deliver shows a platform specific
>   * file example.
> @@ -260,9 +268,7 @@ static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
>  	u32 ret = 0, i, size, ordinal, pin = 0;
>  	struct i2c_client *client;
> 
> -#ifdef DEBUG
> -	printk(KERN_INFO "tpm_st19_i2c: tpm_stm_i2c_send\n");
> -#endif
> +	FUNC_ENTER();
> 
>  	if (chip == NULL)
>  		return -EBUSY;
> @@ -337,7 +343,7 @@ static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
>  				    TPM_I2C_BLOCK_SIZE ? TPM_I2C_BLOCK_SIZE :
>  				    count - i : count);
>  		if (ret < 0) {
> -			printk(KERN_INFO "tpm_st19_i2c: Failed to send data\n");
> +			pr_info("Failed to send data\n");
>  			goto end;
>  		}
> 
> @@ -351,16 +357,13 @@ static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
>  							     (TPM_I2C_SHORT));
> 
>  		if (pin != COMMAND_ON) {
> -			printk(KERN_INFO
> -			       "tpm_st19_i2c:"
> -			       " Failed to read gpio pin (AcceptCmd)\n");
> +			pr_info("Failed to read gpio pin (AcceptCmd)\n");
>  			ret = -EIO;
>  			goto end;
>  		}
>  	}
>  	if (i == 0) {
> -		printk(KERN_INFO
> -		       "tpm_st19_i2c: Failed to read gpio pin (AcceptCmd)\n");
> +		pr_info("Failed to read gpio pin (AcceptCmd)\n");
>  		ret = -EIO;
>  	}
>  end:
> @@ -395,9 +398,7 @@ static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char *buf,
>  	int pin = 0;
>  	struct i2c_client *client;
> 
> -#ifdef DEBUG
> -	printk(KERN_INFO "tpm_st19_i2c: tpm_stm_i2c_recv\n");
> -#endif
> +	FUNC_ENTER();
> 
>  	if (chip == NULL)
>  		return -EBUSY;
> @@ -425,9 +426,7 @@ static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char *buf,
>  				     TPM_I2C_BLOCK_SIZE ? TPM_I2C_BLOCK_SIZE :
>  				     size - i : count));
>  		if (ret < 0) {
> -			printk(KERN_INFO
> -			       "tpm_st19_i2c:"
> -			       " Failed to read gpio pin (DataAvalaible)\n");
> +			pr_info("Failed to read gpio pin (DataAvailable)\n");
>  			goto end;
>  		}
> 
> @@ -444,7 +443,7 @@ static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char *buf,
>  					size = count;
>  			}
>  		} else {
> -			printk(KERN_INFO "tpm_st19_i2c: read buffer is NULL\n");
> +			pr_info("read buffer is NULL\n");
>  			goto end;
>  		}
> 
> @@ -459,9 +458,7 @@ static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char *buf,
>  	}
> 
>  	if (i == 0) {
> -		printk(KERN_INFO
> -		       "tpm_st19_i2c: "
> -		       "Failed to read gpio pin (DataAvalaible)\n");
> +		pr_info("Failed to read gpio pin (DataAvailable)\n");
>  		ret = -EIO;
>  		goto end;
>  	}
> @@ -501,7 +498,8 @@ static void tpm_st19_i2c_dummy(struct device *dev)
>  static void tpm_st19_i2c_release(struct kobject *kobj)
>  {
>  	struct tpm_chip *chip;
> -	printk(KERN_INFO "tpm_st19_i2c_release\n");
> +
> +	FUNC_ENTER();
> 
>  	if (_client != NULL) {
>  		chip = (struct tpm_chip *)i2c_get_clientdata(_client);
> @@ -614,19 +612,19 @@ tpm_st19_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	struct tpm_chip *chip;
>  	struct st19np18_platform_data *platform_data;
> 
> -	printk(KERN_INFO "tpm_st19_i2c: tpm_st19_i2c_probe\n");
> +	FUNC_ENTER();
> 
>  	err = 0;
> 
>  	/* Check I2C platform functionnalities */
>  	if (client == NULL) {
> -		printk(KERN_INFO "client is NULL. exiting.\n");
> +		pr_info("client is NULL. exiting.\n");
>  		err = -ENODEV;
>  		goto end;
>  	}
> 
>  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> -		printk(KERN_INFO "tpm_st19_i2c: client not i2c capable\n");
> +		pr_info("client not i2c capable\n");
>  		err = -ENODEV;
>  		goto end;
>  	}
> @@ -680,7 +678,7 @@ tpm_st19_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	i2c_set_clientdata(client, chip);
>  	pin_infos->bChipF = false;
> 
> -	printk(KERN_INFO "tpm_st19_i2c: TPM I2C Initialized\n");
> +	pr_info("TPM I2C Initialized\n");
>  	return 0;
>  _gpio_set:
>  _gpio_init:
> @@ -701,7 +699,7 @@ _tpm_clean_answer:
>  	}
>  	pin_infos->bChipF = true;
>  end:
> -	printk(KERN_INFO "tpm_st19_i2c: TPM I2C initialisation fail\n");
> +	pr_info("TPM I2C initialisation fail\n");
>  	return err;
>  }
> 
> @@ -714,7 +712,8 @@ end:
>  static __devexit int tpm_st19_i2c_remove(struct i2c_client *client)
>  {
>  	struct tpm_chip *chip = (struct tpm_chip *)i2c_get_clientdata(client);
> -	printk(KERN_INFO "tpm_st19_i2c: tpm_st19_i2c_remove\n");
> +
> +	FUNC_ENTER();
> 
>  	if (pin_infos != NULL) {
>  		gpio_free(pin_infos->accept_pin);
> @@ -799,7 +798,8 @@ static struct i2c_driver tpm_st19_i2c_driver = {
>   */
>  static int __init tpm_st19_i2c_init(void)
>  {
> -	printk(KERN_INFO "tpm_st19_i2c: tpm_st19_i2c_init\n");
> +	FUNC_ENTER();
> +
>  	return i2c_add_driver(&tpm_st19_i2c_driver);
>  }
> 
> @@ -809,7 +809,8 @@ static int __init tpm_st19_i2c_init(void)
>   */
>  static void __exit tpm_st19_i2c_exit(void)
>  {
> -	printk(KERN_INFO "tpm_st19_i2c: tpm_st19_i2c_exit\n");
> +	FUNC_ENTER();
> +
>  	i2c_del_driver(&tpm_st19_i2c_driver);
>  }
> 


