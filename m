Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1AXWod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:44:33 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59644 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1AXWob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:44:31 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71601896"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 02/11] msm: Generalize timer register mappings
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	<1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	<1295468747-22796-3-git-send-email-davidb@codeaurora.org>
	<1295908604.29639.62.camel@c-dwalke-linux.qualcomm.com>
X-Hashcash: 1:20:110124:linux-arm-msm@vger.kernel.org::7REBpiHT2etYpqjZ:000000000000000000000000000000000aZA
X-Hashcash: 1:20:110124:dwalker@codeaurora.org::hAoImOWHlqkd4Bkr:0000000000000000000000000000000000000001pt1
X-Hashcash: 1:20:110124:linux-arm-kernel@lists.infradead.org::ap4hQ/1fDgQeO9/7:00000000000000000000000002svB
X-Hashcash: 1:20:110124:linux-kernel@vger.kernel.org::wzmR7evenEeYCijq:0000000000000000000000000000000005xRL
Date: Mon, 24 Jan 2011 14:44:31 -0800
In-Reply-To: <1295908604.29639.62.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Mon, 24 Jan 2011 14:36:44 -0800")
Message-ID: <8yaei81kjlc.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24 2011, Daniel Walker wrote:

> On Wed, 2011-01-19 at 12:25 -0800, David Brown wrote:
>> +       int global_offset = 0;
>> +
>> +       if (cpu_is_msm7x01()) {
>> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
>> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
>> +       } else if (cpu_is_msm7x30()) {
>> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE + 0x04;
>> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x24;
>> +       } else if (cpu_is_qsd8x50()) {
>> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
>> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
>> +       } else if (cpu_is_msm8x60()) {
>> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_TMR_BASE + 0x04;
>> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_TMR_BASE + 0x24;
>> +
>> +               /* Use CPU0's timer as the global timer. */
>> +               global_offset = MSM_TMR0_BASE - MSM_TMR_BASE;
>> +       } else
>> +               BUG(); 
>
> Ifdef's here would be OK I think, your already using the "runtime"
> checks ..

The point of the change is to get rid of the ifdefs so that we can
dynamically detect which target we are on.  Yes, there are other places
where it doesn't work, but we'll get there gradually.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
