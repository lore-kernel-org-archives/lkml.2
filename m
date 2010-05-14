Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0ENCOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:14:17 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43432 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0ENCOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:14:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ina/9tXgulWbtwcpJnsadvfIrrp6ZYzSKa6ikZpkbYr4x48oAApsVQrC8IgovD4mSN
         luml1ZrTwm+ojJ+hYXJNEHdFek4QscEiOx1r4KUnYXRfwGbHOJx954yfraA4nlCkrGhD
         fjvwvr48MnSxjsHIqIvyMuRzvhVWOaSYv7kiY=
Message-ID: <4BECB1F2.5050900@gmail.com>
Date: Thu, 13 May 2010 19:14:10 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Bruno Randolf <br1@einfach.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
References: <4BEC7A84.3010503@gmail.com> <AANLkTinKoMxdkPYQA_AblpByL6zAiAP5hv2M3Jn2R3hM@mail.gmail.com> <4BEC9E6B.30809@gmail.com> <201005141008.20667.br1@einfach.org> <4BECA3AE.4070607@gmail.com> <20100514012314.GA2170@tux> <4BECA6AC.9060609@gmail.com> <20100514014311.GC2170@tux> <20100514014553.GD2170@tux>
In-Reply-To: <20100514014553.GD2170@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/10 18:45, Luis R. Rodriguez wrote:
> On Thu, May 13, 2010 at 06:43:11PM -0700, Luis Rodriguez wrote:
>> On Thu, May 13, 2010 at 06:26:04PM -0700, Justin P. Mattock wrote:
>>> On 05/13/10 18:23, Luis R. Rodriguez wrote:
>>>> On Thu, May 13, 2010 at 06:13:18PM -0700, Justin P. Mattock wrote:
>>>>> On 05/13/10 18:08, Bruno Randolf wrote:
>>>>>> On Friday 14 May 2010 09:50:51 Justin P. Mattock wrote:
>>>>>>> On 05/13/10 17:28, Luis R. Rodriguez wrote:
>>>>>>>> On Thu, May 13, 2010 at 5:21 PM, Justin P. Mattock
>>>>>>>>
>>>>>>>> <justinmattock@gmail.com>     wrote:
>>>>>>>>> On 05/13/10 16:01, Luis R. Rodriguez wrote:
>>>>>>>>>> On Thu, May 13, 2010 at 3:17 PM, Justin P. Mattock
>>>>>>>>>>
>>>>>>>>>> <justinmattock@gmail.com>       wrote:
>>>>>>>>>>> not sure what this is, but while at a convention
>>>>>>>>>>> I was trying to access the internet and(below is
>>>>>>>>>>> full dmesg) this showed up.
>>>>>>>>>>>
>>>>>>>>>>> After receiving this, I sat and tried to re-create
>>>>>>>>>>> my steps to reproduce but had no luck(was even going
>>>>>>>>>>> todo a bisect n the spot if I could re-create).
>>>>>>>>>>
>>>>>>>>>> OK this stuff is hard to reproduce it seems.. you have an Atheros
>>>>>>>>>> AR5418 MAC/BB Rev:2 AR5133 RF Rev:81, what kconfig option do you use
>>>>>>>>>> to get the poison stuff? I am just surprised we haven't seen it
>>>>>>>>>> ourselves yet. Let me make sure all of us get this kconfig option
>>>>>>>>>> enabled.
>>>>>>>>>>
>>>>>>>>>>       Luis
>>>>>>>>>
>>>>>>>>> CONFIG_ATH_COMMON=m
>>>>>>>>> # CONFIG_ATH_DEBUG is not set
>>>>>>>>> CONFIG_ATH5K=m
>>>>>>>>> # CONFIG_ATH5K_DEBUG is not set
>>>>>>>>> CONFIG_ATH9K_HW=m
>>>>>>>>> CONFIG_ATH9K_COMMON=m
>>>>>>>>> CONFIG_ATH9K=m
>>>>>>>>> # CONFIG_ATH9K_DEBUGFS is not set
>>>>>>>>>
>>>>>>>>> if you need my .config let me know.
>>>>>>>>> (I can try again reproducing, but man
>>>>>>>>> just doesn't easily fire off).
>>>>>>>>
>>>>>>>> Oh I mean the config options to enable the poison rant.
>>>>>>>>
>>>>>>>>       Luis
>>>>>>>
>>>>>>> shoot.. not sure how to grep for the right info
>>>>>>> in the .config for you, heres what grepping for COFIG_DEBUG
>>>>>>> looks like:
>>>>>>> CONFIG_DEBUG_FS=y
>>>>>>> CONFIG_DEBUG_KERNEL=y
>>>>>>> CONFIG_DEBUG_RT_MUTEXES=y
>>>>>>> CONFIG_DEBUG_PI_LIST=y
>>>>>>> CONFIG_DEBUG_SPINLOCK=y
>>>>>>> CONFIG_DEBUG_MUTEXES=y
>>>>>>> CONFIG_DEBUG_BUGVERBOSE=y
>>>>>>> CONFIG_DEBUG_MEMORY_INIT=y
>>>>>>> CONFIG_DEBUG_STACKOVERFLOW=y
>>>>>>
>>>>>> oh, this reminds me of a similar report we had for ath5k:
>>>>>>
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=15861
>>>>>>
>>>>>> the subject on this mailing list was "ath5k misbehaving affecting other kernel
>>>>>> parts unrelated?"
>>>>>>
>>>>>> bruno
>>>>>>
>>>>>
>>>>> Could be.. From what I remember
>>>>> all I was doing was switching from
>>>>> one wireless network to another
>>>>> (then opening firefox to sign my life away).
>>>>
>>>> Were you using network-manager? Or the supplicant manually?
>>>>
>>>>     Luis
>>>>
>>>
>>> I've got wicd(1.5.9) manager
>>> running over here.
>>
>> Can you try this:
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
>> index 8c79548..a372f2c 100644
>> --- a/drivers/net/wireless/ath/ath9k/init.c
>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>> @@ -599,6 +599,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
>>   	 */
>>   	ath_read_cachesize(common,&csz);
>>   	common->cachelsz = csz<<  2; /* convert to bytes */
>> +	printk("ATH9K: cachelsz: %d\n", common->cachelsz);
>>
>>   	/* Initializes the hardware for all supported chipsets */
>>   	ret = ath9k_hw_init(ah);
>>
>>
>> Would like to see what you get there on dmesg upon load.
>
> Actually don't bother I just realized you can get this with
> ATH_DBG_CONFIG enabled.
>
>                  ath_print(common, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
>                                  common->cachelsz, common->rx_bufsize);
>
>
> This is already in the code so just
>
> modprobe ath9k debug=0x00000200
>
>    Luis
>


what I can try, is(not at the convention, on eth0
at the moment), but when I get back to the convention
center place I can try your patch as well as the
modprobe option, to see if I can get any signs of
a recreation(if so I'll bisect there).

Justin P. Mattock
