Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2G3Wix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 18:38:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22299 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2G3Wiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:38:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6788"; a="216110984"
Message-ID: <50170CF8.9010307@codeaurora.org>
Date: Mon, 30 Jul 2012 15:38:48 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] ARM: Sort exception table at compile time
References: <1343683803-15507-1-git-send-email-sboyd@codeaurora.org> <20120730215617.GA10335@n2100.arm.linux.org.uk>
In-Reply-To: <20120730215617.GA10335@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/12 14:56, Russell King - ARM Linux wrote:
> On Mon, Jul 30, 2012 at 02:30:03PM -0700, Stephen Boyd wrote:
>> Add the ARM machine identifier to sortextable and select the
>> config option so that we can sort the exception table at compile
>> time. sortextable relies on a section named __ex_table existing
>> in the vmlinux, but ARM's linker script places the exception
>> table in the data section. Give the exception table its own
>> section so that sortextable can find it.
>>
>> This allows us to skip the runtime sorting step during boot.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> Cc: David Daney <david.daney@cavium.com>
>> ---
>>
>> I can't find any information on why the exception table lives in the data
>> section. If there's a good reason for that, I'll look into changing
>> sortextable to look for the __start___ex_table symbol.
> Be careful about the placement of this, especially with XIP.
>

Thanks for the hint. I'm unfamiliar with how XIP works so I'll take a
closer look there.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

