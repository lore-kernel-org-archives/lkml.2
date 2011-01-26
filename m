Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1AZWNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:13:05 -0500
Received: from smtp-out.google.com ([74.125.121.67]:26062 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1AZWND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:13:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xg8TukPNshsHnp471EntXDbvLaxidYKAE7d4IexPD/xuGcyZvgUHZjQdhtnsaQKcmg
         T2jikKZg6r1W/v/zqtOg==
MIME-Version: 1.0
In-Reply-To: <8yaei81kjlc.fsf@huya.qualcomm.com>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	<1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	<1295468747-22796-3-git-send-email-davidb@codeaurora.org>
	<1295908604.29639.62.camel@c-dwalke-linux.qualcomm.com>
	<8yaei81kjlc.fsf@huya.qualcomm.com>
Date: Wed, 26 Jan 2011 14:12:59 -0800
Message-ID: <AANLkTi=UBfBp-VOQ=n_a4sjA9v_dhcv-rXcXiE6zrf23@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] msm: Generalize timer register mappings
From: Dima Zavin <dmitriyz@google.com>
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 2:44 PM, David Brown <davidb@codeaurora.org> wrote:
> On Mon, Jan 24 2011, Daniel Walker wrote:
>
>> On Wed, 2011-01-19 at 12:25 -0800, David Brown wrote:
>>> +       int global_offset = 0;
>>> +
>>> +       if (cpu_is_msm7x01()) {
>>> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
>>> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
>>> +       } else if (cpu_is_msm7x30()) {
>>> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE + 0x04;
>>> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x24;
>>> +       } else if (cpu_is_qsd8x50()) {
>>> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
>>> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
>>> +       } else if (cpu_is_msm8x60()) {
>>> +               msm_clocks[MSM_CLOCK_GPT].regbase = MSM_TMR_BASE + 0x04;
>>> +               msm_clocks[MSM_CLOCK_DGT].regbase = MSM_TMR_BASE + 0x24;
>>> +
>>> +               /* Use CPU0's timer as the global timer. */
>>> +               global_offset = MSM_TMR0_BASE - MSM_TMR_BASE;
>>> +       } else
>>> +               BUG();
>>
>> Ifdef's here would be OK I think, your already using the "runtime"
>> checks ..
>
> The point of the change is to get rid of the ifdefs so that we can
> dynamically detect which target we are on.  Yes, there are other places
> where it doesn't work, but we'll get there gradually.

To be honest I don't understand why you would want to do this at
runtime. You cannot select multiple SoCs in the kernel build anyway,
nor would you want to. Trying to have same kernel to boot on ARM v6
and ARM v7 would already be freaky enough. On top of that mixing 7201a
with all the baggage that it comes with 8x60 just wouldn't make sense.
These architectures are so different that it I can't see that ever
being useful. When would you ever envision building for multiple of
these SoCs at the same time?

--Dima

>
> David
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
