Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1IMIdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 04:33:08 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:35027 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab1IMIdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 04:33:05 -0400
From: Marc Dietich <marvin24@gmx.de>
To: Pelle Windestam <iceaway@gmail.com>
Subject: Re: [PATCH 1/1] drivers: staging: nvec: fixed checkpatch warnings in nvec.c/h.
Date: Tue, 13 Sep 2011 10:32:47 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc5+; KDE/4.6.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1315896651-9902-1-git-send-email-iceaway@gmail.com>
In-Reply-To: <1315896651-9902-1-git-send-email-iceaway@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109131032.47761.marvin24@gmx.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-Envelope-From: marvin24@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pelle,

> Fixed checkpatch warnings regarding general coding style issues in
> nvec.c and nvec.h

thanks for review. A similar patch was submitted to the drivers-project back in 
August [1] and merged in September to the staging tree. Unfortunately, this tree 
isn't avaiable now and the 3.2 release cycle hasn't started yet....

Anyway, if you are still motivated to check again against the current version, 
I'll happily consider it for inclusion.

Thanks

Marc


[1] http://driverdev.linuxdriverproject.org/pipermail/devel/2011-
August/018963.html


> Signed-off-by: Pelle Windestam <iceaway@gmail.com>
> --->  drivers/staging/nvec/nvec.c |  157
> ++++++++++++++++++++++-------------------- drivers/staging/nvec/nvec.h |  
> 17 +++--
>  2 files changed, 93 insertions(+), 81 deletions(-)
> 
> diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> index 72258e8..1dcaa98 100644
> --- a/drivers/staging/nvec/nvec.c
> +++ b/drivers/staging/nvec/nvec.c
> @@ -1,10 +1,10 @@
> -// #define DEBUG
> +/* #define DEBUG */
> 
>  /* ToDo list (incomplete, unorderd)
>  	- convert mouse, keyboard, and power to platform devices
>  */
> 
> -#include <asm/io.h>
> +#include <linux/io.h>
>  #include <asm/irq.h>
>  #include <linux/completion.h>
>  #include <linux/interrupt.h>
> @@ -24,9 +24,9 @@
>  #include <linux/platform_device.h>
>  #include "nvec.h"
> 
> -static unsigned char EC_DISABLE_EVENT_REPORTING[]
> =	{'\x04','\x00','\x00'}; -static unsigned char
> EC_ENABLE_EVENT_REPORTING[] =	{'\x04','\x00','\x01'}; -static unsigned
> char EC_GET_FIRMWARE_VERSION[] =	{'\x07','\x15'}; +static unsigned char
> EC_DISABLE_EVENT_REPORTING[] = { '\x04', '\x00', '\x00' }; +static
> unsigned char EC_ENABLE_EVENT_REPORTING[] = { '\x04', '\x00', '\x01' };
> +static unsigned char EC_GET_FIRMWARE_VERSION[] = { '\x07', '\x15' };
> 
>  static struct nvec_chip *nvec_power_handle;
> 
> @@ -37,13 +37,14 @@ int nvec_register_notifier(struct nvec_chip *nvec,
> struct notifier_block *nb, }
>  EXPORT_SYMBOL_GPL(nvec_register_notifier);
> 
> -static int nvec_status_notifier(struct notifier_block *nb, unsigned long
> event_type, +static int nvec_status_notifier(struct notifier_block *nb,
> +				unsigned long event_type,
>  				void *data)
>  {
>  	unsigned char *msg = (unsigned char *)data;
>  	int i;
> 
> -	if(event_type != NVEC_CNTL)
> +	if (event_type != NVEC_CNTL)
>  		return NOTIFY_DONE;
> 
>  	printk("unhandled msg type %ld, payload: ", event_type);
> @@ -75,42 +76,45 @@ static void nvec_request_master(struct work_struct
> *work) {
>  	struct nvec_chip *nvec = container_of(work, struct nvec_chip, tx_work);
> 
> -	if(!list_empty(&nvec->tx_data)) {
> +	if (!list_empty(&nvec->tx_data))
>  		gpio_set_value(nvec->gpio, 0);
> -	}
>  }
> 
>  static int parse_msg(struct nvec_chip *nvec, struct nvec_msg *msg)
>  {
>  	int i;
> 
> -	if((msg->data[0] & 1<<7) == 0 && msg->data[3]) {
> -		dev_err(nvec->dev, "ec responded %02x %02x %02x %02x\n", msg->data[0],
> -			msg->data[1], msg->data[2], msg->data[3]);
> +	if ((msg->data[0] & 1<<7) == 0 && msg->data[3]) {
> +		dev_err(nvec->dev, "ec responded %02x %02x %02x %02x\n",
> +			msg->data[0], msg->data[1],
> +			msg->data[2], msg->data[3]);
>  		return -EINVAL;
>  	}
> 
> -	if ((msg->data[0] >> 7 ) == 1 && (msg->data[0] & 0x0f) == 5)
> -	{
> +	if ((msg->data[0] >> 7) == 1 && (msg->data[0] & 0x0f) == 5) {
>  		dev_warn(nvec->dev, "ec system event ");
> -		for (i=0; i < msg->data[1]; i++)
> +		for (i = 0; i < msg->data[1]; i++)
>  			dev_warn(nvec->dev, "%02x ", msg->data[2+i]);
>  		dev_warn(nvec->dev, "\n");
>  	}
> 
> -	atomic_notifier_call_chain(&nvec->notifier_list, msg->data[0] & 0x8f,
> msg->data); +	atomic_notifier_call_chain(&nvec->notifier_list,
> msg->data[0] & 0x8f, +				   msg->data);
> 
>  	return 0;
>  }
> 
> -static struct nvec_msg *nvec_write_sync(struct nvec_chip *nvec, unsigned
> char *data, short size) +static struct nvec_msg *nvec_write_sync(struct
> nvec_chip *nvec,
> +					unsigned char *data,
> +					short size)
>  {
>  	down(&nvec->sync_write_mutex);
> 
>  	nvec->sync_write_pending = (data[1] << 8) + data[0];
>  	nvec_write_async(nvec, data, size);
> 
> -	dev_dbg(nvec->dev, "nvec_sync_write: 0x%04x\n",
> nvec->sync_write_pending); +	dev_dbg(nvec->dev, "nvec_sync_write:
> 0x%04x\n",
> +		nvec->sync_write_pending);
>  	wait_for_completion(&nvec->sync_write);
>  	dev_dbg(nvec->dev, "nvec_sync_write: pong!\n");
> 
> @@ -125,20 +129,19 @@ static void nvec_dispatch(struct work_struct *work)
>  	struct nvec_chip *nvec = container_of(work, struct nvec_chip, rx_work);
>  	struct nvec_msg *msg;
> 
> -	while(!list_empty(&nvec->rx_data))
> -	{
> +	while (!list_empty(&nvec->rx_data)) {
>  		msg = list_first_entry(&nvec->rx_data, struct nvec_msg, node);
>  		list_del_init(&msg->node);
> 
> -		if(nvec->sync_write_pending == (msg->data[2] << 8) + msg->data[0])
> -		{
> +		if (nvec->sync_write_pending ==
> +		   (msg->data[2] << 8) + msg->data[0]) {
>  			dev_dbg(nvec->dev, "sync write completed!\n");
>  			nvec->sync_write_pending = 0;
>  			nvec->last_sync_msg = msg;
>  			complete(&nvec->sync_write);
>  		} else {
>  			parse_msg(nvec, msg);
> -			if((!msg) || (!msg->data))
> +			if ((!msg) || (!msg->data))
>  				dev_warn(nvec->dev, "attempt access zero pointer");
>  			else {
>  				kfree(msg->data);
> @@ -159,20 +162,19 @@ static irqreturn_t i2c_interrupt(int irq, void *dev)
> 
>  	status = readl(i2c_regs + I2C_SL_STATUS);
> 
> -	if(!(status & I2C_SL_IRQ))
> -	{
> +	if (!(status & I2C_SL_IRQ)) {
>  		dev_warn(nvec->dev, "nvec Spurious IRQ\n");
> -		//Yup, handled. ahum.
> +		/* Yup, handled. ahum. */
>  		goto handled;
>  	}
> -	if(status & END_TRANS && !(status & RCVD))
> -	{
> -		//Reenable IRQ only when even has been sent
> -		//printk("Write sequence ended !\n");
> -                //parse_msg(nvec);
> +	if (status & END_TRANS && !(status & RCVD)) {
> +		/*
> +		 * Reenable IRQ only when even has been sent
> +		 * printk("Write sequence ended !\n")
> +		 * parse_msg(nvec);
> +		 */
>  		nvec->state = NVEC_WAIT;
> -		if(nvec->rx->size > 1)
> -		{
> +		if (nvec->rx->size > 1) {
>  			list_add_tail(&nvec->rx->node, &nvec->rx_data);
>  			schedule_work(&nvec->rx_work);
>  		} else {
> @@ -180,41 +182,45 @@ static irqreturn_t i2c_interrupt(int irq, void *dev)
>  			kfree(nvec->rx);
>  		}
>  		return IRQ_HANDLED;
> -	} else if(status & RNW)
> -	{
> -		// Work around for AP20 New Slave Hw Bug. Give 1us extra.
> -		// nvec/smbus/nvec_i2c_transport.c in NV`s crap for reference
> -		if(status & RCVD)
> +	} else if (status & RNW) {
> +		/*
> +		 * Work around for AP20 New Slave Hw Bug. Give 1us extra.
> +		 * nvec/smbus/nvec_i2c_transport.c in NV`s crap for reference
> +		 */
> +		if (status & RCVD)
>  			udelay(3);
> 
> -		if(status & RCVD)
> -		{
> +		if (status & RCVD) {
>  			nvec->state = NVEC_WRITE;
> -			//Master wants something from us. New communication
> -//			dev_dbg(nvec->dev, "New read comm!\n");
> +			/* Master wants something from us. New communication */
> +			/* dev_dbg(nvec->dev, "New read comm!\n"); */
>  		} else {
> -			//Master wants something from us from a communication we've already
> started -//			dev_dbg(nvec->dev, "Read comm cont !\n");
> +			/*
> +			 * Master wants something from us from a communication
> +			 * we've already started
> +			 */
> +			/* dev_dbg(nvec->dev, "Read comm cont !\n"); */
>  		}
> -		//if(msg_pos<msg_size) {
> -		if(list_empty(&nvec->tx_data))
> -		{
> +		/* if(msg_pos<msg_size) { */
> +		if (list_empty(&nvec->tx_data)) {
>  			dev_err(nvec->dev, "nvec empty tx - sending no-op\n");
>  			to_send = 0x8a;
>  			nvec_write_async(nvec, "\x07\x02", 2);
> -//			to_send = 0x01;
> +			/* to_send = 0x01; */
>  		} else {
> -			msg = list_first_entry(&nvec->tx_data, struct nvec_msg, node);
> -			if(msg->pos < msg->size) {
> +			msg = list_first_entry(&nvec->tx_data,
> +					       struct nvec_msg,
> +					       node);
> +			if (msg->pos < msg->size) {
>  				to_send = msg->data[msg->pos];
>  				msg->pos++;
>  			} else {
> -				dev_err(nvec->dev, "nvec crap! %d\n", msg->size);
> +				dev_err(nvec->dev, "nvec crap! %d\n",
> +					msg->size);
>  				to_send = 0x01;
>  			}
> 
> -			if(msg->pos >= msg->size)
> -			{
> +			if (msg->pos >= msg->size) {
>  				list_del_init(&msg->node);
>  				kfree(msg->data);
>  				kfree(msg);
> @@ -231,14 +237,13 @@ static irqreturn_t i2c_interrupt(int irq, void *dev)
>  		goto handled;
>  	} else {
>  		received = readl(i2c_regs + I2C_SL_RCVD);
> -		//Workaround?
> -		if(status & RCVD) {
> +		/* Workaround? */
> +		if (status & RCVD) {
>  			writel(0, i2c_regs + I2C_SL_RCVD);
>  			goto handled;
>  		}
> 
> -		if (nvec->state == NVEC_WAIT)
> -		{
> +		if (nvec->state == NVEC_WAIT) {
>  			nvec->state = NVEC_READ;
>  			msg = kzalloc(sizeof(struct nvec_msg), GFP_NOWAIT);
>  			msg->data = kzalloc(32, GFP_NOWAIT);
> @@ -252,13 +257,15 @@ static irqreturn_t i2c_interrupt(int irq, void *dev)
>  		msg->data[msg->pos] = received;
>  		msg->pos++;
>  		msg->size = msg->pos;
> -		dev_dbg(nvec->dev, "Got %02lx from Master (pos: %d)!\n", received,
> msg->pos); +		dev_dbg(nvec->dev, "Got %02lx from Master (pos: %d)!\n",
> +			received, msg->pos);
>  	}
>  handled:
>  	return IRQ_HANDLED;
>  }
> 
> -static int __devinit nvec_add_subdev(struct nvec_chip *nvec, struct
> nvec_subdev *subdev) +static int __devinit nvec_add_subdev(struct
> nvec_chip *nvec,
> +				     struct nvec_subdev *subdev)
>  {
>  	struct platform_device *pdev;
> 
> @@ -269,8 +276,9 @@ static int __devinit nvec_add_subdev(struct nvec_chip
> *nvec, struct nvec_subdev return platform_device_add(pdev);
>  }
> 
> -static void tegra_init_i2c_slave(struct nvec_platform_data *pdata,
> unsigned char *i2c_regs, -					struct clk *i2c_clk)
> +static void tegra_init_i2c_slave(struct nvec_platform_data *pdata,
> +				 unsigned char *i2c_regs,
> +				 struct clk *i2c_clk)
>  {
>  	u32 val;
> 
> @@ -307,7 +315,7 @@ static int __devinit tegra_nvec_probe(struct
> platform_device *pdev) unsigned char *i2c_regs;
> 
>  	nvec = kzalloc(sizeof(struct nvec_chip), GFP_KERNEL);
> -	if(nvec == NULL) {
> +	if (nvec == NULL) {
>  		dev_err(&pdev->dev, "failed to reserve memory\n");
>  		return -ENOMEM;
>  	}
> @@ -324,7 +332,7 @@ static int __devinit tegra_nvec_probe(struct
> platform_device *pdev) clk_enable(i2c_clk);
>  */
>  	i2c_regs = ioremap(pdata->base, pdata->size);
> -	if(!i2c_regs) {
> +	if (!i2c_regs) {
>  		dev_err(nvec->dev, "failed to ioremap registers\n");
>  		goto failed;
>  	}
> @@ -332,15 +340,16 @@ static int __devinit tegra_nvec_probe(struct
> platform_device *pdev) nvec->i2c_regs = i2c_regs;
> 
>  	i2c_clk = clk_get_sys(pdata->clock, NULL);
> -	if(IS_ERR_OR_NULL(i2c_clk)) {
> +	if (IS_ERR_OR_NULL(i2c_clk)) {
>  		dev_err(nvec->dev, "failed to get clock tegra-i2c.2\n");
>  		goto failed;
>  	}
> 
>  	tegra_init_i2c_slave(pdata, i2c_regs, i2c_clk);
> 
> -	err = request_irq(nvec->irq, i2c_interrupt, IRQF_DISABLED, "nvec", nvec);
> -	if(err) {
> +	err = request_irq(nvec->irq, i2c_interrupt, IRQF_DISABLED, "nvec",
> +			  nvec);
> +	if (err) {
>  		dev_err(nvec->dev, "couldn't request irq");
>  		goto failed;
>  	}
> @@ -350,7 +359,7 @@ static int __devinit tegra_nvec_probe(struct
> platform_device *pdev)
> 
>  	/* Set the gpio to low when we've got something to say */
>  	err = gpio_request(nvec->gpio, "nvec gpio");
> -	if(err < 0)
> +	if (err < 0)
>  		dev_err(nvec->dev, "couldn't request gpio\n");
> 
>  	tegra_gpio_enable(nvec->gpio);
> @@ -375,10 +384,9 @@ static int __devinit tegra_nvec_probe(struct
> platform_device *pdev) nvec_ps2(nvec);
>  #endif
> 
> -        /* setup subdevs */
> -	for (i = 0; i < pdata->num_subdevs; i++) {
> +	/* setup subdevs */
> +	for (i = 0; i < pdata->num_subdevs; i++)
>  		ret = nvec_add_subdev(nvec, &pdata->subdevs[i]);
> -	}
> 
>  	nvec->nvec_status_notifier.notifier_call = nvec_status_notifier;
>  	nvec_register_notifier(nvec, &nvec->nvec_status_notifier, 0);
> @@ -414,7 +422,7 @@ failed:
> 
>  static int __devexit tegra_nvec_remove(struct platform_device *pdev)
>  {
> -	// TODO: unregister
> +	/* TODO: unregister */
>  	return 0;
>  }
> 
> @@ -431,8 +439,8 @@ static int tegra_nvec_suspend(struct platform_device
> *pdev, pm_message_t state) return 0;
>  }
> 
> -static int tegra_nvec_resume(struct platform_device *pdev) {
> -
> +static int tegra_nvec_resume(struct platform_device *pdev)
> +{
>  	struct nvec_chip *nvec = platform_get_drvdata(pdev);
> 
>  	dev_dbg(nvec->dev, "resuming\n");
> @@ -446,8 +454,7 @@ static int tegra_nvec_resume(struct platform_device
> *pdev) { #define tegra_nvec_resume NULL
>  #endif
> 
> -static struct platform_driver nvec_device_driver =
> -{
> +static struct platform_driver nvec_device_driver = {
>  	.probe = tegra_nvec_probe,
>  	.remove = __devexit_p(tegra_nvec_remove),
>  	.suspend = tegra_nvec_suspend,
> diff --git a/drivers/staging/nvec/nvec.h b/drivers/staging/nvec/nvec.h
> index a2d82dc..1f77758 100644
> --- a/drivers/staging/nvec/nvec.h
> +++ b/drivers/staging/nvec/nvec.h
> @@ -16,7 +16,7 @@ typedef enum {
>  } how_care;
> 
>  typedef enum {
> -	NVEC_SYS=1,
> +	NVEC_SYS = 1,
>  	NVEC_BAT,
>  	NVEC_KBD = 5,
>  	NVEC_PS2,
> @@ -26,9 +26,9 @@ typedef enum {
>  } nvec_event;
> 
>  typedef enum {
> -       NVEC_WAIT,
> -       NVEC_READ,
> -       NVEC_WRITE
> +	NVEC_WAIT,
> +	NVEC_READ,
> +	NVEC_WRITE
>  } nvec_state;
> 
>  struct nvec_msg {
> @@ -74,7 +74,9 @@ struct nvec_chip {
>  	struct nvec_msg *last_sync_msg;
>  };
> 
> -extern void nvec_write_async(struct nvec_chip *nvec, unsigned char *data,
> short size); +extern void nvec_write_async(struct nvec_chip *nvec,
> +			     unsigned char *data,
> +			     short size);
> 
>  extern int nvec_register_notifier(struct nvec_chip *nvec,
>  		 struct notifier_block *nb, unsigned int events);
> @@ -82,7 +84,10 @@ extern int nvec_register_notifier(struct nvec_chip
> *nvec, extern int nvec_unregister_notifier(struct device *dev,
>  		struct notifier_block *nb, unsigned int events);
> 
> -const char *nvec_send_msg(unsigned char *src, unsigned char *dst_size,
> how_care care_resp, void (*rt_handler)(unsigned char *data)); +const char
> *nvec_send_msg(unsigned char *src,
> +			  unsigned char *dst_size,
> +			  how_care care_resp,
> +			  void (*rt_handler)(unsigned char *data));
> 
>  extern int nvec_ps2(struct nvec_chip *nvec);
>  extern int nvec_kbd_init(struct nvec_chip *nvec);
