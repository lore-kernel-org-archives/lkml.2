Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab1ADAe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 19:34:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17003 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1ADAeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 19:34:25 -0500
Message-ID: <4D226AF8.1010102@oracle.com>
Date: Tue, 04 Jan 2011 08:34:00 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: jeremy@goop.org, xen-devel@lists.xensource.com, ian.campbell@citrix.com,
        gurudas.pai@oracle.com, guru.anbalagane@oracle.com,
        greg.marsden@oracle.com, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [patch] xenfb: fix xenfb suspend/resume race
References: <20101230125616.GA31537@joejin-pc.cn.oracle.com> <20101230164051.GC24313@dumpdata.com> <4D1D2A2D.80206@oracle.com> <20110103163418.GA14102@dumpdata.com>
In-Reply-To: <20110103163418.GA14102@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/11 00:34, Konrad Rzeszutek Wilk wrote:
>>> I am unclear from your description whether the patch fixes
>>> the problem (I would presume so). Or does it take a long time
>>> to hit this race?
>>>
>> Yes, more than 100 migrations. we hit this issue around 3 times.
> 
> OK, so you are still trying to find the culprit.
> 
> Did you look at this patch from Ian:
> 
> https://patchwork.kernel.org/patch/403192/

We have reproduced the issue with the patch.

> 
> ?
>>
>> I dumped vmcore when guest crashed, from vmcore everything
>> looked good, fb_info, xenfb_info and so on.
> 
> And the event channels are correct?
> 
> .. snip..
>> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
>> index ac7b42f..4cfb5e2 100644
>> --- a/drivers/xen/events.c
>> +++ b/drivers/xen/events.c
>> @@ -175,6 +175,8 @@ static struct irq_info *info_for_irq(unsigned irq)
>>  
>>  static unsigned int evtchn_from_irq(unsigned irq)
>>  {
>> +	if (unlikely(irq < 0 || irq >= nr_irqs))
>> +		return 0;
> 
> You could insert a WARN_ON here to see see if you get this during your
> migration process.
> 
> Or use xen_raw_printk in case the guest is hung for good.
> 

Thanks for your advice, will try it.
