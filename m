Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2LXKbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 05:31:49 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:45767 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LXKbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 05:31:47 -0500
MIME-Version: 1.0
In-Reply-To: <50D82E40.7050707@nvidia.com>
References: <1356341680-29644-1-git-send-email-ldewangan@nvidia.com>
	<CAHdPZaOSfYb=1YxtYZ9LT=tVhE-LMs6NfON4-+1XMMW_CfN+kg@mail.gmail.com>
	<50D82E40.7050707@nvidia.com>
Date: Mon, 24 Dec 2012 16:01:47 +0530
Message-ID: <CAHdPZaPaOVoc8a3v_4+y3Cp1J9JRgyfeHQTJqvK-LbMnjrehDQ@mail.gmail.com>
Subject: Re: [PATCH] rtc: add RTC driver for TPS80031/TPS80032
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Dec 24, 2012 at 3:58 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Thanks Devendra for quick review.
>
> Following are my response specific to query.
>
> I will post the next patch for taking care of comments.
>
>

thanks :)

>
>
> On Monday 24 December 2012 03:32 PM, devendra.aaru wrote:
>>
>> Hello,
>>
>> On Mon, Dec 24, 2012 at 3:04 PM, Laxman Dewangan<ldewangan@nvidia.com>
>> wrote:
>>>
>>> Add an RTC driver for TPS80031/TPS80032 chips by TI.
>>> This driver supports:
>>> - Setting and getting time and date.
>>> - Setting and reading alarm time.
>>> - Alarm and interrupt functionlity.
>>>
>>
>>> +
>>> +       if (alrm->enabled&&  (seconds<  epoch_start)) {
>>
>> its better to have this check in the core itself rather duplicating
>> everywhere, but i think the core already have this check, will you
>> please check ?
>
>
> Yes, it is there in __rtc_set_alarm() of interface.c file. I will remove
> this in next patch.
>

ok.

>
>
>>> +
>>> +static const struct dev_pm_ops tps80031_pm_ops = {
>>> +       SET_SYSTEM_SLEEP_PM_OPS(tps80031_rtc_suspend,
>>> tps80031_rtc_resume)
>>
>> say we dont have enabled CONFIG_PM_SLEEP, will we get an compiler error ?
>
>
> No compilation error. This is already taken care in on pm.h.
>

ok good to know, sorry for disturbing you with this comment.

>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
