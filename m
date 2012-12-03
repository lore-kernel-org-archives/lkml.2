Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2LCCxM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:53:12 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:56910 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab2LCCxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:53:08 -0500
MIME-Version: 1.0
In-Reply-To: <CADApbejZXach=YaiL5rEWA5+uc+mO8PzQzUKN+k90HfxEsqgtA@mail.gmail.com>
References: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
	<20121129102519.GG19440@n2100.arm.linux.org.uk>
	<CAN1soZxUA2PPy4694ByX1FTyWiJkha8QpKFK5Jc3Wf3zT0huOA@mail.gmail.com>
	<CADApbejZXach=YaiL5rEWA5+uc+mO8PzQzUKN+k90HfxEsqgtA@mail.gmail.com>
Date: Mon, 3 Dec 2012 10:53:07 +0800
Message-ID: <CADApbegrJDe5SiO255WdKYai1U7WjBYfMHuCm-hTNfx5p6Wz-Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] rtc: sa1100: enable/disable rtc when probe/remove the device
From: Chao Xie <xiechao.mail@gmail.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chao Xie <chao.xie@marvell.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 9:39 AM, Chao Xie <xiechao.mail@gmail.com> wrote:
> On Fri, Nov 30, 2012 at 3:04 PM, Haojian Zhuang
> <haojian.zhuang@gmail.com> wrote:
>> On Thu, Nov 29, 2012 at 6:25 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>>> On Wed, Nov 28, 2012 at 09:21:07PM -0500, Chao Xie wrote:
>>>> The original sa1100_rtc_open/sa1100_rtc_release will be called
>>>> when the /dev/rtc0 is opened or closed.
>>>> In fact, these two functions will enable/disable the clock, and
>>>> register/unregister the irqs.
>>>> User application will use /dev/rtc0 to read the rtc time or set
>>>> the alarm. The rtc should still run indepent of open/close the
>>>> rtc device.
>>>> So only enable clock and register the irqs when probe the device,
>>>> and disable clock and unregister the irqs when remove the device.
>>>
>>> NAK.  I don't think you properly understand what's going on here if you
>>> think moving the entire open and release functions into the probe and
>>> remove functions is the right thing to do.
>>
>> Since PXA27x & PXA3xx supports dual rtc device at the same time,
>> user could choose use either of rtc at run time. Then clk & irq are setup
>> in open().
>>
>> Chao,
>> So you shouldn't remove them into probe().
>
> How can user to choose one RTC?
> The user API, for example "date" will open the device, get the time
> and then close the device.
> WHen set a alarm, it is the same routine. open->set->close.
> The open routine will enable clock and register irq, close will
> disable the clock and unregister irq. It means that if only open is
> invoked, rtc begins to work, and after close is invoked rtc stops
> working. It means that the user can not get correct time and can not
> get right alarm.

hi
I want to correct what i said. For the irq register/unregister i think
can be done at open/release. But for clock enable/disable, i do not
think so. If clock is disabled, as i think RTC will not work. User API
still use open->get_time->close for "date" command. It means that RTC
will not return correct date to user.
