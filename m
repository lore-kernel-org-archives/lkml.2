Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab2JUT3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 15:29:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37902 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab2JUT3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 15:29:09 -0400
Message-ID: <50844D01.9090805@gmail.com>
Date: Sun, 21 Oct 2012 21:29:05 +0200
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko@ursulin.net>
CC: dm-crypt@saout.de, linux-kernel@vger.kernel.org
Subject: Re: cryptsetup not working under 3.6 - regression from 3.4?
References: <50830D33.5050807@ursulin.net> <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com> <5083EC61.8070505@ursulin.net>
In-Reply-To: <5083EC61.8070505@ursulin.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2012 02:36 PM, Tvrtko Ursulin wrote:
> On 21/10/12 13:20, Zdenek Kaspar wrote:
>>>> I would say you are still missing some modules.
>>>>
>>>>> Kernel says this:
>>>>>     device-mapper: table: 252:1: crypt: Error allocating crypto tfm
>>>>>     device-mapper: ioctl: error adding target to table
>>>>
>>>> It complains about aes-cbc-essiv:sha256.
>>>>
>>>> It can be missing CBC od SHA256, but according the message I bet
>>>> you have no "cbc" block cipher mode module compiled.
>>>>
>>>> Can you grep your final .config for CONFIG_CRYPTO_CBC and
>>>> CONFIG_CRYPTO_SHA256 a paste it here?
>>>
>>> I both working 3.4 and non-working 3.6 situation is the same:
>>>
>>> CONFIG_CRYPTO_CBC=y
>>> CONFIG_CRYPTO_SHA256=m
>>
>> Compare please:
>> grep CONFIG_CRYPTO /boot/config-3.4
>> grep CONFIG_CRYPTO /boot/config-3.6
>>
>> One of the problem could be that your configuration misses something
>> like: CONFIG_CRYPTO_BLKCIPHER, CONFIG_CRYPTO_MANAGER, etc.. or some of
>> those could changed into modules and are not getting loaded..
> 
> Here it is:

Hm, so it should work without problem. Can you paste full output of failing
cryptsetup command (with added --debug switch) and your full kernel .config?

Cryptsetup itself has regression tests which test almost all common
combinations of ciphers so the problem is almost surely in some kernel
part misconfiguration. 
Any other related messages in syslog beside two lines you posted?

Thanks,
Milan
