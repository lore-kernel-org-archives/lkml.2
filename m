Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0LPVkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:40:41 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1873 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab0LPVki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:40:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67136869"
Message-ID: <4D0A8755.9080408@codeaurora.org>
Date: Thu, 16 Dec 2010 13:40:37 -0800
From: Jeff Ohlstein <johlstei@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v5 4/5] msm: hotplug: support cpu hotplug on msm
References: <1292482456-22690-1-git-send-email-johlstei@codeaurora.org>	<1292482456-22690-5-git-send-email-johlstei@codeaurora.org> <AANLkTinzVP4rjOZM0PZQGYBNm+z-O=S0h6vo1QVoh+ps@mail.gmail.com>
In-Reply-To: <AANLkTinzVP4rjOZM0PZQGYBNm+z-O=S0h6vo1QVoh+ps@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> On 16 December 2010 06:54, Jeff Ohlstein <johlstei@codeaurora.org> wrote:
>> --- /dev/null
>> +++ b/arch/arm/mach-msm/hotplug.c
> [...]
>> +static inline void platform_do_lowpower(unsigned int cpu)
>> +{
>> +       /* Just enter wfi for now. TODO: Properly shut off the cpu. */
>> +       for (;;) {
>> +               /*
>> +                * here's the WFI
>> +                */
>> +               asm(".word      0xe320f003\n"
>> +                   :
>> +                   :
>> +                   : "memory", "cc");
>
> Is this for an ARMv7 platform? If yes, you could just use the WFI
> instruction directly (and it would also work if compiling the kernel
> to Thumb-2 mode).
>   

I was trying to make the code as similar to the realview code as I
reasonably could. There are several instances of that, we could fix all
of them in one go.

-Jeff

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

