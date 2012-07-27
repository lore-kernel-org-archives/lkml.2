Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2G0M4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:56:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25059 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab2G0M4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:56:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6784"; a="212808743"
Message-ID: <50128FE6.5070109@codeaurora.org>
Date: Fri, 27 Jul 2012 08:56:06 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 02/24] xen/arm: hypercalls
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>	 <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>	 <50119856.2020206@codeaurora.org> <1343380764.6812.108.camel@zakaz.uk.xensource.com>
In-Reply-To: <1343380764.6812.108.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 05:19 AM, Ian Campbell wrote:
> On Thu, 2012-07-26 at 20:19 +0100, Christopher Covington wrote:
>> Hi Stefano,
>>
>> On 07/26/2012 11:33 AM, Stefano Stabellini wrote:
>>> Use r12 to pass the hypercall number to the hypervisor.
>>>
>>> We need a register to pass the hypercall number because we might not
>>> know it at compile time and HVC only takes an immediate argument.
>>
>> You're not going to JIT assemble the appropriate HVC instruction? Darn.
> 
> ;-)
> 
>> How many call numbers are there, though? 8?
> 
> The maximum currently defined hypercall number is 55, although there are
> some small gaps so there's actually more like 45 in total.
> 
>>  It seems like it'd be
>> reasonable to take the approach that seems to be favored for MRC/MCR
>> instructions, using a function containing switch statement that chooses
>> between several inline assembly instructions based off an enum passed to
>> the function. See for example arch_timer_reg_read in
>> arch/arm/kernel/arch_timer.c.
> 
> I don't think it is feasible with this number of hypercalls, even
> accepting that in many cases the number will be a constant so gcc can
> likely optimise almost all of it away.
> 
> Is there something wrong with the r12 based approach?

Only that you're defining a custom interface for something that there is
a potentially more standard interface for. I just wanted to double check
that all the ways of using the potentially more standard interface had
been explored and found to be unreasonable.

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
