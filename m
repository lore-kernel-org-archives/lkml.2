Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1FWFQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 01:16:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51899 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1FWFQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 01:16:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Hc7pxnrfSSMH8Mzuiz2jOSDwzN/gIzo52gWnrEk7exW2Xg/p/x9egJWBCzI/Yaahd0
         TUoC3quCnkcmlM4/GiMJNoiT3eIkUxoL1TaJomPsTUK1mG7VHtYgnCFvaLm5u+a5jmnW
         VUpVHzK4zOmbcWjklsgRy3svi9IPUFDmn8krk=
Message-ID: <4E02CC1B.2070403@gmail.com>
Date: Wed, 22 Jun 2011 22:16:11 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: "glikely@secretlab.ca" <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 01/11] spi-dw: expose platform data stucture.
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com> <1308794413-11069-2-git-send-email-dirk.brandewie@gmail.com> <BANLkTin9Ouf76VEFRam+eo=H7Gw3Tv6OLA@mail.gmail.com> <4E02BA68.2010108@gmail.com> <127d80e7-0bb6-4961-891e-2ab791ac6368@email.android.com> <4E02C30A.5040106@gmail.com> <8a51d0af-e018-40d4-8aa6-8c42caa5cccf@email.android.com>
In-Reply-To: <8a51d0af-e018-40d4-8aa6-8c42caa5cccf@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 10:06 PM, glikely@secretlab.ca wrote:
>
>
> Dirk Brandewie<dirk.brandewie@gmail.com>  wrote:
>
>> On 06/22/2011 09:03 PM, glikely@secretlab.ca wrote:
>>>
>>>
>>> Dirk Brandewie<dirk.brandewie@gmail.com>   wrote:
>>>
>>>> On 06/22/2011 08:47 PM, Grant Likely wrote:
>>>>> On Wed, Jun 22, 2011 at 8:00 PM,<dirk.brandewie@gmail.com>    wrote:
>>>>>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>>>>>>
>>>>>> Expose the platform data structure for use by client drivers. ATM
>>>>>> there are not any in-tree drivers using the driver (that I can
>>>>>> find). This patch exposes the platform data needed for client
>>>> drivers.
>>>>>
>>>>> ?  Why would client drivers want to muck with this configuration?
>> I
>>>>> can understand the dw_spi driver being able to have per-spi_device
>>>>> configuration, but spi_drivers absolutely should not have
>> visibility
>>>>> into bus-specific details.  Am I misunderstanding something.
>>>>>
>>>>
>>>> Most of these config options don't need to be client configurable
>> IMHO
>>>> but they
>>>> are being used ATM by drivers that aren't upstream and the current
>>>> controller
>>>> driver uses them.  This patch is to give a smooth transition
>>>> (bisectable) to my
>>>> change that reworks the core message and transfer handling code.
>>>>
>>>> This allows me to provide patches to the developers of the out of
>> tree
>>>> drivers
>>>> that should be coming in RSN and exposes the interface they are
>> using
>>>> now.
>>>
>>> My question still stands. Are you expecting spi_driver code to
>> manipulate this data?
>>>
>>>
>>
>> The current drivers behaviour is driven by this data provided by the
>> client.
>> This makes the current client drivers work since some have not picked
>> picked up
>> your change moving dw_spi.h out of include/linux/spi (right answer
>> IMHO) and
>> provides the interface they are using now.
>
> So the situation is that certain out-of-tree spi_drivers are reaching into internal details of a specific spi bus driver?
>If so, then that is wrong and bad, and certainly will not be merged. Especially when there are no in tree users and neither
>does this series add any.

OK

Since the current driver used pxa2xx_spi.c as a template I was following the 
example provided by include/linux/spi/pxa2xx_spi.h.  I have no problem dropping 
this patch until I finish the rest of the rework planned. Was trying to limit 
the amount of heartburn others on the list had with my changes.

--Dirk
>
> g.
>
>>
>> --Dirk
>

