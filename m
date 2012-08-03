Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2HCViQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 17:38:16 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:36932 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753107Ab2HCViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 17:38:14 -0400
Message-ID: <501C4479.4030306@xenotime.net>
Date: Fri, 03 Aug 2012 14:36:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Studebaker <mdsxyz123@yahoo.com>, linux-i2c@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 3 (drivers/i2c/busses/i2c-i801.c)
References: <20120803135110.0ba0e51758021b6a4ed9d1e9@canb.auug.org.au>	<501C0952.5050609@xenotime.net> <20120803215717.31376eb7@endymion.delvare>
In-Reply-To: <20120803215717.31376eb7@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 12:57 PM, Jean Delvare wrote:

> Hi Randy,
> 
> On Fri, 03 Aug 2012 10:24:34 -0700, Randy Dunlap wrote:
>> on x86_64:
>>
>> when CONFIG_GPIOLIB is not enabled:
>>
>> drivers/i2c/busses/i2c-i801.c: In function 'match_gpio_chip_by_label':
>> drivers/i2c/busses/i2c-i801.c:1011:21: error: dereferencing pointer to incomplete type
>> drivers/i2c/busses/i2c-i801.c: In function 'i801_add_mux':
>> drivers/i2c/busses/i2c-i801.c:1028:2: error: implicit declaration of function 'gpiochip_find'
>> drivers/i2c/busses/i2c-i801.c:1028:7: warning: assignment makes pointer from integer without a cast
>> drivers/i2c/busses/i2c-i801.c:1047:27: error: dereferencing pointer to incomplete type
>> drivers/i2c/busses/i2c-i801.c: In function 'match_gpio_chip_by_label':
>> drivers/i2c/busses/i2c-i801.c:1012:1: warning: control reaches end of non-void function
> 
> Good catch, thanks for reporting. I'll fold the following in the
> offending patch, that should fix it:

Ack, it does.
Thanks.

> --- linux-3.6-rc0.orig/drivers/i2c/busses/Kconfig	2012-08-03 21:51:51.000000000 +0200
> +++ linux-3.6-rc0/drivers/i2c/busses/Kconfig	2012-08-03 21:52:18.090537018 +0200
> @@ -80,6 +80,7 @@ config I2C_I801
>  	tristate "Intel 82801 (ICH/PCH)"
>  	depends on PCI
>  	select CHECK_SIGNATURE if X86 && DMI
> +	select GPIOLIB if I2C_MUX
>  	help
>  	  If you say yes to this option, support will be included for the Intel
>  	  801 family of mainboard I2C interfaces.  Specifically, the following
> 
> 



-- 
~Randy
