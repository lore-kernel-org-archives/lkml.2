Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab0I0QNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:13:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54590 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759046Ab0I0QNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iL5UCmvMngpATfdq0/T90fNzq4OPkKwtikGgxXhDdvY/fXmeABwSycCKHUsyif1smo
         6S9OSNU2Q+PDAJXQ1mSfKUmNMQGySERq46EYqZhrepATcPotkIMMMCXrrrPodqkdTlOI
         x+kye/Rl3ukJrANzKaTRadPBDqiHrtZB8GPj4=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=xS_=QytU0Yrh5EEiiL6GyekcO+DezjT-Zpj-7@mail.gmail.com>
References: <1285529740-28232-1-git-send-email-notasas@gmail.com>
	<AANLkTinkxokX9BGtxysYOr19xbZR4S8oPRYUAyneutzc@mail.gmail.com>
	<AANLkTinh+JTwyE4E33QXdnZ8obYA8S0SU71i3kGi=wRT@mail.gmail.com>
	<AANLkTik0LOQN8kOPjv_VohhO5To6pZDS=M0mw=q0whPp@mail.gmail.com>
	<AANLkTi=xS_=QytU0Yrh5EEiiL6GyekcO+DezjT-Zpj-7@mail.gmail.com>
Date: Mon, 27 Sep 2010 21:43:05 +0530
Message-ID: <AANLkTi=gsvcWJak88NOfMjTumtLcdcU6-RUE+obWcacz@mail.gmail.com>
Subject: Re: [PATCH v3] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Arun Murthy <arunrmurthy.83@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Madhusudhan <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 6:38 PM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> On Mon, Sep 27, 2010 at 3:35 PM, Arun Murthy <arunrmurthy.83@gmail.com> wrote:
>> On Mon, Sep 27, 2010 at 4:24 PM, Grazvydas Ignotas <notasas@gmail.com> wrote:
>>> On Mon, Sep 27, 2010 at 10:21 AM, Arun Murthy <arunrmurthy.83@gmail.com> wrote:
>>> The problem is that BCI is only active while charging, when it is not
>>> charging most (all?) monitoring registers freeze and no monitoring
>>> happens (BCI registers read frozen values from last charge). So I
>>> don't register battery as it has no useful data to report. I heard it
>>> is possible to use MADC to perform monitoring while not charging, so
>>> battery can be added when MADC driver is merged and corresponding code
>>> is written for this driver.
>>>
>> How do I check the battery voltage?
>> I need to check the battery voltage/current/temp and, if I am not
>> wrong these are obtained from MADC.
>> MADC driver has to be added first and then the battery.
>> With being able to read the basic parameter battery voltage, this
>> driver becomes incomplete.
>
> Incomplete driver is better than no driver, don't you think? There are
> some boards like pandora or oswald that have additional battery
> monitoring chips (as twl monitoring is pretty crude anyway), those
> boards would have fully functional charging now. Currently mainline
> kernel is not very useful with them simply because the battery runs
> flat.
I agree, but I feel it would be better to make driver compatible with
all boards(Zoom2, OMAP3430SDP, Chameleon, BeagleBoard etc).
Even support for back-up battery is not supported.
This is just a suggestion to have a full fledged driver for twl4030
Battery Charger Interface as a module. You may discard this if you
have some strong reasons.

>
>> How do I get notified if battery voltage is low and needs charging
>> from user space?
>
> Either additional monitoring chip notifies you (if you are lucky and
> have one), or wait for update of this driver :) There are efforts to
> merge MADC driver [1], but it may take some time.
But using MADC, I can get the battery voltage and by means of
monitoring battery voltage we can get to know low battery
notification.
>
> [1] http://marc.info/?t=128461535700002&r=1&w=2
>
Thanks and Regards,
Arun R Murthy
--------------------
