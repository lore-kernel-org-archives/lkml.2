Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1EDQDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:03:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53464 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1EDQDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:03:14 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1105041117170.24613@xanadu.home>
References: <1304453087-7365-1-git-send-email-per.forlin@linaro.org>
	<alpine.LFD.2.00.1105032339370.24613@xanadu.home>
	<BANLkTim_x28NyWzo-Ug3+ZprgeT=VFwEfQ@mail.gmail.com>
	<alpine.LFD.2.00.1105041117170.24613@xanadu.home>
Date: Wed, 4 May 2011 18:03:13 +0200
Message-ID: <BANLkTinUnDN_ZE5hQuQvDUTFUJV+ZpTTag@mail.gmail.com>
Subject: Re: [PATCH] sdio: optimized SDIO IRQ handling for single function
From: Per Forlin <per.forlin@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>, linaro-dev@lists.linaro.org,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>,
        Ulf HANSSON <ulf.hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 May 2011 17:20, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Wed, 4 May 2011, Per Forlin wrote:
>
>> On 4 May 2011 05:40, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>> > On Tue, 3 May 2011, Per Forlin wrote:
>> >
>> >> From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
>> >>
>> >> If there is only 1 function registered, and IRQ:s are supported and
>> >> currently enabled, call the callback handler directly
>> >> without checking the CCCR registers.
>> >>
>> >> Signed-off-by: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
>> >> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> >
>> > Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
>> >
>> I am working o a patch version 2 after offline discussion with Ulf Hansson.
>> Instead of adding this code here.
>> Add sdio_single_func member in mmc_card. Set and reset this function
>> in sdio_claim_irq and sdio_release_irq.
>> process_sdio_pending_irqs would only check if sdio_single_func is !=
>> null and call it.
>
> Yes, that's what I was about to propose after thinking about it some
> more.
>
>> This will result in a bigger patch overall but the new code in
>> process_sdio_pending_irqs will be minimal.
>
> Something like this (untested) ?
>
What I had in mind is similar. Please let me know what you think. I am
about to post "patch v2"

Regards,
Per
