Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1GAAne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:43:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36745 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1GAAnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:43:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110630155634.GE3249@opensource.wolfsonmicro.com>
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
	<1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
	<20110630052808.GA796@opensource.wolfsonmicro.com>
	<BANLkTikGR-HdVZ-5h3kW64wiFduuuiU6Vw@mail.gmail.com>
	<20110630055719.GA930@opensource.wolfsonmicro.com>
	<BANLkTin4sCfX1Ahb_Td6VWH28s7SukYN-g@mail.gmail.com>
	<20110630155634.GE3249@opensource.wolfsonmicro.com>
Date: Fri, 1 Jul 2011 09:43:31 +0900
Message-ID: <BANLkTikPOj6N=TQ=tayx7hTXcLAJd5zf7w@mail.gmail.com>
Subject: Re: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>, myungjoo.ham@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 12:56 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jun 30, 2011 at 05:00:13PM +0900, MyungJoo Ham wrote:
>
>> In our code:
>> http://git.infradead.org/users/kmpark/linux-2.6-samsung/blob/eba500212699c0ad8d6bde0dc01c3ec7101f8154:/arch/arm/mach-exynos4/setup-charger.c
>> around line 85, it specifies which interrupt is going to be a
>> wakeup-source ("true"), how the power-managing S/W should interpret
>> them.
>
> This looks like charger specific configuration which should be done by
> the charger driver rather than by directly working with the IRQs?
>

Well, the issue is that the charger driver just does not know what to
do with its own interrupts.

For example, each board has different regulator setting for DCIN
depending on the specification of the board (some uses 450mA
constantly, some uses 450mA and 700mA depending on the connection
information, which is not known to charger driver, some uses 900mA
unconditionally, and so on).

Sometimes setting the attributes of a charger at its own interrupts
depends on the status of another charger; when we have USB charger,
wireless charger, and solar panels, which may be enabled independently
and have their own device drivers.

Scenarios that we are going to support include limiting the aggregated
charging flow, stopping every charger for an error detected at a
single charger (only for really critical ones that imply that the
battery itself has a major issue) as usually only one of the chargers
has sophiscated sensors and controls, and disabling a charger when
others are active (e.g., when CC charging is finished and CV charging
is going on with little current).

In that charger specific configuration and its driver, we are trying
to aggregate multiple chargers (although we specified only two
independent chargers, not three, in that example).


Thanks,
- MyungJoo
-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
