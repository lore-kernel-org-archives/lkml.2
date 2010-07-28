Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab0G1Hjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:39:42 -0400
Received: from mx02.infracom.it ([62.196.48.10]:43661 "EHLO mx02.infracom.it"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751407Ab0G1Hjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:39:39 -0400
Message-ID: <4C4FDEB8.2000502@gmail.com>
Date: Wed, 28 Jul 2010 09:39:36 +0200
From: Roberto Oppedisano <roberto.oppedisano@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100710 Thunderbird/3.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35 suspend regression (bisected)
References: <4C4C9E40.7070209@infracom.it> <201007272103.38448.rjw@sisk.pl> <4C4F38F1.105@gmail.com> <201007280037.30965.rjw@sisk.pl>
In-Reply-To: <201007280037.30965.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 28/07/2010 00:37, Rafael J. Wysocki wrote:
> On Tuesday, July 27, 2010, Roberto Oppedisano wrote:
>>    On 27/07/2010 21:03, Rafael J. Wysocki wrote:
>>>> I did bisect again and I did get a different result:
>>>>
>>>> c1518f12bab97a6d409a25aaccb02dc8895800f3 is the first bad commit
>>>>
>>>> Trying to revert that commit gives:
>>>>
>>>> $ git bisect reset
>>>> $ git revert c1518f12bab97a6d409a25aaccb02dc8895800f3
>>>> fatal: Commit c1518f12bab97a6d409a25aaccb02dc8895800f3 is a merge but no
>>>> -m option was given.
>>>>
>>>> How am I supposed to proceed now ? (sorry I'm a git newbie)
>>> The bisect turned up a merge, which means it probably didn't really converge
>>> for you.
>>>
>>> Do you use a camera driver?
>> Yes, this laptop has an integrated webcam.
>>
>> Bus 001 Device 004: ID 04f2:b059 Chicony Electronics Co., Ltd
>>
>>
>> which i think is driven by uvcvideo.ko. I've tryed to rmmod uvcvideo,
>> videodev and
>>
>> v4l1_compat but on current git suspend still hangs in the same way
>> (screen black,
>> backlight on, fans at full speed, no response to ping and... nothing in
>> the logs).
> Please try the current mainline with acpi_sleep=nonvs in the command line.

With:

	acpi_sleep=nonvs console=tty0

(kubuntu defaults to quiet spash) I was able to complete 3 suspend/resume cycles before hitting an hang. After a power cycle I was able to suspend again, so it seems that, albeit racy, this cmdline has a positive effect.

With:
	acpi_sleep=nonvs

or

	console=tty0

alone I've never been able to suspend (only the combination of the two makes a difference).

R



