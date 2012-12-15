Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2LOQm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 11:42:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41363 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2LOQm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 11:42:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAN1soZze6Ogn_zi7JJN0JNzoMFkHLJyKyjTV7rSWUmQhwRU0NQ@mail.gmail.com>
References: <1354522477-11991-1-git-send-email-haojian.zhuang@gmail.com>
	<CAN1soZze6Ogn_zi7JJN0JNzoMFkHLJyKyjTV7rSWUmQhwRU0NQ@mail.gmail.com>
Date: Sun, 16 Dec 2012 00:42:26 +0800
Message-ID: <CAN1soZw=TjxENOPLLHb08FuWpVYH-s-3mVvLd7yTymU2UGovww@mail.gmail.com>
Subject: Re: [PATCH] clk: factor: calculate rate by do_div
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mike.turquette@linaro.org>,
        Bergmann Arnd <arnd@arndb.de>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 9:32 AM, Haojian Zhuang <haojian.zhuang@gmail.com> wrote:
> On Mon, Dec 3, 2012 at 4:14 PM, Haojian Zhuang <haojian.zhuang@gmail.com> wrote:
>> clk->rate = parent->rate / div * mult
>>
>> The formula is OK. But it may overflow while we do operate with
>> unsigned long. So use do_div instead.
>>
>> Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
>> ---
>>  drivers/clk/clk-fixed-factor.c |    5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/clk-fixed-factor.c b/drivers/clk/clk-fixed-factor.c
>> index a489985..1ef271e 100644
>> --- a/drivers/clk/clk-fixed-factor.c
>> +++ b/drivers/clk/clk-fixed-factor.c
>> @@ -28,8 +28,11 @@ static unsigned long clk_factor_recalc_rate(struct clk_hw *hw,
>>                 unsigned long parent_rate)
>>  {
>>         struct clk_fixed_factor *fix = to_clk_fixed_factor(hw);
>> +       unsigned long long int rate;
>>
>> -       return parent_rate * fix->mult / fix->div;
>> +       rate = (unsigned long long int)parent_rate * fix->mult;
>> +       do_div(rate, fix->div);
>> +       return (unsigned long)rate;
>>  }
>>
>>  static long clk_factor_round_rate(struct clk_hw *hw, unsigned long rate,
>> --
>> 1.7.10.4
>>
>
> Correct Mike's email address.

Any comments? It's the bug what needs to be fixed.
