Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2J2TbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:31:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46824 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab2J2TbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:31:24 -0400
Message-ID: <508ED985.5060301@ursulin.net>
Date: Mon, 29 Oct 2012 19:31:17 +0000
From: Tvrtko Ursulin <tvrtko@ursulin.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121017 Thunderbird/16.0.1
MIME-Version: 1.0
To: Milan Broz <gmazyland@gmail.com>
CC: dm-crypt@saout.de, linux-kernel@vger.kernel.org
Subject: Re: cryptsetup not working under 3.6 - regression from 3.4?
References: <50830D33.5050807@ursulin.net> <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com> <5083EC61.8070505@ursulin.net> <50844D01.9090805@gmail.com> <5084551E.5040304@ursulin.net>
In-Reply-To: <5084551E.5040304@ursulin.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 21/10/12 21:03, Tvrtko Ursulin wrote:
> On 21/10/12 20:29, Milan Broz wrote:
>> On 10/21/2012 02:36 PM, Tvrtko Ursulin wrote:
>>> On 21/10/12 13:20, Zdenek Kaspar wrote:
>>>>>> I would say you are still missing some modules.
>>>>>>
>>>>>>> Kernel says this:
>>>>>>>      device-mapper: table: 252:1: crypt: Error allocating crypto tfm
>>>>>>>      device-mapper: ioctl: error adding target to table
>>>>>>
>>>>>> It complains about aes-cbc-essiv:sha256.
>>>>>>
>>>>>> It can be missing CBC od SHA256, but according the message I bet
>>>>>> you have no "cbc" block cipher mode module compiled.
>>>>>>
>>>>>> Can you grep your final .config for CONFIG_CRYPTO_CBC and
>>>>>> CONFIG_CRYPTO_SHA256 a paste it here?
>>>>>
>>>>> I both working 3.4 and non-working 3.6 situation is the same:
>>>>>
>>>>> CONFIG_CRYPTO_CBC=y
>>>>> CONFIG_CRYPTO_SHA256=m
>>>>
>>>> Compare please:
>>>> grep CONFIG_CRYPTO /boot/config-3.4
>>>> grep CONFIG_CRYPTO /boot/config-3.6
>>>>
>>>> One of the problem could be that your configuration misses something
>>>> like: CONFIG_CRYPTO_BLKCIPHER, CONFIG_CRYPTO_MANAGER, etc.. or some of
>>>> those could changed into modules and are not getting loaded..
>>>
>>> Here it is:
>>
>> Hm, so it should work without problem. Can you paste full output of
>> failing
>> cryptsetup command (with added --debug switch) and your full kernel
>> .config?
>
> Attached.
>
>> Cryptsetup itself has regression tests which test almost all common
>> combinations of ciphers so the problem is almost surely in some kernel
>> part misconfiguration.
>> Any other related messages in syslog beside two lines you posted?
>
> No just those two.

Just tried 3.6.4 and it is still broken. Is there anything else I could 
try to debug this?

Thanks,

Tvrtko

