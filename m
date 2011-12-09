Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1LIIPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:15:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41529 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903Ab1LIIPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:15:20 -0500
Date: Fri, 9 Dec 2011 16:15:04 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: add irq domain support for max8997 interrupts
Message-ID: <20111209081502.GH26952@opensource.wolfsonmicro.com>
References: <1323361659-11835-1-git-send-email-thomas.abraham@linaro.org>
 <1323361659-11835-2-git-send-email-thomas.abraham@linaro.org>
 <20111209044109.GB26952@opensource.wolfsonmicro.com>
 <CAJuYYwRicSWO=wCmBH5RWcBLX3uhpyxS2wojUS3ZAH9tN=R1Kg@mail.gmail.com>
 <20111209060249.GD26952@opensource.wolfsonmicro.com>
 <CAJuYYwSCuu8U2rF3RGAnczXgbh4Px7hMwUhHr=xrhPZ1jEs5DA@mail.gmail.com>
 <20111209063912.GG26952@opensource.wolfsonmicro.com>
 <CAJuYYwQ8B_EtuReRDJ8Tp-cCOV3jd_-y-9iLy0apRZV3zU6Jdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuYYwQ8B_EtuReRDJ8Tp-cCOV3jd_-y-9iLy0apRZV3zU6Jdw@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 12:49:49PM +0530, Thomas Abraham wrote:
> On 9 December 2011 12:09, Mark Brown

> > How would you provide this interrupt to the device using it in a non-DT
> > systemm without passing the irq_base into the device as platform data?

> In non-DT system, the linux irq number that is used to register the
> gpio interrupt notifier would belong to the irq domain of the host
> interrupt controller (gic). For Exynos, the linux irq numbers that
> belong to the gic irq domain are statically assigned to specific
> interrupt notifiers and known to the entire system.

This seems like it's going to be a bit of a usability issue at best as
users will have to figure out the relevant domain and the offset we end
up with within it, and you appear to be making assumptions about the
system you're running on here.  The way this has been handled for other
drivers is by using irq_alloc_descs with platform data to provide a
default, preserving the old behaviour on non-OF systems.
