Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327Ab2EQHqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:46:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311Ab2EQHqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:46:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120517072450.GC11623@linux-sh.org>
References: <20120517062223.1314.98945.sendpatchset@w520>
	<20120517072450.GC11623@linux-sh.org>
Date: Thu, 17 May 2012 16:46:37 +0900
Message-ID: <CANqRtoQw0MDKpR7zc7t=Pmtmt6qLO0Qcb_jo+CP3Rqx+d-13mA@mail.gmail.com>
Subject: Re: [PATCH][RESEND] gpio: Emma Mobile GPIO driver V2
From: Magnus Damm <magnus.damm@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 4:24 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Thu, May 17, 2012 at 03:22:23PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch is V2 of the Emma Mobile GPIO driver. This
>> driver is designed to be reusable between multiple SoCs
>> that share the same basic building block, but so far it
>> has only been used on Emma Mobile EV2.
>>
>> Each driver instance handles 32 GPIOs with individually
>> maskable IRQs. The driver operates on two I/O memory
>> ranges and the 32 GPIOs are hooked up to two interrupts.
>>
>> In the case of Emma Mobile EV2 this GPIO building block
>> is used as main external interrupt controller hooking up
>> 159 GPIOS as 159 interrupts via 5 driver instances and
>> 10 interrupts to the GIC and the Cortex-A9 Dual.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>
>>  Rafael, can you please pick up?
>>
>>  Changes since V1:
>>  - use inline for private data functions using container_of()
>>  - use BIT(n) instead of 1 << n
>>  - added legacy irq domain support for static mappings
>
> My distaste for arbitrary static mappings aside, it makes no sense to
> support this as a module if the irq domain can't be cleaned up at
> present.

Good idea. I'll send an incremental fix for this. Thanks!

/ magnus
