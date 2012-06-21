Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab2FUBKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:10:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26063 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2FUBKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:10:39 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-0d-4fe2748da55b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: thomas.abraham@linaro.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/2] mfd: MAX8997: Support irq domain for Maxim MAX8997
Date: Thu, 21 Jun 2012 10:10:34 +0900
Message-id: <1340241034-22223-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAd3ekkf+BvMuK1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M7SufMRV85674f3gSYwPjZs4uRk4OCQETidUTnjJD2GISF+6t
	Z+ti5OIQEljEKHFw0jsmkISQwDImiSVruUFsNgEtif0vbrCB2CICchJPbv9hBmlgFvjMKDH5
	3DqwBmEBd4nm8wvAbBYBVYktO0+zgNi8Aq4Sjx5dYYXYpiDRuuwQ+wRG7gWMDKsYRVMLkguK
	k9JzDfWKE3OLS/PS9ZLzczcxgn34TGoH48oGi0OMAhyMSjy8gkWP/IVYE8uKK3MPMUpwMCuJ
	8C5XAwrxpiRWVqUW5ccXleakFh9ilOZgURLnbbK+4C8kkJ5YkpqdmlqQWgSTZeLglGpgdPTQ
	YP8i580R/CVU/UbubK3cT8kHzVdeqEwMbeE80GTx6+JkM/5Lm4/e2eXaZnWgMef2IosDrAIp
	f87FHvy+Pjl7eiU782OFk1ELJu9RCvfiy2HvXPtmh+7fto09vjL+dRXthleUzHewvVRR/+Pk
	f+fufF2T76onp/A9mXJv1jb/l/XhIj3NSizFGYmGWsxFxYkA2USL790BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add support irq domain for Maxim MAX8997 interrupts.

I have discussed about this patchset with Greg KH and received below reply.
So, I resend this patchset.
- https://lkml.org/lkml/2012/5/20/142

This first patch is based on patch written by Thomas Abraham
(https://lkml.org/lkml/2012/4/18/145) but this patch had occurred
build break, it was reported by Stephen Rothwell and this patch was
reverted by Mark Brown. You can check reverted patch on below patch.
- http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commit;h=82b719b11fd750188c125078ad6a6c0d23219dfb
So I fix two bug which set max88997->irq_domain instead
of NULL pointer and correct wrong parameter.

The second patch use irq domain for muic interrupt of extcon-max8997
instead of irq_base in platform data of MAX8997 driver.

Chanwoo Choi (1):
  Extcon: MAX8997: Add support irq domain for MAX8997 muic

Thomas Abraham (1):
  mfd: add irq domain support for max8997 interrupts

 arch/arm/mach-exynos/mach-nuri.c    |    4 --
 arch/arm/mach-exynos/mach-origen.c  |    1 -
 drivers/extcon/Kconfig              |    2 +-
 drivers/extcon/extcon-max8997.c     |   29 ++++++++++------
 drivers/mfd/Kconfig                 |    1 +
 drivers/mfd/max8997-irq.c           |   62 +++++++++++++++++++++--------------
 drivers/mfd/max8997.c               |    1 -
 include/linux/mfd/max8997-private.h |    4 ++-
 include/linux/mfd/max8997.h         |    1 -
 9 files changed, 60 insertions(+), 45 deletions(-)

