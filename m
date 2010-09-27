Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab0I0NIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:08:43 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48836 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0I0NIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:08:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tXHjW8yUfaA9Ak8cPeTdPBzZeYuuBAK7On934Pt5QuSe73XZ9g6OnSref/dOic7Udk
         WFtA7G7/nEJD1iCDN9AG4dYxueJltTTMV3UWMR0CxPvTop5zUWOkJvuOOIQ3impGOYgQ
         mp8E2kTIR8Ick/BjIebQOaLvfui3aCwPT89Dg=
MIME-Version: 1.0
In-Reply-To: <AANLkTik0LOQN8kOPjv_VohhO5To6pZDS=M0mw=q0whPp@mail.gmail.com>
References: <1285529740-28232-1-git-send-email-notasas@gmail.com>
	<AANLkTinkxokX9BGtxysYOr19xbZR4S8oPRYUAyneutzc@mail.gmail.com>
	<AANLkTinh+JTwyE4E33QXdnZ8obYA8S0SU71i3kGi=wRT@mail.gmail.com>
	<AANLkTik0LOQN8kOPjv_VohhO5To6pZDS=M0mw=q0whPp@mail.gmail.com>
Date: Mon, 27 Sep 2010 16:08:41 +0300
Message-ID: <AANLkTi=xS_=QytU0Yrh5EEiiL6GyekcO+DezjT-Zpj-7@mail.gmail.com>
Subject: Re: [PATCH v3] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Grazvydas Ignotas <notasas@gmail.com>
To: Arun Murthy <arunrmurthy.83@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Madhusudhan <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 3:35 PM, Arun Murthy <arunrmurthy.83@gmail.com> wrote:
> On Mon, Sep 27, 2010 at 4:24 PM, Grazvydas Ignotas <notasas@gmail.com> wrote:
>> On Mon, Sep 27, 2010 at 10:21 AM, Arun Murthy <arunrmurthy.83@gmail.com> wrote:
>> The problem is that BCI is only active while charging, when it is not
>> charging most (all?) monitoring registers freeze and no monitoring
>> happens (BCI registers read frozen values from last charge). So I
>> don't register battery as it has no useful data to report. I heard it
>> is possible to use MADC to perform monitoring while not charging, so
>> battery can be added when MADC driver is merged and corresponding code
>> is written for this driver.
>>
> How do I check the battery voltage?
> I need to check the battery voltage/current/temp and, if I am not
> wrong these are obtained from MADC.
> MADC driver has to be added first and then the battery.
> With being able to read the basic parameter battery voltage, this
> driver becomes incomplete.

Incomplete driver is better than no driver, don't you think? There are
some boards like pandora or oswald that have additional battery
monitoring chips (as twl monitoring is pretty crude anyway), those
boards would have fully functional charging now. Currently mainline
kernel is not very useful with them simply because the battery runs
flat.

> How do I get notified if battery voltage is low and needs charging
> from user space?

Either additional monitoring chip notifies you (if you are lucky and
have one), or wait for update of this driver :) There are efforts to
merge MADC driver [1], but it may take some time.

[1] http://marc.info/?t=128461535700002&r=1&w=2
