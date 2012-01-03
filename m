Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2ACWky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:40:54 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:61292 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756164Ab2ACWkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:40:47 -0500
MIME-Version: 1.0
In-Reply-To: <4F03821D.9080503@codeaurora.org>
References: <1325616276-10304-1-git-send-email-sjg@chromium.org>
	<4F03821D.9080503@codeaurora.org>
Date: Tue, 3 Jan 2012 14:40:46 -0800
X-Google-Sender-Auth: LlcE-LwoqRPRjx95ClVAPSucMls
Message-ID: <CAPnjgZ1P6bdAGRa-9ZyuNMT7jRAfrH3abWJPkxVeeM7BDKsXTg@mail.gmail.com>
Subject: Re: [PATCH] ARM: Remove BUILD_BUG_ON from asm/bug.h
From: Simon Glass <sjg@chromium.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, Ben Hutchings <ben@decadent.org.uk>,
        Olof Johansson <olofj@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Martin <dave.martin@linaro.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Jan 3, 2012 at 2:33 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 01/03/12 10:44, Simon Glass wrote:
>> BUILD_BUG_ON is defined in linux/kernel.h but that is not included by the
>> asm/bug.h header which uses it. This causes a build error:
>>
>> ...include/linux/mtd/map.h: In function 'inline_map_read':
>> ...include/linux/mtd/map.h:408:3: error: implicit declaration of function
>> 'BUILD_BUG_ON' [-Werror=implicit-function-declaration]
>>
>> The check is not essential and is not present for other architectures, so
>> just remove it.
>
> I thought this check was put in place to catch changes to struct
> bug_entry being out of sync with the __BUG macro defined in ARM. Why
> can't we include kernel.h instead? Or can you elaborate some more on why
> we don't need this check in the commit text?

Yes that is the reason, but ARM is not unique in this matter, and
other archs do not have this check. I did suggest a solution in this
thread involving putting the check in a C file instead of header. But
it needs an arch-specific #define to specify the size expected by the
assembler, and has the disadvantage of moving the check away from the
assembler code.

It's not that we don't want this check, more that it is not essential
(since there is currently no mismatch), it is causing problems and it
is risky to try to solve this problem some other way at this late
stage in 3.2. So the easiest thing is to remove it, to match other
archs.

Regards,
Simon

>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
