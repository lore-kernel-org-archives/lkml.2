Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1DGB13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 21:27:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50997 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1DGB12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 21:27:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6308"; a="84193758"
Message-ID: <4D9D12FD.6060608@codeaurora.org>
Date: Wed, 06 Apr 2011 18:27:25 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mattias Wallin <mattias.wallin@stericsson.com>
CC: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5 1/3] ARM: Translate delay.S into (mostly) C
References: <1302047800-26720-1-git-send-email-sboyd@codeaurora.org>	<1302047800-26720-2-git-send-email-sboyd@codeaurora.org> <4D9C2910.6020309@stericsson.com>
In-Reply-To: <4D9C2910.6020309@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 01:49 AM, Mattias Wallin wrote:
> On 04/06/2011 01:56 AM, Stephen Boyd wrote:
>> +void __udelay(unsigned long usecs)
>> +{
>> + __const_udelay(usecs * ((2199023*HZ)>>11));
> This will overflow if HZ=1000.
> If I remember correct I fixed it like this:
> __const_udelay(usecs * ((2199023UL*HZ)>>11));
>
> /Mattias Wallin
>

Mattias,

Isn't this a big in the existing code too? I would prefer not combining 
that with this patch series. That bug should be fixed before/after this 
patch series. Not as part of it.

I would vote for after this patch series since this patch series has 
been trying to get in for quite a while now.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
