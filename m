Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1BGAAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 19:00:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58406 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab1BGAAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 19:00:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gASr4rhy+XR/SYCDpEVJmPKDaJex5lxXM8prfwMsjszgN7SWchjLZ9/xTq2hyZT6MM
         7dsSW5pcbd39RFAVc7ICL0keHPEfo40WOFwQ0jyGvva9IhAQWZEEFtmpaoELo2gKOyJu
         KUhm5qCyKVvklCPLZUDuvJ9bpXp43B+bfbPaU=
MIME-Version: 1.0
In-Reply-To: <4D4F2A3C.9070407@metafoo.de>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
	<AANLkTi=4K8=QfqH1BB8WdTk8QuZf_WvhshwQdmFwQJ2L@mail.gmail.com>
	<4D4F2A3C.9070407@metafoo.de>
Date: Mon, 7 Feb 2011 02:00:50 +0200
Message-ID: <AANLkTimjqQhJ-zhVE-YDFdVn+pbNHXi2e0oa27V3X31P@mail.gmail.com>
Subject: Re: [PATCH 00/14] POWER: BQ27x00: New Properties, fixes, bq27000 support
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 1:09 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 02/06/2011 11:47 PM, Felipe Contreras wrote:
>> Hi,
>>
>> On Sun, Feb 6, 2011 at 2:47 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>> This patch series contains a few updates for the bq27x00 driver:
>>> * Support for additional power supply properties
>>> * Support for the bq27000 battery which is identical to the bq27200 but is
>>>  connected through the HDQ bus.
>>> * Adds a register cache to the driver and introduces polling the batteries state
>>> * Minor improvements and cleanups
>>>
>>> The last patch in this series is not specific to the bq27x00 driver but is
>>> required for uevents to be generated properly for this driver.
>>> The patch makes properties which return -ENODATA to be ignored when generating
>>> uevents. Previously in such a case uevent generation would have been aborted
>>> with an error. But since the bq27x00 return -ENODATA for the TIME_TO_FULL
>>> property when the battery is not charging and for the TIME_TO_EMPTY property
>>> when the battery is not discharging and at least one of them is always true
>>> uevent generation would always fail.
>>>
>>> This series has so far been tested with the bq27000 and the bq27200 battery, but
>>> not with the bq27500 battery, so it would be nice if somebody with a board
>>> containing such a battery could test the patches to make sure that there are no
>>> regressions.
>>
>> This might be a bit off-topic, but I have tried to get the battery on
>> the Nokia N900 working, and so far I'm only able to query the
>> remaining capacity, but not really to enabling charging. This is very
>> annoying, as I can only hack a certain amount of time, and then I have
>> to reflash, reboot, and wait for the batter to charge with the
>> official system (if there's enough power to flash).
>>
>> Do you have any hints how to do that?
>
> Sorry, I've never worked with the N900, so I have no idea. But Pali has tested this
> patch series on his N900, so he might have an idea.

Well, it has a bq27200 AFAIK.

-- 
Felipe Contreras
