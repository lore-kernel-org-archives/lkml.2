Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1JYWBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 18:01:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44090 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab1JYWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 18:01:32 -0400
MIME-Version: 1.0
X-Originating-IP: [85.13.70.251]
In-Reply-To: <4EA73171.5020207@gmail.com>
References: <CAOesGMhqRg29tq5Cw03UQMzGs_6nc3YA9UE6Cvps_0q7h5OeZw@mail.gmail.com>
	<4EA73171.5020207@gmail.com>
Date: Tue, 25 Oct 2011 15:01:31 -0700
Message-ID: <CAOesGMiCvFypQ6MbkTARxH3i3YTgYqSVcUwXe=2tdqSqufXtzg@mail.gmail.com>
Subject: Re: linux-next failure on tegra due to conflicts between PPI and irq
 domain patches and irq.h->module.h include removal
From: Olof Johansson <olof@lixom.net>
To: Rob Herring <robherring2@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        paul.gortmaker@windriver.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 3:00 PM, Rob Herring <robherring2@gmail.com> wrote:
> Olof,
>
> On 10/25/2011 04:48 PM, Olof Johansson wrote:
>> Hi,
>>
>> Looks like Marc added new references to irq_start in his PPI patch,
>> and Rob removed it in parallel. Also, irq_offset is no longer
>> available. Looks like you need to respin your patch, Marc.
>>
>> arch/arm/common/gic.c: In function 'gic_dist_init':
>> arch/arm/common/gic.c:290: error: 'irq_start' undeclared (first use in
>> this function)
>> arch/arm/common/gic.c:290: error: (Each undeclared identifier is
>> reported only once
>> arch/arm/common/gic.c:290: error: for each function it appears in.)
>> arch/arm/common/gic.c:296: error: 'struct gic_chip_data' has no member
>> named 'irq_offset'
>
> I fixed this and sent a pull request yesterday to Arnd.

Ah, oops, forgot to check for already-posted-patches. :) Excellent.


>> The second error is because of the change from Paul that removes
>> module.h from irq.h:
>>
>> arch/arm/common/gic.c: In function 'gic_init':
>> arch/arm/common/gic.c:620: error: 'THIS_MODULE' undeclared (first use
>> in this function)
>>
>> Looks odd that I should need to include module.h on my own just to use
>> irq defines. Paul?
>>
>
> THIS_MODULE is needed by irq.h itself in irq_alloc_descs, so it probably
> needs to be added back.

Well, the new export.h that defines THIS_MODULE probably needs to be
added to irq.h, yes.


-Olof
