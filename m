Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab2GaUBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:01:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36607 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2GaUBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:01:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6789"; a="214132370"
Message-ID: <5018398F.5010800@codeaurora.org>
Date: Tue, 31 Jul 2012 13:01:19 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] ARM: Sort exception table at compile time
References: <1343683803-15507-1-git-send-email-sboyd@codeaurora.org> <20120730215617.GA10335@n2100.arm.linux.org.uk> <50170CF8.9010307@codeaurora.org>
In-Reply-To: <50170CF8.9010307@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/12 15:38, Stephen Boyd wrote:
> On 07/30/12 14:56, Russell King - ARM Linux wrote:
>> On Mon, Jul 30, 2012 at 02:30:03PM -0700, Stephen Boyd wrote:
>>> Add the ARM machine identifier to sortextable and select the
>>> config option so that we can sort the exception table at compile
>>> time. sortextable relies on a section named __ex_table existing
>>> in the vmlinux, but ARM's linker script places the exception
>>> table in the data section. Give the exception table its own
>>> section so that sortextable can find it.
>>>
>>> This allows us to skip the runtime sorting step during boot.
>>>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> Cc: David Daney <david.daney@cavium.com>
>>> ---
>>>
>>> I can't find any information on why the exception table lives in the data
>>> section. If there's a good reason for that, I'll look into changing
>>> sortextable to look for the __start___ex_table symbol.
>> Be careful about the placement of this, especially with XIP.
>>
> Thanks for the hint. I'm unfamiliar with how XIP works so I'll take a
> closer look there.
>

Ok. It looks like the exception table is placed in the data section so
that XIP kernels can boot up and sort the exception table (otherwise the
exception table would be in read-only flash). Now that the exception
table is sorted at compile time, we should be able to place the
exception table in the rodata area, essentially placing the table in the
non-volatile storage on XIP kernels.

I propose we move the exception table right after the rodata. Other
arches (x86/mips) may actually want to put the exception table into the
rodata, but that looks like a larger change.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

