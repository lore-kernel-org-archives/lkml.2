Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab2KEW2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:28:08 -0500
Received: from smtp181.dfw.emailsrvr.com ([67.192.241.181]:60442 "EHLO
	smtp181.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab2KEW2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:28:06 -0500
Message-ID: <50983D75.50009@calxeda.com>
Date: Mon, 05 Nov 2012 16:28:05 -0600
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6 v2] arm: use devicetree to get smp_twd clock
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1351882309-733-1-git-send-email-mark.langsdorf@calxeda.com> <1351882309-733-2-git-send-email-mark.langsdorf@calxeda.com> <20121104100822.GY21164@n2100.arm.linux.org.uk>
In-Reply-To: <20121104100822.GY21164@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2012 04:08 AM, Russell King - ARM Linux wrote:
> On Fri, Nov 02, 2012 at 01:51:44PM -0500, Mark Langsdorf wrote:
>> -static struct clk *twd_get_clock(void)
>> +static struct clk *twd_get_clock(struct device_node *np)
>>  {
>> -	struct clk *clk;
>> +	struct clk *clk = NULL;
>>  	int err;
>>  
>> -	clk = clk_get_sys("smp_twd", NULL);
>> +	if (np)
>> +		clk = of_clk_get(np, 0);
>> +	if (!clk)
> 
> What does a NULL return from of_clk_get() mean?  Where is this defined?

Well, it's a valid path if (np) is NULL. I'll add an IS_ERR(clk) and
resubmit.

>> @@ -349,6 +348,10 @@ int __init twd_local_timer_register(struct twd_local_timer *tlt)
>>  	if (!twd_base)
>>  		return -ENOMEM;
>>  
>> +	twd_clk = twd_get_clock(NULL);
>> +
>> +	twd_clk = twd_get_clock(NULL);
>> +
> 
> Why twice?

No good reason. I'll resubmit with it cleaned up. Thanks for the review.

--Mark Langsdorf
Calxeda, Inc.

