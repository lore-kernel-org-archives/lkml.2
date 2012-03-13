Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab2CMIPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:15:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37868 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759087Ab2CMIP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:15:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAJuYYwTKMWgits6xd0UUvRPwr40NwJfO2HncUOW9J=EZbFs8=Q@mail.gmail.com>
References: <1330000688-11226-1-git-send-email-thomas.abraham@linaro.org>
	<1330000688-11226-2-git-send-email-thomas.abraham@linaro.org>
	<20120313032832.655983E07E4@localhost>
	<CAJuYYwTKMWgits6xd0UUvRPwr40NwJfO2HncUOW9J=EZbFs8=Q@mail.gmail.com>
Date: Tue, 13 Mar 2012 13:45:24 +0530
Message-ID: <CAJuYYwSQ-HRBU31=nWyzwqEBxj9LeAMOLQQVcAdf89dO9U0-sQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mfd: add irq domain support for max8997 interrupts
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, k.lewandowsk@samsung.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        kgene.kim@samsung.com, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 March 2012 11:35, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> On 13 March 2012 08:58, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Thu, 23 Feb 2012 18:08:07 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>>> Add irq domain support for max8997 interrupts. The reverse mapping method
>>> used is linear mapping since the sub-drivers of max8997 such as regulator
>>> and charger drivers can use the max8997 irq_domain to get the linux irq
>>> number for max8997 interrupts. All uses of irq_base in platform data and
>>> max8997 driver private data are removed.
>>>
>>> Cc: Grant Likely <grant.likely@secretlab.ca>
>>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>>> ---
>>>  arch/arm/mach-exynos/mach-nuri.c    |    4 --
>>>  arch/arm/mach-exynos/mach-origen.c  |    1 -
>>>  drivers/mfd/max8997-irq.c           |   60 ++++++++++++++++++++--------------
>>>  drivers/mfd/max8997.c               |    1 -
>>>  include/linux/mfd/max8997-private.h |    4 ++-
>>>  include/linux/mfd/max8997.h         |    1 -
>>>  6 files changed, 38 insertions(+), 33 deletions(-)

[...]

>>
>> Hahaha.  The max8997_irqs table is kind of overdone when the group and mask values
>> can be arithmetically derived from the hwirq number..
>
> Yes, I agree. Each group could have maximum of 8 interrupts. Then,
> data->hwirq % 8 will be the group number and data->hwirq & 7 would be

Typo here. group number = data->hwirq >> 3 and mask = data->hwirq & 7.

Thanks,
Thomas.
