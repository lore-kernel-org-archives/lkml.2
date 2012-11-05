Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab2KEOtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:49:22 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56603 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2KEOtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:49:18 -0500
Message-ID: <5097D1E8.2000403@gmail.com>
Date: Mon, 05 Nov 2012 08:49:12 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: Josh Cartwright <josh.cartwright@ni.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/8] ARM: zynq: move ttc timer code to drivers/clocksource
References: <cover.1351721190.git.josh.cartwright@ni.com> <c0347788fbad559a249a25128a23f40c85d9cbda.1351721190.git.josh.cartwright@ni.com> <CAHTX3d++0fGSw7GQHcc-S1X1Qh-rfekpr-E8Jkg2_vFqdCFFTg@mail.gmail.com>
In-Reply-To: <CAHTX3d++0fGSw7GQHcc-S1X1Qh-rfekpr-E8Jkg2_vFqdCFFTg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/05/2012 05:22 AM, Michal Simek wrote:
> 2012/10/29 Josh Cartwright <josh.cartwright@ni.com>:
>> Suggested cleanup by Arnd Bergmann.  Move the ttc timer.c code to
>> drivers/clocksource, and out of the mach-zynq directory.
>>
>> The common.h (which only held the timer declaration) was renamed to
>> xilinx_ttc.h and moved into include/linux.
>>
>> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  arch/arm/mach-zynq/Makefile                                    | 2 +-
>>  arch/arm/mach-zynq/common.c                                    | 2 +-
>>  drivers/clocksource/Makefile                                   | 1 +
>>  arch/arm/mach-zynq/timer.c => drivers/clocksource/xilinx_ttc.c | 1 -
>>  arch/arm/mach-zynq/common.h => include/linux/xilinx_ttc.h      | 4 ++--
>>  5 files changed, 5 insertions(+), 5 deletions(-)
>>  rename arch/arm/mach-zynq/timer.c => drivers/clocksource/xilinx_ttc.c (99%)
>>  rename arch/arm/mach-zynq/common.h => include/linux/xilinx_ttc.h (91%)
> 
> Not going to apply this patch till there is clean way how to move all
> drivers there.
> Especially I don't like to add xilinx_ttc.h to include/linux folder.
> 

A cleaner way is how we are doing irqchips [1]. This needs a single
function (or one each for clksrc and clkevt) that has a DT match list of
all known timers and calls their init function. It should be a bit
simpler than irqchips init function because you don't need to worry
about hierarchy init ordering. That doesn't solve non-DT though and if
there are any extra functions like we have with irqchips, you still need
the header in include/linux.

Rob

[1] http://www.spinics.net/lists/arm-kernel/msg203687.html
