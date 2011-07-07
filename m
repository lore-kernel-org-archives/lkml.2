Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1GGRoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:44:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63843 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1GGRoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:44:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6400"; a="102189167"
Message-ID: <4E15F082.7080604@codeaurora.org>
Date: Thu, 07 Jul 2011 10:44:34 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCHv2] arm: mm: Poison freed init memory
References: <20110706210106.GX8286@n2100.arm.linux.org.uk> <1310057247-4933-1-git-send-email-sboyd@codeaurora.org> <20110707173645.GD20403@n2100.arm.linux.org.uk>
In-Reply-To: <20110707173645.GD20403@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 10:36 AM, Russell King - ARM Linux wrote:
> On Thu, Jul 07, 2011 at 09:47:27AM -0700, Stephen Boyd wrote:
>> Poisoning __init marked memory can be useful when tracking down
>> obscure memory corruption bugs. Therefore, poison init memory
>> with 0xe7fddef0 to catch bugs earlier. The poison value is an
>> undefined instruction in ARM mode and branch to an undefined
>> instruction in Thumb mode.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>
>> On 7/6/2011 2:01 PM, Russell King - ARM Linux wrote:
>>> On Wed, Jul 06, 2011 at 01:55:54PM -0700, Stephen Boyd wrote:
>>>> Should it include the initrd too? At least x86 poisons that memory but I
>>>> don't know who would be using that incorrectly.
>>> It could do - I don't see any harm in not doing so.  The only issue
>>> is that people may want to disable this stuff if they're after
>>> squeezing every last ms out of the boot time.
>> I haven't done this. I hope a follow up patch will suffice.
>>
>>>> How about a free_init_area() function which calls free_area() after
>>>> poisoning the memory?
>>> I need to go back and look at the Integrator etc situation with regard
>>> to reorganizing the vmlinux layout - it may be that the omission of
>>> freeing .init memory can now be removed (it was there to stop the
>>> memory being used as the first K of memory wasn't DMA-able.)
>>>
>>> Assuming it has to stay though, we still should arrange for the initrd
>>> memory to be poisoned even if it isn't freed.
>> Is this is patch what you're saying? I would have liked to do a
>> free_init_area() wrapper, but until the Integrator situation can be
>> sorted it doesn't look worthwhile.
> Yes, thanks.  This looks fine for the time being.  Have you been able
> to test it?  If yes, then please put it in the patch system and I'll
> see about giving it a test too.

Yes it's been tested (which is why there is a PAGE_ALIGN on initrd).

6996/1

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

