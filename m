Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab1LIFZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 00:25:13 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65067 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1LIFZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 00:25:11 -0500
MIME-Version: 1.0
In-Reply-To: <20111209044109.GB26952@opensource.wolfsonmicro.com>
References: <1323361659-11835-1-git-send-email-thomas.abraham@linaro.org>
	<1323361659-11835-2-git-send-email-thomas.abraham@linaro.org>
	<20111209044109.GB26952@opensource.wolfsonmicro.com>
Date: Fri, 9 Dec 2011 10:55:10 +0530
Message-ID: <CAJuYYwRicSWO=wCmBH5RWcBLX3uhpyxS2wojUS3ZAH9tN=R1Kg@mail.gmail.com>
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

Hi Mark,

On 9 December 2011 10:11, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Dec 08, 2011 at 09:57:38PM +0530, Thomas Abraham wrote:
>
> You should be sending this to Samuel for review as it's a MFD patch.

Ok. I will Cc Samuel for the v2 of this patchset.

>
>> Add irq domain support for max8997 interrupts. All uses of irq_base in platform
>> data and max8997 driver private data are removed.
>
> Removing irq_base from platform data isn't going to be helpful for
> anyone using the driver on non-DT platforms as it's going to make it
> impossible to find the interrupts.

All the consumers of the max8997 interrupts are the drivers for the
sub-blocks of max8997. These drivers have access to 'irq_domain'
member of 'struct max8997_dev', From irq_domain, the sub-block driver
can get the irq_base and add one of the 'enum max8997_irq' offset when
registering for interrupt notifications.

So irq_base from platform data and all uses of it was removed. All
max8997 sub-block drivers should use the irq_base of the irq_domain.

Thanks for your review.

Regards,
Thomas.
