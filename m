Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab2GXKmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 06:42:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56778 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab2GXKmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 06:42:07 -0400
Message-ID: <500E7BF2.9030305@ti.com>
Date: Tue, 24 Jul 2012 06:41:54 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [RFC 00/23] Introducing the TI Keystone platform
References: <1343092165-9470-1-git-send-email-cyril@ti.com> <20120724090841.GA16435@mudshark.cambridge.arm.com>
In-Reply-To: <20120724090841.GA16435@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 7/24/2012 5:08 AM, Will Deacon wrote:
> Hi Cyril,
>
> Thanks for this, certainly looks like an interesting platform!
>
> Of course, in order to perform any sort of sensible review, I'll need some
> silicon to test it on :)
>

We have (so far) been testing this on software simulators, and we have 
an earlier version of this code booting up on an FPGA based emulation 
platform.

> On Tue, Jul 24, 2012 at 02:09:02AM +0100, Cyril Chemparathy wrote:
>> TI's scalable KeyStone II architecture includes support for both TMS320C66x
>> floating point DSPs and ARM Cortex-A15 clusters, for a mixture of up to 32
>> cores per SoC.  The solution is optimized around a high performance chip
>> interconnect and a rich set of on chip peripherals.  Please refer [1] for
>> initial technical documentation on these devices.
>
> How many A15s can you have on such a SoC? It wasn't clear whether it was 1x4
> or 4x4 from the documentation.
>

This device has a single cluster of 4 A15s.

>> This patch series provides a basic Linux port for these devices, including
>> support for SMP, and LPAE boot.  A majority of the patches in this series are
>> related to LPAE functionality, imposed by the device architecture which has
>> system memory mapped at an address above the 4G 32-bit addressable limit.
>
> I assume you have *some* memory in the bottom 32-bits though, right? Even if
> it's just a partial alias of a higher bank.
>

Yes, there is a boot time alias of the initial part of memory in the 
32-bit space.  But this alias is somewhat limited in capabilities, and 
therefore we do not intend to use it much beyond boot.

>> This patch series is based on the v3.5 kernel with the smp_ops patch set
>> applied on top.  This series is being posted to elicit early feedback, and so
>> that some of these fixes may get incorporated early on into the kernel code.
>>
>>    [1] - http://www.ti.com/product/tms320tci6636
>
> This is marked as `TI confidential' but I guess that's an oversight [or will
> you have to kill me?].
>

:-)  That is an oversight, I'm sure.

> Will
>

-- 
Thanks
- Cyril
