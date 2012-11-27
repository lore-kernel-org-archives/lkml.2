Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2K0W1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:27:13 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53317 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2K0W1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:27:11 -0500
Message-ID: <50B53E37.40303@samsung.com>
Date: Wed, 28 Nov 2012 07:27:03 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Doug Anderson <dianders@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: EXYNOS: Avoid early use of of_machine_is_compatible()
References: <1354045994-8977-1-git-send-email-dianders@chromium.org> <CAOesGMjyXZwKjycyVcEV0ty0LCM_i61QxykYPhAvXxx2rhgP+A@mail.gmail.com>
In-Reply-To: <CAOesGMjyXZwKjycyVcEV0ty0LCM_i61QxykYPhAvXxx2rhgP+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/12 07:11, Olof Johansson wrote:
> On Tue, Nov 27, 2012 at 11:53 AM, Doug Anderson<dianders@chromium.org>  wrote:
>> The recent commit "ARM: EXYNOS: add support for EXYNOS5440 SoC" broke
>> support for exynos5250 because of_machine_is_compatible() was used too
>> early in the boot process.  It also probably meant that the exynos5440
>> failed to use the proper iotable.  Switch to use
>> of_flat_dt_is_compatible() in both of these cases.
>>
>> The failure I was seeing in exynos5250 because of this was:
>>    Division by zero in kernel.
>>    [<80015ed4>] (unwind_backtrace+0x0/0xec) from [<8045c7a4>] (dump_stack+0x20/0x24)
>>    [<8045c7a4>] (dump_stack+0x20/0x24) from [<80012990>] (__div0+0x20/0x28)
>>    [<80012990>] (__div0+0x20/0x28) from [<8021ab04>] (Ldiv0_64+0x8/0x18)
>>    [<8021ab04>] (Ldiv0_64+0x8/0x18) from [<80068560>] (__clocksource_updatefreq_scale+0x54/0x134)
>>    [<80068560>] (__clocksource_updatefreq_scale+0x54/0x134) from [<8006865c>] (__clocksource_register_scale+0x1c/0x54)
>>    [<8006865c>] (__clocksource_register_scale+0x1c/0x54) from [<80612a18>] (exynos_timer_init+0x100/0x1e8)
>>    [<80612a18>] (exynos_timer_init+0x100/0x1e8) from [<8060d184>] (time_init+0x28/0x38)
>>    [<8060d184>] (time_init+0x28/0x38) from [<8060a754>] (start_kernel+0x1e0/0x3c8)
>>    [<8060a754>] (start_kernel+0x1e0/0x3c8) from [<40008078>] (0x40008078)
>>
>> Signed-off-by: Doug Anderson<dianders@chromium.org>
>
> Thanks Doug.
>
> Kukjin, I'll apply this directly on top of the previous branch in
> arm-soc, if that's OK with you.
>
Sure, go ahead with my ack if you want,

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Note, actually there was a fix which uses soc_is_exynos5440() in my 
local :-) I'm not sure which one is better at this moment, but I'm OK on 
this.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
