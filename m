Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794Ab2EOBTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:19:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44993 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755Ab2EOBTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:19:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6711"; a="190924912"
Message-ID: <4FB1AF14.3050507@codeaurora.org>
Date: Mon, 14 May 2012 18:19:16 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Turquette, Mike" <mturquette@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>, andrew@lunn.ch, rnayak@ti.com
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

Oh, wait. This won't work for the case where the clock registration is 
completely dynamic. Say, created from device tree or thru some PCI/USB 
device probe, etc. That's why I didn't add it before.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
