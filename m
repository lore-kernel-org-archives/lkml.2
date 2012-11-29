Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2K2KBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:01:51 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37206 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2K2KBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:01:49 -0500
MIME-Version: 1.0
In-Reply-To: <20121129093428.GV2013@gmail.com>
References: <d1f012d7bb2835f696fc100073f2eb16d9f6204d.1354128258.git.viresh.kumar@linaro.org>
	<33d71d9d29a3edd2c4a33e0f187cdb89f344af72.1354128258.git.viresh.kumar@linaro.org>
	<20121129093428.GV2013@gmail.com>
Date: Thu, 29 Nov 2012 15:31:49 +0530
Message-ID: <CAKohpom3cikKkwyMGSNu8sE+vTdcuFrMFNghmCHSHYpNMvr+=g@mail.gmail.com>
Subject: Re: [PATCH V4 Resend 2/3] mfd: stmpe: Remove irq_trigger from
 platform data
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linus.walleij@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 November 2012 15:04, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 29 Nov 2012, Viresh Kumar wrote:
>
>> STMPE can confige
>
>             configure?
>
>> the way the device emits interrupts and till now this
>
>                                           until?

Ahh... Will fix them. This happens when you send patches at midnight. :)

>> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c

>>               ret = devm_request_threaded_irq(ci->dev, stmpe->irq, NULL,
>> -                             stmpe_irq, pdata->irq_trigger | IRQF_ONESHOT,
>> -                             "stmpe", stmpe);
>> +                             stmpe_irq, IRQF_ONESHOT, "stmpe", stmpe);
>
> Forgive my ignorance, but you're no longer passing irq_trigger.
>
> Is this intentional? If so, why was it needed before and not now?

Yes, it was intentional. I thought it wasn't required at all. But my mind
is changing a bit now. I feel it is not required for DT, as trigger prop
is already passed in the interrupts cell. But for non-DT user, this is
still required. As there is not other way by which IRQ controller will
come to know what irq trigger type to enable for this irq line.

--
viresh
