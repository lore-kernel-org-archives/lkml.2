Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0KDU6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:58:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41299 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0KDU6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:58:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6157"; a="60601735"
Message-ID: <4CD31E67.60107@codeaurora.org>
Date: Thu, 04 Nov 2010 13:58:15 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Colin Cross <ccross@android.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCHv2 2/3] ARM: Allow machines to override __delay()
References: <1288300770-18350-1-git-send-email-sboyd@codeaurora.org>	 <1288300770-18350-3-git-send-email-sboyd@codeaurora.org> <1288899002.21823.3.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1288899002.21823.3.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 12:30 PM, Daniel Walker wrote:
> On Thu, 2010-10-28 at 14:19 -0700, Stephen Boyd wrote:
>> +
>> +static void (*delay_fn)(unsigned long) = delay_loop;
>> +
>> +void set_delay_fn(void (*fn)(unsigned long))
>> +{
>> +       delay_fn = fn;
>> +}
>
> This needs to be a static inline in the header file.

Wouldn't that mean delay_fn needs to be exposed in the header file too?
I like the fact that it's static and scoped to this file.

>> +/*
>> + * loops = usecs * HZ * loops_per_jiffy / 1000000
>> + */
>> +void __delay(unsigned long loops)
>> +{
>> +       delay_fn(loops);
>> +}
>>  EXPORT_SYMBOL(__delay);
>
> Can we make this static inline also? I'm sure about the module issues..

Do you mean in the header file or in this file?

I think it won't work because there actually needs to be a __delay
symbol and it can't just be inlined away at all the call sites.


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

