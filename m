Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab1F3F4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:56:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59079 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1F3F42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:56:28 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20110630052808.GA796@opensource.wolfsonmicro.com>
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
	<1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
	<20110630052808.GA796@opensource.wolfsonmicro.com>
Date: Thu, 30 Jun 2011 14:56:27 +0900
X-Google-Sender-Auth: o3R5XLTubwafU3goXOaGRUezliY
Message-ID: <BANLkTikGR-HdVZ-5h3kW64wiFduuuiU6Vw@mail.gmail.com>
Subject: Re: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 2:28 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jun 30, 2011 at 10:31:47AM +0900, MyungJoo Ham wrote:
>> IRQ definitions are needed to be accessed by board support package codes
>> as well. Because they are not only used by MAX8997 MFD device drivers,
>> this patch pulls such definitions out of private header, which is meant
>> for MAX8997 MFD device drivers.
>
> Why is this needed?
>

In order to request MAX8997's IRQs, these IRQ enums are required by
board files (such as /arch/arm/mach-exynos4/mach-*.c). So, these IRQ
enums are no more "private" to max8997 device drivers. Without this
patch, board files need to include max8997-private.h.

It works properly with or without the patch. The patch is only for
some aesthetics reasons.

However, this max8997-private.h was meant to be included by device
drivers of MAX8997-MFD (such as MAX8997-PMIC, MAX8997-RTC,
MAX8997-IRQ, ...); thus, including that private header at board files
(or any other non-max8997 device drivers) didn't look "proper". If
these "private" MFD headers are to be included by non "subdevices" of
the same MFD, it is meaningless to seperate into two headers
(max8997.h and max8997-private.h) and we'd better merge public and
private headers of MFDs.


Cheers!

- MyungJoo
-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
