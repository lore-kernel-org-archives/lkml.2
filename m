Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0LHUYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:24:08 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25153 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab0LHUYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:24:05 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6191"; a="65828249"
Message-ID: <4CFFE965.30906@codeaurora.org>
Date: Wed, 08 Dec 2010 12:24:05 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Arve Hj?nnev?g <arve@android.com>
Subject: Re: [PATCHv3 2/4] ARM: Allow machines to override __delay()
References: <1291783128-27520-1-git-send-email-sboyd@codeaurora.org>	 <1291783128-27520-3-git-send-email-sboyd@codeaurora.org> <1291836162.12568.17.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1291836162.12568.17.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 11:22 AM, Daniel Walker wrote:
> On Tue, 2010-12-07 at 20:38 -0800, Stephen Boyd wrote:
>> +
>> +static void (*delay_fn)(unsigned long) = delay_loop;
>> +
>> +void set_delay_fn(void (*fn)(unsigned long))
>> +{
>> +       delay_fn = fn;
>> +}
>> +
>> +/*
>> + * loops = usecs * HZ * loops_per_jiffy / 1000000
>> + */
>> +void __delay(unsigned long loops)
>> +{
>> +       delay_fn(loops);
>> +}
>>  EXPORT_SYMBOL(__delay);
> Didn't we already go over this part ? Why are aren't you putting these
> in a header file ?

Last time we saw that inlining set_delay_fn() actually increased the
text size of the kernel. I know it sounds wrong, but its probably due to
that compiler behavior Russell posted about last month on arm-lkml.

I'd like to see what Russell wants to do since so far he's been silent
on this whole series.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

