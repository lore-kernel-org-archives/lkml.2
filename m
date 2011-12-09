Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab1LIHTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 02:19:51 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45218 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab1LIHTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 02:19:50 -0500
MIME-Version: 1.0
In-Reply-To: <20111209063912.GG26952@opensource.wolfsonmicro.com>
References: <1323361659-11835-1-git-send-email-thomas.abraham@linaro.org>
	<1323361659-11835-2-git-send-email-thomas.abraham@linaro.org>
	<20111209044109.GB26952@opensource.wolfsonmicro.com>
	<CAJuYYwRicSWO=wCmBH5RWcBLX3uhpyxS2wojUS3ZAH9tN=R1Kg@mail.gmail.com>
	<20111209060249.GD26952@opensource.wolfsonmicro.com>
	<CAJuYYwSCuu8U2rF3RGAnczXgbh4Px7hMwUhHr=xrhPZ1jEs5DA@mail.gmail.com>
	<20111209063912.GG26952@opensource.wolfsonmicro.com>
Date: Fri, 9 Dec 2011 12:49:49 +0530
Message-ID: <CAJuYYwQ8B_EtuReRDJ8Tp-cCOV3jd_-y-9iLy0apRZV3zU6Jdw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: add irq domain support for max8997 interrupts
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 December 2011 12:09, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Dec 09, 2011 at 12:00:07PM +0530, Thomas Abraham wrote:
>
>> If these gpio's are connected to the host system, and host system sets
>> up gpio interrupt notification for these gpio lines, the linux irq
>> number for the gpio interrupt would belong to the irq domain of the
>> host interrupt controller (gic irq domain in case of exynos).
>> Consumers of this interrupt would use the gpio interrupt independent
>> of the max8997 irq domain. So irq_base can be maintained private to
>> the max8997 mfd driver and its sub-block drivers.
>
> How would you provide this interrupt to the device using it in a non-DT
> systemm without passing the irq_base into the device as platform data?

In non-DT system, the linux irq number that is used to register the
gpio interrupt notifier would belong to the irq domain of the host
interrupt controller (gic). For Exynos, the linux irq numbers that
belong to the gic irq domain are statically assigned to specific
interrupt notifiers and known to the entire system.

For instance, the linux virq number for gpio interrupt for the gpio
connected from max8997 to Exynos GPIO (hypothetical case) would be
statically defined as GPIO_EINT_MAX8997_GPIO0. The device that
requires to be notified of this interrupt would request_irq or
setup_irq using this macro and hence needs no knowledge of the
irq_base of the max8997 irq domain.

If the system uses sparse irqs, or if static mapping of linux virq's
are not possible in a system, that is a problem that this patch does
not address. irq_domain of max8997 is self contained to provide all
max8997 linux irq numbers required by the sub-block drivers of
max8997.

Thanks,
Thomas.
