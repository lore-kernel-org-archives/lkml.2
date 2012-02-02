Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2BBNBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:01:18 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:44943 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823Ab2BBNBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:01:14 -0500
Message-ID: <4F2A8912.4070701@ti.com>
Date: Thu, 02 Feb 2012 15:01:06 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20120106 Thunderbird/9.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 2/7] MFD: twl6040: Convert to i2c driver, and separate it
 from twl core
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com> <1328185019-29575-3-git-send-email-peter.ujfalusi@ti.com> <20120202124828.GI7428@opensource.wolfsonmicro.com>
In-Reply-To: <20120202124828.GI7428@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 02:48 PM, Mark Brown wrote:
> On Thu, Feb 02, 2012 at 02:16:54PM +0200, Peter Ujfalusi wrote:
> 
>> +static int twl6040_i2c_read(struct i2c_client *i2c, u8 *value, u8 reg)
>> +{
>> +	struct i2c_msg msg[2];
>> +	int ret;
> 
> May as well convert to regmap while you're at it, saves some code and
> will get you access to the regmap features - you have to make updates in
> all the relevant places anyway.  We should be pushing to remove use of
> the ASoC level code for register cache and whatnot to cut down on code
> duplication (especially for MFDs where it has a few issues interacting
> with the MFD) and this seems like a good opportunity.

True.
I have done the bulk of this set back in June, 2011 and thought that I
will do the move to regmap as increment, but you are right. I'm anyway
touching the relevant places, so why not do it properly?
I'll take the regmap into use for  v2.

> The calling convention here seems a bit weird too, you've got value then
> register but normally we have register then value for I2C/SPI devices.

I have based these part on the twl-core's implementation. I should not
have done that, I know.. Let's see how it will look like with regmap.

> Except when we don't :(
> 
>> -module_platform_driver(twl6040_driver);
>> +static int __devinit twl6040_init(void)
>> +{
>> +	return i2c_add_driver(&twl6040_driver);
>> +}
>> +module_init(twl6040_init);
>> +
>> +static void __devexit twl6040_exit(void)
>> +{
>> +	i2c_del_driver(&twl6040_driver);
>> +}
>> +
>> +module_exit(twl6040_exit);
> 
> There's module_i2c_driver() in mainline as of the last merge window.

Oh, good to know. Thanks

-- 
Péter
