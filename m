Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1I2Fjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 01:39:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9092 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1I2Fjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 01:39:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6483"; a="123161866"
Message-ID: <4E8404A2.10702@codeaurora.org>
Date: Wed, 28 Sep 2011 22:39:46 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] msm: Support DEBUG_LL on MSM8660 and MSM8960
References: <1317243959-26383-1-git-send-email-sboyd@codeaurora.org> <1317243959-26383-3-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.02.1109290012400.9106@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1109290012400.9106@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2011 9:21 PM, Nicolas Pitre wrote:
> On Wed, 28 Sep 2011, Stephen Boyd wrote:
>
>
>>  	.macro	senduart,rd,rx
>> +#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
>> +	@ Clear TX_READY by writing to the UARTDM_CR register
>> +	mov	r12, #0x300
>> +	str	r12, [\rx, #0x10]
>> +	@ Write 0x1 to NCF register
>> +	mov 	r12, #0x1
>> +	str	r12, [\rx, #0x40]
>> +	@ UARTDM reg. Read to induce delay
>> +	ldr	r12, [\rx, #0x08]
>> +	@ Write the 1 character to UARTDM_TF
>> +	str	\rd, [\rx, #0x70]
> This is a really bad idea to pick a register (r12) when the calling code 
> is completely unaware of that.  This _will_ break on you someday.
>
> Except for the last line, why didn't you simply fold this code into the 
> waituart macro instead?

We need to configure the uart to be ready for a write and it didn't seem
appropriate to put that in the waituart macro because it isn't actually
waiting for anything. I suppose putting it after the waiting is fine
though and avoids future breakage. Thanks.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

