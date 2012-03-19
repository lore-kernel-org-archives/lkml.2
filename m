Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab2CSNTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:19:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51006 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2CSNTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120319130445.GN15988@n2100.arm.linux.org.uk>
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com>
	<20120319130445.GN15988@n2100.arm.linux.org.uk>
Date: Mon, 19 Mar 2012 18:49:34 +0530
Message-ID: <CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 6:34 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Mar 19, 2012 at 06:31:44PM +0530, Ajeet Yadav wrote:
>> Hi John, refering to you patch:
>>
>> ARM: remove 'select GENERIC_TIME'
>> GENERIC_TIME is now enabled by default, so 'select GENERIC_TIME' is
>> redundant.  Remove them.
>>
>> The following config's are not selectable:
>> config NO_HZ, config HIGH_RES_TIMERS, config IRQSOFF_TRACER, config
>> PREEMPT_TRACER
>>
>> As far as I know, ARM now uses GENERIC_TIME via the arch_getoffset()
>> infrastructure, i.e ARCH_USES_GETTIMEOFFSET=y
>
> No.  It is possible to select these options, but only if your platform
> uses the clockevent and clocksource infrastructure.  If you're using that,
> then you must _not_ select ARCH_USES_GETTIMEOFFSET.
>
> ARCH_USES_GETTIMEOFFSET is for compatibility with old unconverted
> platforms, which are _not_ possible to use the above features.

Just before the patch "time: Kill off CONFIG_GENERIC_TIME" Generic
time was selectable option,
Therefore our target configuration with 2.6 kernel was
GENERIC_CLOCKEVENTS=y, ARCH_USES_GETTIMEOFFSET=y,
I conclude that GENERIC_CLOCKEVENTS is supported, hence I must set
ARCH_USES_GETTIMEOFFSET=n, in order to use NO_HZ, HIGH_RES_TIMERS,
IRQSOFF_TRACER, PREEMPT_TRACER
