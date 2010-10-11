Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0JKNbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:31:08 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:37463 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab0JKNbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:31:06 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CB312EE.4040708@cam.ac.uk>
Date: Mon, 11 Oct 2010 14:36:46 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100928 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: samu.p.onkalo@nokia.com
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv2 2/5] misc: update bhsfh driver to Kconfig and Makefile
References: <1286545324-18506-1-git-send-email-samu.p.onkalo@nokia.com>	 <1286545324-18506-3-git-send-email-samu.p.onkalo@nokia.com>	 <4CAF29F4.9010709@cam.ac.uk> <1286777860.28027.5.camel@4fid08082>
In-Reply-To: <1286777860.28027.5.camel@4fid08082>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/10 07:17, Onkalo Samu wrote:
> On Fri, 2010-10-08 at 16:25 +0200, ext Jonathan Cameron wrote:
>> On 10/08/10 14:42, Samu Onkalo wrote:
>>> Compilation support for bhsfh driver
>>>
>>> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
>>> ---
>>>  drivers/misc/Kconfig  |   10 ++++++++++
>>>  drivers/misc/Makefile |    1 +
>>>  2 files changed, 11 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
>>> index b743312..f2e8065 100644
>>> --- a/drivers/misc/Kconfig
>>> +++ b/drivers/misc/Kconfig
>>> @@ -314,6 +314,16 @@ config SENSORS_BH1780
>>>  	  This driver can also be built as a module.  If so, the module
>>>  	  will be called bh1780gli.
>>>  
>>> +config SENSORS_BHSFH
>>> +         tristate "BH1770GLC / SFH7770 combined ALS / Proximity sensor";
>>> +         depends on I2C
>>> +         ---help---
>>> +           Say Y here if you want to build a driver for BH1770GLC / SFH7770
>>> +           combined ambient light and proximity sensor chip
>>> +
>>> +           To compile this driver as a module, choose M here: the
>>> +           module will be called bhsfh. If unsure, say N here.
>>> +
>> Really not keen on the naming.  The above comment made me think this was
>> a single chip integrating both of the parts.  Reading the code makes it clear
>> that they just share an interface.  So please name it after one of them.
>> Lots of reasons not to invent combined names like this.
>> * non obvious thing to grep for.
>> * 3rd part comes along with a different name. Do you change the driver name?
>>
>> So best bet is always just to pick a supported part and name the driver after
>> that.  The device table stuff and clear descriptions in kconfig will make
>> it obvious what the part supports.
> 
> ok, bhsfh.* > bh1770glc.*
> What do you think, is it ok to still keep BHSFH in definitions and in
> function names?

I'd say it's fine to leave function names alone.  If anyone else cares, they can
post a patch changing the lot.

Jonathan
> 
> 
> 
>>>  config HMC6352
>>>  	tristate "Honeywell HMC6352 compass"
>>>  	depends on I2C
>>> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
>>> index 42eab95..fd5a4b7 100644
>>> --- a/drivers/misc/Makefile
>>> +++ b/drivers/misc/Makefile
>>> @@ -16,6 +16,7 @@ obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
>>>  obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
>>>  obj-$(CONFIG_PHANTOM)		+= phantom.o
>>>  obj-$(CONFIG_SENSORS_BH1780)	+= bh1780gli.o
>>> +obj-$(CONFIG_SENSORS_BHSFH)	+= bhsfh.o
>>>  obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
>>>  obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
>>>  obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
>>
> 
> 

