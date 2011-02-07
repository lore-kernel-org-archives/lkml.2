Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab1BGALB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 19:11:01 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:49199 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212Ab1BGALA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 19:11:00 -0500
Message-ID: <4D4F38E9.4030806@metafoo.de>
Date: Mon, 07 Feb 2011 01:12:25 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 00/14] POWER: BQ27x00: New Properties, fixes, bq27000
 support
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>	<AANLkTi=4K8=QfqH1BB8WdTk8QuZf_WvhshwQdmFwQJ2L@mail.gmail.com>	<4D4F2A3C.9070407@metafoo.de> <AANLkTimjqQhJ-zhVE-YDFdVn+pbNHXi2e0oa27V3X31P@mail.gmail.com>
In-Reply-To: <AANLkTimjqQhJ-zhVE-YDFdVn+pbNHXi2e0oa27V3X31P@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 01:00 AM, Felipe Contreras wrote:
> On Mon, Feb 7, 2011 at 1:09 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> On 02/06/2011 11:47 PM, Felipe Contreras wrote:
>>> Hi,
>>>
>>> On Sun, Feb 6, 2011 at 2:47 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>>> This patch series contains a few updates for the bq27x00 driver:
>>>> * Support for additional power supply properties
>>>> * Support for the bq27000 battery which is identical to the bq27200 but is
>>>>  connected through the HDQ bus.
>>>> * Adds a register cache to the driver and introduces polling the batteries state
>>>> * Minor improvements and cleanups
>>>>
>>>> The last patch in this series is not specific to the bq27x00 driver but is
>>>> required for uevents to be generated properly for this driver.
>>>> The patch makes properties which return -ENODATA to be ignored when generating
>>>> uevents. Previously in such a case uevent generation would have been aborted
>>>> with an error. But since the bq27x00 return -ENODATA for the TIME_TO_FULL
>>>> property when the battery is not charging and for the TIME_TO_EMPTY property
>>>> when the battery is not discharging and at least one of them is always true
>>>> uevent generation would always fail.
>>>>
>>>> This series has so far been tested with the bq27000 and the bq27200 battery, but
>>>> not with the bq27500 battery, so it would be nice if somebody with a board
>>>> containing such a battery could test the patches to make sure that there are no
>>>> regressions.
>>>
>>> This might be a bit off-topic, but I have tried to get the battery on
>>> the Nokia N900 working, and so far I'm only able to query the
>>> remaining capacity, but not really to enabling charging. This is very
>>> annoying, as I can only hack a certain amount of time, and then I have
>>> to reflash, reboot, and wait for the batter to charge with the
>>> official system (if there's enough power to flash).
>>>
>>> Do you have any hints how to do that?
>>
>> Sorry, I've never worked with the N900, so I have no idea. But Pali has tested this
>> patch series on his N900, so he might have an idea.
> 
> Well, it has a bq27200 AFAIK.
> 

It has, but that doesn't tell you anything about the charging circuit.

- Lars
