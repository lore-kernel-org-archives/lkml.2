Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab2LDCvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 21:51:52 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43418 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2LDCvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 21:51:51 -0500
MIME-Version: 1.0
In-Reply-To: <20121203094828.GA14363@n2100.arm.linux.org.uk>
References: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
	<20121129102519.GG19440@n2100.arm.linux.org.uk>
	<CAN1soZxUA2PPy4694ByX1FTyWiJkha8QpKFK5Jc3Wf3zT0huOA@mail.gmail.com>
	<CADApbejZXach=YaiL5rEWA5+uc+mO8PzQzUKN+k90HfxEsqgtA@mail.gmail.com>
	<CADApbegrJDe5SiO255WdKYai1U7WjBYfMHuCm-hTNfx5p6Wz-Q@mail.gmail.com>
	<20121203094828.GA14363@n2100.arm.linux.org.uk>
Date: Tue, 4 Dec 2012 10:51:50 +0800
Message-ID: <CADApbegRJO+CJJYotP9vL4-kp5qmf4OZEzmqFAR6xu5yhRReFA@mail.gmail.com>
Subject: Re: [PATCH 1/4] rtc: sa1100: enable/disable rtc when probe/remove the device
From: Chao Xie <xiechao.mail@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Chao Xie <chao.xie@marvell.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 5:48 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Dec 03, 2012 at 10:53:07AM +0800, Chao Xie wrote:
>> I want to correct what i said. For the irq register/unregister i think
>> can be done at open/release. But for clock enable/disable, i do not
>> think so. If clock is disabled, as i think RTC will not work. User API
>> still use open->get_time->close for "date" command. It means that RTC
>> will not return correct date to user.
>
> "I think" is not good enough for patches like this.  Please test it.
>
> On SA11x0 and PXA platforms, the clock for the sa1100-rtc is a dummy
> clock; it has no effect.  For MMP, I don't have access to the TRMs so
> that's something you're going to have to find out.

I tested at pxa910 which uses rtc-sa1100 as driver.
the test procedure is simple
open->ioctl(RTC_RD_TIME)->close
With the original code, the rtc will not update, i always get the same value

remove clock disable/enable in release/open, and enable/disable clock
at probe/remove.
the rtc can update, and i can read the correct rtc value.
