Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab1CIWKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:10:06 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49667 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1CIWKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:10:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IxzimZJNLctH3BR11cWMLWuB5H7RqBasLaBoUFZJyk9n6A9jVIuPgLT6XsyjjDc5UA
         HzRQyPl8+UjyQC8YS1+qN3Lpvn9Sx8MQpch80LmanxGi0f4rFrYSyZ7BwFa8F8stwqYf
         2R9oAJtZVaN+0yUxSieNAzTatAcBZFoVpvSYE=
Message-ID: <4D77FAB4.4010204@gmail.com>
Date: Wed, 09 Mar 2011 14:09:56 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Ben Greear <greearb@candelatech.com>, Brian Prodoehl <bprodoehl@gmail.com>,
        Mohammed Shafi <shafi.wireless@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath9k-devel@atheros.com
Subject: Re: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536 ath_stoprecv+0xc8/0xda
 [ath9k]()
References: <AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>	<20110303135942.GA8969@tuxdriver.com>	<AANLkTi=mtaf==aLfOFK06EgmbdZ4aVk3GEthw7PwuSTS@mail.gmail.com>	<20110307151201.GC2664@tuxdriver.com>	<AANLkTi=7RSdKhzGazQFUnBZqzMQskOSHq=7E08uan2vu@mail.gmail.com>	<4D767A4B.1060203@gmail.com>	<4D76833E.9010603@candelatech.com> <AANLkTikPQt+njjFPB6sJ-mEcsx6f-R6TAOhEd8egkqhH@mail.gmail.com> <4D768A9A.7090201@candelatech.com> <4D7699BF.1000602@gmail.com> <4D76D1DB.4070404@openwrt.org>
In-Reply-To: <4D76D1DB.4070404@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 05:03 PM, Felix Fietkau wrote:
> On 2011-03-08 10:03 PM, Justin P. Mattock wrote:
>> On 03/08/2011 11:59 AM, Ben Greear wrote:
>>> On 03/08/2011 11:45 AM, Brian Prodoehl wrote:
>>>> On Tue, Mar 8, 2011 at 2:27 PM, Ben Greear<greearb@candelatech.com>
>>>> wrote:
>>>>> On 03/08/2011 10:49 AM, Justin P. Mattock wrote:
>>>>>>
>>>>>> On 03/07/2011 07:22 AM, Mohammed Shafi wrote:
>>>>>>>
>>>>>>> On Mon, Mar 7, 2011 at 8:42 PM, John W.
>>>>>>> Linville<linville@tuxdriver.com>  wrote:
>>>>>>>>
>>>>>>>> On Sun, Mar 06, 2011 at 12:47:05AM -0800, Justin Mattock wrote:
>>>>>>>>
>>>>>>>>> full dmesg here:
>>>>>>>>> http://fpaste.org/5JQp/
>>>>>>>>> let me know if I need to supply any info(also I can try a bisect,
>>>>>>>>> but
>>>>>>>>> am in the middle of changing residencies, so it might not be right
>>>>>>>>> away)
>>>>>>>>
>>>>>>>> One of the Atheros guys suggested that you change a DMA timeout
>>>>>>>> value.
>>>>>>>> Did you try that?
>>>>>>>
>>>>>>> John it looks like increasing the timeout also does not seems to help.
>>>>>>> A user reported this issue in ath9k developer list and he told that
>>>>>>> increasing the timeout did not fix this issue.
>>>>>>>
>>>>>>>>
>>>>>>>> John
>>>>>>>> --
>>>>>>>> John W. Linville Someday the world will need a hero, and you
>>>>>>>> linville@tuxdriver.com might be all we have. Be ready.
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>> linux-wireless" in
>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>> at barnes and noble, and I see this has fired off again. will see if I
>>>>>> can reproduce and bisect.
>>>>>
>>>>> This problem goes way back, and the driver has had lots of fixes in the
>>>>> last few months, so I'm not sure if bisecting is going to
>>>>> do you any good.
>>>>>
>>>>> Thanks,
>>>>> Ben
>>>>
>>>> The warnings have been around since you added the check for the
>>>> problem, right? I remember initially it was a WARN_ON, and I'd get a
>>>> steady flood of backtraces, and then it was switched to a
>>>> WARN_ON_ONCE. I see these on every platform I have (x86_64, IXP425
>>>> and AR71xx) with AR9002 and AR9003.
>>>
>>> I don't think I added the original check, but either way, it's
>>> an old problem and bisecting it is unlikely to help.
>>>
>>> I can't believe that the Atheros guys really are unable reproduce
>>> this, but I can believe that it might be very difficult to
>>> actually understand and fix.
>>>
>>> At least in my testing, I see it quite often, but it doesn't
>>> seem to cause any serious harm. We do occasionally see crashes,
>>> especially on module unload for a heavily utilized system, or
>>> one that is constantly trying and failing to associate,
>>> so it could be related to this.
>>>
>>> Also, my patches to decrease scan and work_work related channel changes
>>> made this harder to hit for our test cases.
>>>
>>> Thanks,
>>> Ben
>>>
>>
>>
>> well I would do the bisect if I can easily reproduce this, but if this
>> has been back since 2.6.2* or the initial release of ath9k then doing
>> the bisect wont work.
>>
>> as for the warning message itself, seems the system is fine after this
>> hits(just fires of on certain locations).
>>
>> Justin P. Mattock
> Please try this patch (posted to linux-wireless@) and see if it fixes
> this issue in your tests.
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index cb559e3..a9c3f46 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -413,9 +413,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
>   	 * mode interface or when in monitor mode. AP mode does not need this
>   	 * since it receives all in-BSS frames anyway.
>   	 */
> -	if (((sc->sc_ah->opmode != NL80211_IFTYPE_AP)&&
> -	     (sc->rx.rxfilter&  FIF_PROMISC_IN_BSS)) ||
> -	    (sc->sc_ah->is_monitoring))
> +	if (sc->sc_ah->is_monitoring)
>   		rfilt |= ATH9K_RX_FILTER_PROM;
>
>   	if (sc->rx.rxfilter&  FIF_CONTROL)
>
>


patch applied: here is what I am seeing:

[ 1532.142246] FIREWALL:INPUT IN=wlan0 OUT= 
MAC=01:00:5e:00:00:01:00:1e:e5:7a:64:79:08:00 SRC=192.168.180.1 
DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2
[ 1534.089408] FIREWALL:INPUT IN=wlan0 OUT= 
MAC=ff:ff:ff:ff:ff:ff:00:18:de:9c:0f:ef:08:00 SRC=192.168.180.213 
DST=192.168.180.255 LEN=229 TOS=0x00 PREC=0x00 TTL=128 ID=10897 
PROTO=UDP SPT=138 DPT=138 LEN=209
[ 1575.870714] FIREWALL:INPUT IN=wlan0 OUT= 
MAC=ff:ff:ff:ff:ff:ff:40:a6:d9:b8:58:7c:08:00 SRC=0.0.0.0 
DST=255.255.255.255 LEN=328 TOS=0x00 PREC=0x00 TTL=255 ID=64945 
PROTO=UDP SPT=68 DPT=67 LEN=308
[ 1579.323946] ath: Timeout while waiting for nf to load: 
AR_PHY_AGC_CONTROL=0x41d1a
[ 1658.504988] FIREWALL:INPUT IN=wlan0 OUT= 
MAC=01:00:5e:00:00:01:00:1e:e5:7a:64:79:08:00 SRC=192.168.180.1 
DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2
[ 1681.342000] FIREWALL:INPUT IN=wlan0 OUT= 
MAC=ff:ff:ff:ff:ff:ff:00:c0:a8:db:bd:af:08:00 SRC=192.168.180.54 
DST=192.168.180.255 LEN=240 TOS=0x00 PREC=0x00 TTL=64 ID=19778 PROTO=UDP 
SPT=138 DPT=138 LEN=220

full dmesg is here:
http://fpaste.org/jwTK/

Justin P. Mattock


