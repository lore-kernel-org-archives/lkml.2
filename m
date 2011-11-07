Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1KGJeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 04:34:12 -0500
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:60640 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1KGJeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 04:34:10 -0500
Message-ID: <4EB7A60D.801@ge.com>
Date: Mon, 07 Nov 2011 09:34:05 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: gregkh@suse.de, Grant Likely <grant.likely@secretlab.ca>,
        devel@driverdev.osuosl.org, manohar.vanga@cern.ch, cota@braap.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Driver for GE PIO2 VME Card
References: <20111104173126.30940.28135.stgit@ES-BJ21R4J> <1320436514.14409.309.camel@x61.thuisdomein>
In-Reply-To: <1320436514.14409.309.camel@x61.thuisdomein>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Nov 2011 09:34:07.0889 (UTC) FILETIME=[65CDF810:01CC9D30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/11 19:55, Paul Bolle wrote:
> A few random remarks follow. Ie, things that came up while quickly
> scanning this.
> 
> On Fri, 2011-11-04 at 17:33 +0000, Martyn Welch wrote:
>> diff --git a/drivers/staging/vme/devices/Kconfig b/drivers/staging/vme/devices/Kconfig
>> index ca5ba89..99f5414 100644
>> --- a/drivers/staging/vme/devices/Kconfig
>> +++ b/drivers/staging/vme/devices/Kconfig
>> @@ -6,3 +6,13 @@ config VME_USER
>>  	  If you say Y here you want to be able to access a limited number of
>>  	  VME windows in a manner at least semi-compatible with the interface
>>  	  provided with the original driver at http://vmelinux.org/.
> 
> Blank line here.
> 

ok

>> +config VME_PIO2
>> +	tristate "GE PIO2 VME"
>> +	help
>> +	  If you say Y here you have a GE PIO2. The PIO2 is a 6U VME Card,
> 
> Maybe something like: "Say Y here if you have a GE PIO2."?
> 

Yup, thats better :-)

>> +	  implementing 32 solid-state relay switched IO lines, in 4 groups of 8.
>> +	  The IO lines are provided as input, output or both as a build time
>> +	  option.
> 
> What option would that be?
> 

I think "Each bank of IO lines is pre-configured as input, output or both
depending on the variant of the card" may be a bit clearer?

>> +	  Otherwise it is safe to say N here.
>> +
> 
> A lot of modules have the "if you say M here the module will be called"
> boilerplate here (which actually doesn't match the line I just made up).
> 

ok

>> +/* These are required for each board */
>> +MODULE_PARM_DESC(bus, "Enumeration of VMEbus to which the board is connected");
>> +module_param_array(bus, int, &bus_num, 0);
>> +
>> +MODULE_PARM_DESC(base, "Base VME address for PIO2 Registers");
>> +module_param_array(base, long, &base_num, 0);
>> +
>> +MODULE_PARM_DESC(vector, "VME IRQ Vector (Lower 4 bits masked)");
>> +module_param_array(vector, int, &vector_num, 0);
>> +
>> +MODULE_PARM_DESC(level, "VME IRQ Level");
>> +module_param_array(level, int, &level_num, 0);
>> +
>> +MODULE_PARM_DESC(variant, "Last 4 characters of PIO2 board variant");
>> +module_param_array(variant, charp, &variant_num, 0);
>> +
>> +/* This is for debugging */
>> +MODULE_PARM_DESC(loopback, "Enable loopback mode on all cards");
>> +module_param(loopback, bool, 0);
> 
> All module parameters have a sysfs visibility (or permission) of zero.
> Why is that? (This might very well be a naive question. But I often
> wonder why a certain parameter's permission isn't at least 400, just to
> allow a quick check of that parameter.) Are arrays tricky in sysfs?
> 

Hadn't really thought about it to be honest. There seems to be plenty of
examples where it's set to non-zero.

Martyn

> I can't remember ever having seen guidelines for this. It's possible
> they exist and my question is answered after reading those.
> 
> 
> Paul Bolle
> 


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)1327322748                         | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
