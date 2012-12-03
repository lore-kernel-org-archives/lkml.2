Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2LCG0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 01:26:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43993 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab2LCG0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 01:26:37 -0500
X-IronPort-AV: E=Sophos;i="4.83,361,1352044800"; 
   d="scan'208";a="6319905"
Message-ID: <50BC45CA.20504@cn.fujitsu.com>
Date: Mon, 03 Dec 2012 14:25:14 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Jeong <gshark.jeong@gmail.com>
CC: Liam Gridwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Daniel Jeong <daniel.jeong@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] regulator: new driver for LP8755
References: <1354509864-30001-1-git-send-email-gshark.jeong@gmail.com> <1354509864-30001-2-git-send-email-gshark.jeong@gmail.com>
In-Reply-To: <1354509864-30001-2-git-send-email-gshark.jeong@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/03 14:26:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/03 14:26:01,
	Serialize complete at 2012/12/03 14:26:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<...>
> +
> +static int __devinit lp8755_regulator_init(struct lp8755_chip *pchip)

CONFIG_HOTPLUG is going away; it's already defined to always be 'Y'.
So, please don't use __devinit anymore.
refer to : http://marc.info/?l=linux-i2c&m=135341812915168&w=2

> +{
> +	int ret, icnt, buck_num;
> +	struct lp8755_platform_data *pdata = pchip->pdata;
> +
> +	struct regulator_config rconfig = { };
> +
> +	rconfig.regmap = pchip->regmap;
> +	rconfig.dev = pchip->dev;
> +	rconfig.driver_data = pchip;
<..>
> +}
> +
> +static int __devinit lp8755_int_config(struct lp8755_chip *pchip)

Ditto.

> +{
> +	int ret;
> +	unsigned int regval;
> +
> +	if (pchip->irq == 0) {
> +		dev_warn(pchip->dev, "not use interrupt : %s\n", __func__);
> +		return 0;
> +	}
> +
> +	ret = lp8755_read(pchip, 0x0F, &regval);

> +}
> +
> +static int __devinit lp8755_probe(struct i2c_client *client,

Ditto.

> +				  const struct i2c_device_id *id)
> +{
> +	int ret, icnt;
> +	struct lp8755_chip *pchip;
> +	struct lp8755_platform_data *pdata = client->dev.platform_data;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(&client->dev, "i2c functionality check fail.\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (pdata == NULL) {
> +		dev_err(&client->dev, "platform data is NULL.\n");
> +		return -ENOMEM;

> +
> +	return ret;
> +}
> +
> +static int __devexit lp8755_remove(struct i2c_client *client)

Ditto.


> +{
> +	int icnt;
> +	struct lp8755_chip *pchip = i2c_get_clientdata(client);
> +
> +	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++)
<..>
> +static struct i2c_driver lp8755_i2c_driver = {
> +	.driver = {
> +		   .name = LP8755_NAME,
> +		   },
> +	.probe = lp8755_probe,
> +	.remove = __devexit_p(lp8755_remove),

Ditto. remove __devexit_p.


Thanks,
Wanlong Gao

