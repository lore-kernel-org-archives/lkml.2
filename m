Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab2LCR3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:29:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53925 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab2LCR3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:29:17 -0500
Date: Mon, 3 Dec 2012 17:25:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Armando Visconti <armando.visconti@st.com>
Cc: "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] nommu: Enable the strict alignment (CR_A) bit only if
	ARCH < v6
Message-ID: <20121203172553.GC14363@n2100.arm.linux.org.uk>
References: <1354187042-28568-1-git-send-email-armando.visconti@st.com> <50BCD6DB.2030200@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BCD6DB.2030200@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 05:44:11PM +0100, Armando Visconti wrote:
> On 11/29/2012 12:04 PM, Armando VISCONTI wrote:
>> This patch keeps disabled the strict alignment CP15 bit for
>> all armv6 and armv7 processor without the mmu. This behaviour
>> is now same as in the mmu case.
>>
>> Signed-off-by: Armando Visconti<armando.visconti@st.com>
>> ---
>>   arch/arm/kernel/head-nommu.S |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
>> index 278cfc1..2c228a0 100644
>> --- a/arch/arm/kernel/head-nommu.S
>> +++ b/arch/arm/kernel/head-nommu.S
>> @@ -68,7 +68,7 @@ __after_proc_init:
>>   	 * CP15 system control register value returned in r0 from
>>   	 * the CPU init function.
>>   	 */
>> -#ifdef CONFIG_ALIGNMENT_TRAP
>> +#if defined(CONFIG_ALIGNMENT_TRAP)&&  __LINUX_ARM_ARCH__<  6
>>   	orr	r0, r0, #CR_A
>>   #else
>>   	bic	r0, r0, #CR_A
>
> Any feedback on this simple patch?

Well, it brings the nommu version into line with the mmu version, so
it's sensible.  Please put it in the patch system, thanks.
