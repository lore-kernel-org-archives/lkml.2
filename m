Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab1CCH5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:57:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35730 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1CCH5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:57:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77521031"
Message-ID: <4D6F49D6.3080605@codeaurora.org>
Date: Wed, 02 Mar 2011 23:57:10 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: CONFIG_ARM_DMA_MEM_BUFFERABLE and readl/writel weirdness
References: <4D6D9C03.2080906@codeaurora.org> <201103020923.36796.arnd@arndb.de>
In-Reply-To: <201103020923.36796.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 12:23 AM, Arnd Bergmann wrote:
> On Wednesday 02 March 2011 02:23:15 Saravana Kannan wrote:
>> There are so many other drivers that don't use or care about DMA and
>> might still want to ensure some ordering constraints between their
>> readl(s)/writel(s). They can't depend on readl/writel taking care of it
>> for them since their code could be used in a kernel configuration that
>> doesn't enable this config.
>
> What exactly are the ordering constraints, do you need the full
> dmb() for readl() and dsb() for writel(), or just a compiler barrier?

I wasn't referring to a compiler barrier. I'm referring to one of the 
real barrier instructions.

> I think we need the barrier() even for the relaxed variant, but
> that is fairly lightweight. What would be a reason to have more?

Please see my response to Russell in other other email. I think it 
should answer your question by clarifying my point.

>> Firstly, I don't know how many people noticed this and realize they
>> can't depend on readl/writel to take care of the mb()s for them. Seems
>> like an unnecessary encouragement to make mistakes when it didn't need
>> to be so.
>>
>> Secondly, even if they realize they have to take care of it, they will
>> have to continue using mb()s in to force ordering between their
>> reads/writes. So, are we depending on the compiler to optimize these
>> extra mb() out in the case where the config is enabled? I'm not sure it
>> will be able to optimize out the extra mb()s in all cases.
>
> The compiler certainly won't merge multiple inline assembly statements,
> but multiple barrier() statements don't make it worse than just one.
> barrier() just forces accessing variables from memory that could otherwise
> be kept in registers.

Yes, I was aware of how compiler barriers work and how multiple 
consecutive compiler barriers are the same as one compiler barrier. The 
email was about the real barrier instructions.

> The other problems we still need to fix are the complete absence of
> barriers in inb()/outb() style accessors, which are meant to be stricter
> than readl()/writel(), and the fact that we rely on undefined behavior
> in gcc regarding the atomicity of multi-byte accesses, as we recently
> found out when a new gcc turned a readl into byte accesses.

I haven't gotten that far :-) I really appreciate response!

Thanks,
Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
