Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab1CRIiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:38:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55104 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1CRIiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=sK4HUo8+8m/XJht3kQ+E9Ckqm3CEFIjSqfWMd+xcL/HF94wZFexxl46YgotIMWdp/g
         dpBm4RRwxuq4Ua0MiCXiUZGkNsSSCh5MLY18VfJsJ7/FApsK+Icyze8WEEP5+i2k5QSc
         lStufo2hQ9NjVCGlH1g+Hwop5wdtwsfVU8+dQ=
Message-ID: <4D8319ED.2060703@linaro.org>
Date: Fri, 18 Mar 2011 08:38:05 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311165642.GA9996@kroah.com> <20110317232756.GA3148@angua.secretlab.ca> <4D830E97.4010403@linaro.org> <201103180925.30074.arnd@arndb.de>
In-Reply-To: <201103180925.30074.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 08:25 AM, Somebody in the thread at some point said:
> On Friday 18 March 2011, Andy Green wrote:
>> On 03/17/2011 11:27 PM, Somebody in the thread at some point said:
>>
>>> The patch below also looks right to me.  I believe it also has the
>>> advantage of u-boot already knowing how to update the
>>> local-mac-address property at boot time.
>>
>> In my (tested, working, complete) patch series, I allow platform_data
>> based override of MAC at usbnet level, so all the drivers can benefit
>> from it.
>>
>> Is this not a case of "small thinking" from a Device Tree perspective
>> that Arnd's patch only targets smsc95xx?  Or did I miss some
>> disadvantage to allowing this functional configuration option at usbnet
>> layer?
>
> I think either way works (usb-net or individual drivers), the difference is
> which information you use when both a hardware MAC address and the
> local-mac-address property are used. Your patch uses the local-mac-address,
> mine would use the hardware mac address and only fall back to the
> property if there is no other one.
>
> I still need to look at your patch series, I didn't realize you had
> already sent it.

Yeah I sent it last Saturday.  Whether the MAC override from 
platform_data has precedence over EEPROM info is a matter of taste, in 
this set it overrides even EEPROM.  Note the smsc95xx patch crept into 
the Panda-specific set.

Platform series: http://marc.info/?l=linux-kernel&m=129996915023642&w=2
USB Host + Usbnet series: 
http://marc.info/?l=linux-kernel&m=129996966324111&w=2
Panda-specific: http://marc.info/?l=linux-kernel&m=129997032724779&w=2

-Andy
