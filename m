Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab2IZSwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:52:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54712 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab2IZSwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:52:20 -0400
MIME-Version: 1.0
In-Reply-To: <50634DF9.5010608@codeaurora.org>
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
	<1348194419-11486-2-git-send-email-sboyd@codeaurora.org>
	<CADTbHxoFeYWPJpYTN85kBeF=kv2v1yDioJW-upzn1RcwVT_sKw@mail.gmail.com>
	<50634DF9.5010608@codeaurora.org>
Date: Thu, 27 Sep 2012 00:22:19 +0530
Message-ID: <CADTbHxr7Drfg4iRqFyLkwq1ALUABp96tSrO2w9L1s851P+Z5Sg@mail.gmail.com>
Subject: Re: [PATCH 01/10] usb: otg: msm: Convert to clk_prepare/unprepare
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 12:18 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 09/26/12 09:58, Pankaj Jangra wrote:
>> On Fri, Sep 21, 2012 at 7:56 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> diff --git a/drivers/usb/otg/msm_otg.c b/drivers/usb/otg/msm_otg.c
>>> index 9f5fc90..2ae0639 100644
>>> --- a/drivers/usb/otg/msm_otg.c
>>> +++ b/drivers/usb/otg/msm_otg.c
>>> @@ -514,13 +514,13 @@ static int msm_otg_suspend(struct msm_otg *motg)
>>>                         motg->pdata->otg_control == OTG_PMIC_CONTROL)
>>>                 writel(readl(USB_PHY_CTRL) | PHY_RETEN, USB_PHY_CTRL);
>>>
>>> -       clk_disable(motg->pclk);
>>> -       clk_disable(motg->clk);
>>> +       clk_disable_unprepare(motg->pclk);
>>> +       clk_disable_unprepare(motg->clk);
>>>         if (motg->core_clk)
>>> -               clk_disable(motg->core_clk);
>>> +               clk_disable_unprepare(motg->core_clk);
>>>
>> I was under assumption that system suspend/resume might be called from
>> the interrupt context. If that is case then its not appropriate to
>> call clk_prepare/unprepare here right? or my understanding is not correct????
>
> Well we call disable_irq() at the top of this suspend function so I
> suspect your understanding is incorrect. disable_irq() can call
> schedule(). There are also a bunch of regulator calls in
> msm_hsusb_ldo_set_mode() that this suspend function calls (almost all
> regulator calls grab a mutex).

Ok, might be i am worng because in acpuclock driver of msm on
codeaurora tree, i have seen in commit text saying that it can be
called from suspend/resume in interrupt context .
So i was assuming that. Any way thanks.

--
Pankaj Jangra
