Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2LDJh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:37:27 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:57336 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880Ab2LDJhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:37:25 -0500
Message-ID: <50BDC437.1050701@st.com>
Date: Tue, 4 Dec 2012 10:36:55 +0100
From: Armando Visconti <armando.visconti@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "nico@linaro.org" <nico@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] nommu: Enable the strict alignment (CR_A) bit only if
 ARCH < v6
References: <1354187042-28568-1-git-send-email-armando.visconti@st.com> <50BCD6DB.2030200@st.com> <20121203172553.GC14363@n2100.arm.linux.org.uk> <20121203174617.GL20074@mudshark.cambridge.arm.com>
In-Reply-To: <20121203174617.GL20074@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 06:46 PM, Will Deacon wrote:
> On Mon, Dec 03, 2012 at 05:25:53PM +0000, Russell King - ARM Linux wrote:
>> On Mon, Dec 03, 2012 at 05:44:11PM +0100, Armando Visconti wrote:
>>> On 11/29/2012 12:04 PM, Armando VISCONTI wrote:
>>>> This patch keeps disabled the strict alignment CP15 bit for
>>>> all armv6 and armv7 processor without the mmu. This behaviour
>>>> is now same as in the mmu case.
>>>>
>>>> Signed-off-by: Armando Visconti<armando.visconti@st.com>
>>>> ---
>>>>    arch/arm/kernel/head-nommu.S |    2 +-
>>>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
>>>> index 278cfc1..2c228a0 100644
>>>> --- a/arch/arm/kernel/head-nommu.S
>>>> +++ b/arch/arm/kernel/head-nommu.S
>>>> @@ -68,7 +68,7 @@ __after_proc_init:
>>>>    	 * CP15 system control register value returned in r0 from
>>>>    	 * the CPU init function.
>>>>    	 */
>>>> -#ifdef CONFIG_ALIGNMENT_TRAP
>>>> +#if defined(CONFIG_ALIGNMENT_TRAP)&&   __LINUX_ARM_ARCH__<   6
>>>>    	orr	r0, r0, #CR_A
>>>>    #else
>>>>    	bic	r0, r0, #CR_A
>>>
>>> Any feedback on this simple patch?
>>
>> Well, it brings the nommu version into line with the mmu version, so
>> it's sensible.  Please put it in the patch system, thanks.
>

Done!

> In which case, I'll definitely dust-off the patches to prevent unaligned
> accesses to strongly-ordered memory because that results in good ol'
> UNPREDICTABLE behaviour.
>

Yes, we definetely need them.

Thx,
Arm


