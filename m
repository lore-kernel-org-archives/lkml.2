Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab1F3IAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:00:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33745 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1F3IAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110630055719.GA930@opensource.wolfsonmicro.com>
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
	<1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
	<20110630052808.GA796@opensource.wolfsonmicro.com>
	<BANLkTikGR-HdVZ-5h3kW64wiFduuuiU6Vw@mail.gmail.com>
	<20110630055719.GA930@opensource.wolfsonmicro.com>
Date: Thu, 30 Jun 2011 17:00:13 +0900
Message-ID: <BANLkTin4sCfX1Ahb_Td6VWH28s7SukYN-g@mail.gmail.com>
Subject: Re: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 2:57 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jun 30, 2011 at 02:56:27PM +0900, MyungJoo Ham wrote:
>
>> In order to request MAX8997's IRQs, these IRQ enums are required by
>> board files (such as /arch/arm/mach-exynos4/mach-*.c). So, these IRQ
>> enums are no more "private" to max8997 device drivers. Without this
>> patch, board files need to include max8997-private.h.
>
> Why does the board file need to request these IRQs?
>


It specifies which interrupts of MAX8997 are used.

In our code:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/blob/eba500212699c0ad8d6bde0dc01c3ec7101f8154:/arch/arm/mach-exynos4/setup-charger.c
around line 85, it specifies which interrupt is going to be a
wakeup-source ("true"), how the power-managing S/W should interpret
them.

The interrupts not listed in the array are not used as a wakeup-source.

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
