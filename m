Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2FMXK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:10:27 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36639 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2FMXK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:10:26 -0400
Message-ID: <4FD91D99.8050706@linaro.org>
Date: Wed, 13 Jun 2012 16:09:13 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: LKML <linux-kernel@vger.kernel.org>, Arve Hj??nnev??g <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 01/15] ARM: etm: Don't require clock control
References: <1339552887-17204-1-git-send-email-john.stultz@linaro.org> <1339552887-17204-2-git-send-email-john.stultz@linaro.org> <20120613083330.GB27673@linux-sh.org>
In-Reply-To: <20120613083330.GB27673@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061323-3270-0000-0000-00000727292E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 01:33 AM, Paul Mundt wrote:
> On Tue, Jun 12, 2012 at 07:01:19PM -0700, John Stultz wrote:
>> diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
>> index 36d20bd..bd295e8 100644
>> --- a/arch/arm/kernel/etm.c
>> +++ b/arch/arm/kernel/etm.c
>> @@ -362,13 +362,12 @@ static int __devinit etb_probe(struct amba_device *dev, const struct amba_id *id
>>   	if (ret)
>>   		goto out_unmap;
>>
>> +	/* Get optional clock. Currently used to select clock source on omap3 */
>>   	t->emu_clk = clk_get(&dev->dev, "emu_src_ck");
>> -	if (IS_ERR(t->emu_clk)) {
>> +	if (IS_ERR(t->emu_clk))
>>   		dev_dbg(&dev->dev, "Failed to obtain emu_src_ck.\n");
>> -		return -EFAULT;
>> -	}
>> -
>> -	clk_enable(t->emu_clk);
>> +	else
>> +		clk_enable(t->emu_clk);
>>
> Optionally you could just:
>
> 	if (IS_ERR(t->emu_clk))
> 		t->emu_clk = NULL;
>
> and use the clk API as you were, as it does handle NULL being passed in.
>
> In this case you don't have too many callsites to worry about, but it's
> reasonably convenient to be able to pass a NULL clk pointer around
> without constant special-casing when those start to balloon up.
>
Hrm. That's a good trick to remember for the future!

Although in this case I'm not sure it wins much (since the re-adding of 
the braces and the null assignment is still more code then using the 
else).  So unless this is a major style problem for you (and do let me 
know if it is), I'll probably leave it alone.

thanks
-john

