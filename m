Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2K3HEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 02:04:15 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33290 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2K3HEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 02:04:14 -0500
MIME-Version: 1.0
In-Reply-To: <20121129102519.GG19440@n2100.arm.linux.org.uk>
References: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
	<20121129102519.GG19440@n2100.arm.linux.org.uk>
Date: Fri, 30 Nov 2012 15:04:12 +0800
Message-ID: <CAN1soZxUA2PPy4694ByX1FTyWiJkha8QpKFK5Jc3Wf3zT0huOA@mail.gmail.com>
Subject: Re: [PATCH 1/4] rtc: sa1100: enable/disable rtc when probe/remove the device
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Chao Xie <chao.xie@marvell.com>, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        xie chao <xiechao.mail@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 6:25 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Nov 28, 2012 at 09:21:07PM -0500, Chao Xie wrote:
>> The original sa1100_rtc_open/sa1100_rtc_release will be called
>> when the /dev/rtc0 is opened or closed.
>> In fact, these two functions will enable/disable the clock, and
>> register/unregister the irqs.
>> User application will use /dev/rtc0 to read the rtc time or set
>> the alarm. The rtc should still run indepent of open/close the
>> rtc device.
>> So only enable clock and register the irqs when probe the device,
>> and disable clock and unregister the irqs when remove the device.
>
> NAK.  I don't think you properly understand what's going on here if you
> think moving the entire open and release functions into the probe and
> remove functions is the right thing to do.

Since PXA27x & PXA3xx supports dual rtc device at the same time,
user could choose use either of rtc at run time. Then clk & irq are setup
in open().

Chao,
So you shouldn't remove them into probe().
