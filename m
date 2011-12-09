Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab1LIGaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 01:30:09 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40828 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1LIGaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 01:30:08 -0500
MIME-Version: 1.0
In-Reply-To: <20111209060249.GD26952@opensource.wolfsonmicro.com>
References: <1323361659-11835-1-git-send-email-thomas.abraham@linaro.org>
	<1323361659-11835-2-git-send-email-thomas.abraham@linaro.org>
	<20111209044109.GB26952@opensource.wolfsonmicro.com>
	<CAJuYYwRicSWO=wCmBH5RWcBLX3uhpyxS2wojUS3ZAH9tN=R1Kg@mail.gmail.com>
	<20111209060249.GD26952@opensource.wolfsonmicro.com>
Date: Fri, 9 Dec 2011 12:00:07 +0530
Message-ID: <CAJuYYwSCuu8U2rF3RGAnczXgbh4Px7hMwUhHr=xrhPZ1jEs5DA@mail.gmail.com>
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

On 9 December 2011 11:32, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Dec 09, 2011 at 10:55:10AM +0530, Thomas Abraham wrote:
>> On 9 December 2011 10:11, Mark Brown
>
>> > Removing irq_base from platform data isn't going to be helpful for
>> > anyone using the driver on non-DT platforms as it's going to make it
>> > impossible to find the interrupts.
>
>> All the consumers of the max8997 interrupts are the drivers for the
>> sub-blocks of max8997. These drivers have access to 'irq_domain'
>> member of 'struct max8997_dev', From irq_domain, the sub-block driver
>> can get the irq_base and add one of the 'enum max8997_irq' offset when
>> registering for interrupt notifications.
>
> There's no GPIOs with interrupt support (even if they're not implemented
> yet)?

Ok. There does seem to be 12 gpios supported by max8997, but not used
on the origen board.

If these gpio's are connected to the host system, and host system sets
up gpio interrupt notification for these gpio lines, the linux irq
number for the gpio interrupt would belong to the irq domain of the
host interrupt controller (gic irq domain in case of exynos).
Consumers of this interrupt would use the gpio interrupt independent
of the max8997 irq domain. So irq_base can be maintained private to
the max8997 mfd driver and its sub-block drivers.

Thanks,
Thomas.
