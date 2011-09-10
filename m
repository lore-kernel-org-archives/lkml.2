Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab1IJCPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 22:15:51 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44231 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab1IJCPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 22:15:50 -0400
Message-ID: <4E6AC853.9010307@vflare.org>
Date: Fri, 09 Sep 2011 22:15:47 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] zram: Kernel config option for number of devices
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org> <1315609264-13632-3-git-send-email-ngupta@vflare.org> <20110909230925.GA23699@kroah.com>
In-Reply-To: <20110909230925.GA23699@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2011 07:09 PM, Greg KH wrote:

> On Fri, Sep 09, 2011 at 07:01:01PM -0400, Nitin Gupta wrote:
>> Allows configuring default number of zram devices
>> as kernel config option. User can override this
>> value using 'num_devices' module parameter.
> 
> Ick, another config value, is this really needed?  Why can't we rely on
> the module parameter instead?
> 
> 


It is just an added convenience for users that tend to always use more
than one device. So, a distribution may set it to say 4 and users won't
have to go through any documentation just to create an additional zram
device.

This also makes its behavior similar to the usual ramdisk which also
accepts default number of ramdisks (BLK_DEV_RAM_COUNT) as kconfig option.

>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>> ---
>>  drivers/staging/zram/Kconfig    |    9 +++++++++
>>  drivers/staging/zram/zram_drv.c |   13 ++++++++-----
>>  2 files changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
>> index 3bec4db..ca31cb3 100644
>> --- a/drivers/staging/zram/Kconfig
>> +++ b/drivers/staging/zram/Kconfig
>> @@ -21,6 +21,15 @@ config ZRAM
>>  	  See zram.txt for more information.
>>  	  Project home: http://compcache.googlecode.com/
>>  
>> +config ZRAM_NUM_DEVICES
>> +	int "Default number of zram devices"
>> +	depends on ZRAM
>> +	range 1 32
>> +	default 1
>> +	help
>> +	  Select default number of zram devices. You can override this value
>> +	  using 'num_devices' module parameter.
>> +
>>  config ZRAM_DEBUG
>>  	bool "Compressed RAM block device debug support"
>>  	depends on ZRAM
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index 03ec5a2..55f2c0e 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -781,6 +781,14 @@ static int __init zram_init(void)
>>  {
>>  	int ret, dev_id;
>>  
>> +	/*
>> +	 * Module parameter not specified by user. Use default
>> +	 * value as defined during kernel config.
>> +	 */
>> +	if (num_devices == 0) {
>> +		num_devices = CONFIG_ZRAM_NUM_DEVICES;
>> +	}
> 
> Wrong coding style, which, for some odd reason, checkpatch doesn't
> catch.  Please remove the braces.
> 


Ok, will correct this.

Thanks,
Nitin
