Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab2LPG2D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 01:28:03 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49904 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab2LPG2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 01:28:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAPtuhTg4NZqSAAaRvOb+0E_Op0Ye8+h=XeRyees-M-DpXXziqQ@mail.gmail.com>
References: <1354522477-11991-1-git-send-email-haojian.zhuang@gmail.com>
	<CAN1soZze6Ogn_zi7JJN0JNzoMFkHLJyKyjTV7rSWUmQhwRU0NQ@mail.gmail.com>
	<CAN1soZxJ_JCEVV5v99tFi22fq5AEOCBj1D5PY=vmGGW_gDWuJQ@mail.gmail.com>
	<CAPtuhTg4NZqSAAaRvOb+0E_Op0Ye8+h=XeRyees-M-DpXXziqQ@mail.gmail.com>
Date: Sun, 16 Dec 2012 14:27:58 +0800
Message-ID: <CAN1soZzOy7K6u8Q-kCr0ZC9c2b8BBDpma_vbci1iFq7yCu1jqQ@mail.gmail.com>
Subject: Re: [PATCH] clk: factor: calculate rate by do_div
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bergmann Arnd <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 4:54 AM, Mike Turquette <mturquette@linaro.org> wrote:
> On Sat, Dec 15, 2012 at 8:41 AM, Haojian Zhuang
> <haojian.zhuang@gmail.com> wrote:
>> On Tue, Dec 4, 2012 at 9:32 AM, Haojian Zhuang <haojian.zhuang@gmail.com> wrote:
>>> On Mon, Dec 3, 2012 at 4:14 PM, Haojian Zhuang <haojian.zhuang@gmail.com> wrote:
>>>> clk->rate = parent->rate / div * mult
>>>>
>>>> The formula is OK. But it may overflow while we do operate with
>>>> unsigned long. So use do_div instead.
>>>>
>>>> Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
>>>> ---
>>>>  drivers/clk/clk-fixed-factor.c |    5 ++++-
>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/clk/clk-fixed-factor.c b/drivers/clk/clk-fixed-factor.c
>>>> index a489985..1ef271e 100644
>>>> --- a/drivers/clk/clk-fixed-factor.c
>>>> +++ b/drivers/clk/clk-fixed-factor.c
>>>> @@ -28,8 +28,11 @@ static unsigned long clk_factor_recalc_rate(struct clk_hw *hw,
>>>>                 unsigned long parent_rate)
>>>>  {
>>>>         struct clk_fixed_factor *fix = to_clk_fixed_factor(hw);
>>>> +       unsigned long long int rate;
>>>>
>>>> -       return parent_rate * fix->mult / fix->div;
>>>> +       rate = (unsigned long long int)parent_rate * fix->mult;
>>>> +       do_div(rate, fix->div);
>>>> +       return (unsigned long)rate;
>>>>  }
>>>>
>>>>  static long clk_factor_round_rate(struct clk_hw *hw, unsigned long rate,
>>>> --
>>>> 1.7.10.4
>>>>
>>>
>>> Correct Mike's email address.
>>
>> Any comments? Does it mean that nobody want to fix the bug?
>
> Thanks for the patch.  My apologies for letting this one slip through
> the cracks but my normal email workflow was unavoidably disrupted and
> I find myself playing catch-up with pending patches.
>
> The patch looks good to me but I'll change the $SUBJECT to "clk:
> fixed-factor: round_rate should use do_div" and do some testing before
> taking it in.
>
> Regards,
> Mike

It's nice. Thank you.

Best Regards
Haojian
