Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab2H1XKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 19:10:21 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2086 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab2H1XKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 19:10:19 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <503D4FCF.7030109@broadcom.com>
Date: Tue, 28 Aug 2012 16:10:07 -0700
From: "Franky Lin" <frankyl@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-Version: 1.0
To: "Stephen Warren" <swarren@wwwdotorg.org>
cc: "Wei Ni" <wni@nvidia.com>, "Arend van Spriel" <arend@broadcom.com>,
        "rvossen@broadcom.com" <rvossen@broadcom.com>,
        "Rakesh Kumar" <krakesh@nvidia.com>,
        "Laxman Dewangan" <ldewangan@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH 2/6] brcmfmac: Handling the interrupt in ISR
 directly for non-OOB
References: <1346063114-30361-1-git-send-email-wni@nvidia.com>
 <1346063114-30361-3-git-send-email-wni@nvidia.com>
 <503B9F31.5050502@broadcom.com> <503BD345.6030501@wwwdotorg.org>
 <1346152413.3516.211.camel@tegra-chromium-2>
 <503CF5B3.8040201@broadcom.com> <503D48AC.5040509@wwwdotorg.org>
 <503D4DD9.2060808@broadcom.com> <503D4E7F.9010205@wwwdotorg.org>
In-Reply-To: <503D4E7F.9010205@wwwdotorg.org>
X-WSS-ID: 7C2390D349824568259-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 04:04 PM, Stephen Warren wrote:
> On 08/28/2012 04:01 PM, Franky Lin wrote:
>> On 08/28/2012 03:39 PM, Stephen Warren wrote:
>>> On 08/28/2012 09:45 AM, Franky Lin wrote:
>>>> On 08/28/2012 04:13 AM, Wei Ni wrote:
>>>>> On Tue, 2012-08-28 at 04:06 +0800, Stephen Warren wrote:
>>>>>> On 08/27/2012 09:24 AM, Arend van Spriel wrote:
>>>>>>> On 08/27/2012 12:25 PM, Wei Ni wrote:
>>>>>>>> In case of inband interrupts, if we handle the interrupt in dpc
>>>>>>>> thread,
>>>>>>>> two level of thread switching takes place to process wifi
>>>>>>>> interrupts.
>>>>>>>> One in SDHCI driver and the other in Wifi driver. This may cause the
>>>>>>>> system
>>>>>>>> instability.
>>> ...
>>>>>>> Not sure if I can follow this explanation. The isr is called with
>>>>>>> host
>>>>>>> claimed (by sdio_irq_thread) and all it does is at a linked list
>>>>>>> member
>>>>>>> and signal the dpc thread. After doing this the host is released.
>>>>>>
>>>>>> Is the issue something like the ISR handler or first level of
>>>>>> threading
>>>>>> does:
>>>>>>
>>>>>> * Trigger DPC
>>>>>> * Re-enable interrupt
>>>>>>
>>>>>> So that the interrupt then fires again before the triggered DPC can
>>>>>> run
>>>>>> to handle/clear it, thus causing an interrupt storm?
>>>>>>
>>>>>> Whereas handling the interrupt directly prevents this race condition?
>>>>>
>>>>> Above is my understanding.
>>>>
>>>> I understand the issue here and totally agree that we should treat
>>>> in-band and out-band interrupts differently. But my concern is that the
>>>> behavior of releasing the host before calling brcmf_sdbrcm_isr and grab
>>>> it after is likely error prone. Also we are restructuring the dpc
>>>> routine internally and it's almost done. I will find a better solution
>>>> for in-band interrupt and get it the queue as well. So I suggest
>>>> dropping this patch.
>>>
>>> Franky, do you know which kernel release the DPC restructuring will make
>>> it into? I ask because I can't apply the rest of the patches in this
>>> series without first resolving the stability issues with the Broadcom
>>> WiFi enabled, since that'd de-stabilize the Tegra platform
>>> significantly, and I'd like to plan when we can apply these patches to
>>> Tegra. Thanks!
>>>
>>
>> Hi Stephen,
>>
>> Since we submit patches through linux-wireless tree, you may only be
>> able to pick it up at 3.7-rc1. It's quite a big change so I don't think
>> it will qualify as a bug fix to get into 3.6-rcX.
>
> That's as quick as I expected it to show up, so that's great. I don't
> suppose you could mail Wei and myself once the patch gets into the
> linux-wireless tree, so we can test it out on Tegra. If the patch could
> possibly go into a topic branch in the wireless tree so it can be merged
> into the Tegra tree before this series, that would be awesome. Thanks.
>

Will keep you posted.

Franky

