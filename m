Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783Ab2EOBIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:08:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17466 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2EOBIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:08:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6711"; a="190922349"
Message-ID: <4FB1AC79.7000901@codeaurora.org>
Date: Mon, 14 May 2012 18:08:09 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Turquette, Mike" <mturquette@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>, andrew@lunn.ch, rnayak@ti.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH] clk: Constify struct clk_init_data
References: <1337004763-21250-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20120514215304.GB3075@gmail.com>
In-Reply-To: <20120514215304.GB3075@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 02:53 PM, Turquette, Mike wrote:
> On Mon, May 14, 2012 at 7:12 AM, Mark Brown<broonie@opensource.wolfsonmicro.com>  wrote:
>> Allow drivers to declare their clk_init_data const, the framework really
>> shouldn't be modifying the data.
>>
>> Signed-off-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
>
> +interested parties
>
> Mark, I like this change but it's reminded me of a few things I meant to
> bring up on the list in the past.  Certainly some folks will mark their
> struct clk_hw_init data as __initconst.  Currently none of the
> documentation mentions that fact and I'm a bit worried about clk code
> which assumes that hw->init will always be around and freely accesses
> it.
>
> I think that, as a rule, hw->init cannot be assumed to be valid after
> clk_register returns.  Would anyone else like to weigh in on it?  If so
> then I'll cook up a follow-up patch to reflect this in the kerneldoc.

If you mean hw->init pointer can't be assumed to be point to anything 
valid after clk_register or __clk_register, then yes, I agree with that. 
But the actual data that hw->init pointed to might still be around and 
referenced by clk if __clk_register is used.

Btw, I didn't follow up on the other thread we were having, but can you 
remind me again what was the reason that you thought that only 
__clk_init() would work for your static init code and __clk_register() 
won't work? Or did I just misunderstand your comment that was trying to 
say that you didn't want to switch to __clk_register close to kernel 
release?

There are some older threads where I think we are a bit out of sync on 
the init data (I thought I did what you said you preferred, but you 
asked me why I did that). I will try to restart them.

Thanks,
Saravana

>
> Thanks,
> Mike
>
>> ---
>>   include/linux/clk-provider.h |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
>> index c1c23b9..fc43ea6 100644
>> --- a/include/linux/clk-provider.h
>> +++ b/include/linux/clk-provider.h
>> @@ -143,7 +143,7 @@ struct clk_init_data {
>>   */
>>   struct clk_hw {
>>         struct clk *clk;
>> -       struct clk_init_data *init;
>> +       const struct clk_init_data *init;
>>   };
>>
>>   /*
>> --
>> 1.7.10
>>
>


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
