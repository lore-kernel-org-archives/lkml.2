Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab1KHTOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:14:15 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22499 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1KHTON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:14:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="135816832"
Message-ID: <4EB97F83.3070509@codeaurora.org>
Date: Tue, 08 Nov 2011 11:14:11 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 2/2] msm: Support DEBUG_LL on MSM8660 and MSM8960
References: <1320777184-22446-1-git-send-email-sboyd@codeaurora.org> <1320777184-22446-3-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.02.1111081406220.3307@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1111081406220.3307@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/11 11:08, Nicolas Pitre wrote:
> Independently from this patch, I was wondering about this code:
>
>> +	.macro	senduart, rd, rx
>> +#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
>> +	@ Write the 1 character to UARTDM_TF
>> +	str	\rd, [\rx, #0x70]
>> +#else
>>  	teq	\rx, #0
>>  	strne	\rd, [\rx, #0x0C]
>> +#endif
>>  	.endm
> Why testing for zero in the #else part?  The upper level code should 
> never call this macro with a null byte.
>

I was wondering the same thing, I don't know why that test for null is
there. I will dust off the old 7201a (literally) and see what I can find
out. It certainly looks unnecessary.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

