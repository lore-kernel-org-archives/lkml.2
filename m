Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab2GQCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:09:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45907 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab2GQCJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:09:16 -0400
Message-ID: <5004C935.4050707@gmail.com>
Date: Mon, 16 Jul 2012 21:08:53 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>, Shawn Guo <shawn.guo@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>, aletes.xgr@gmail.com
Subject: Re: [PATCH] clk: fix compile for OF && !COMMON_CLK
References: <1342475161-20402-1-git-send-email-robherring2@gmail.com> <20120717001228.GA28886@gmail.com>
In-Reply-To: <20120717001228.GA28886@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 07:12 PM, Mike Turquette wrote:
> On 20120716-16:46, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> With commit 766e6a4ec602d0c107 (clk: add DT clock binding support),
>> compiling with OF && !COMMON_CLK is broken.
>>
> 
> Hi Rob,
> 
> Thanks for sending this quickly.
> 
> <snip>
>> @@ -313,19 +314,19 @@ int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
>>  struct device_node;
>>  struct of_phandle_args;
>>  
>> -#ifdef CONFIG_OF
>> +#if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
>>  struct clk *of_clk_get(struct device_node *np, int index);
>>  struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
>>  struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
>>  #else
>>  static inline struct clk *of_clk_get(struct device_node *np, int index)
>>  {
>> -	return NULL;
>> +	return ERR_PTR(-EINVAL);
> 
> This change seems unrelated?
> 
>>  }
>>  static inline struct clk *of_clk_get_by_name(struct device_node *np,
>>  					     const char *name)
>>  {
>> -	return NULL;
>> +	return ERR_PTR(-EINVAL);
> 
> Ditto.

Yeah, it should probably go in Shawn's fix as that is actually when it
will start breaking.

Rob

> 
> Thanks,
> Mike
> 
>>  }
>>  #endif
>>  
>> -- 
>> 1.7.9.5
>>


