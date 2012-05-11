Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab2EKBKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 21:10:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64859 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab2EKBKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 21:10:08 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-e6-4fac66ee9b1f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, broonie@opensource.wolfsonmicro.com,
        thomas.abraham@linaro.org
Cc: grant.likely@secretlab.ca, sameo@linux.intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, jonghwa3.lee@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v2 0/2] mfd: MAX8997: Support irq domain for Maxim MAX8997
Date: Fri, 11 May 2012 10:09:54 +0900
Message-id: <1336698594-10837-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add support irq domain for Maxim MAX8997 interrupts.

The first patch is based on patch written by Thomas Abraham and fix
two bug which set max8997->irq_domain instead of NULL pointer and
correct wrong parameter by Chanwoo Choi.
- https://lkml.org/lkml/2012/4/18/145
The second patch use irq domain for MAX8997 muic interrupt instead
of irq_base in platform data of MAX8997 driver.

I do explain the history of this patchset. The below patch was written
by Thomas Abraham and it was applied on regulator.git repository.
- http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commit;h=98d8618af37728f6e18e84110ddb99987b47dd12
But, this patch had occurred build break, it was reported by Stephen
Rothwell when build max8997-muic driver(drivers/misc/max8997-muic.c) and
then this patch was reverted by Mark Brown. You can check reverted patch
on below patch.
- http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commit;h=82b719b11fd750188c125078ad6a6c0d23219dfb

Then, I post this patchset which is based on patch written by Thomas Abraham
to add support irq domain for Max MAX8997 interrupts with bug fix. Also, I had
to modify max8997-muic driver to avoid build break.

But,I posted following patchset related to MAX8997 driver. The below patchset
support Extcon framework in extcon-max8997 driver to control external connector
instead of max8997-muic driver. So, first patch add MAX8997 extcon driver
(drivers/extcon/extcon-max8997.c) and last patch remove old MAX8997 muic
driver(drivers/misc/max8997-muic.c).
- https://lkml.org/lkml/2012/5/8/98
The patchset which add extcon-max8997 driver was applied in below
git repository of Greg Kroah-Hartman.
- http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=shortlog;h=refs/heads/driver-core-next

So, I think that this patchset should be applied on the git reposity
of Greg to remove possible conflict issue when merged because old max8997-muic
driver(drivers/misc/max8997-muic.c) is existed on regulator.git of Mark
Brown.

Chanwoo Choi (1):
  Extcon: MAX8997: Add support irq domain for MAX8997 muic

Thomas Abraham (1):
  mfd: add irq domain support for max8997 interrupts

 arch/arm/mach-exynos/mach-nuri.c    |    4 --
 arch/arm/mach-exynos/mach-origen.c  |    1 -
 drivers/extcon/extcon-max8997.c     |   28 +++++++++------
 drivers/mfd/max8997-irq.c           |   62 +++++++++++++++++++++--------------
 drivers/mfd/max8997.c               |    1 -
 include/linux/mfd/max8997-private.h |    4 ++-
 include/linux/mfd/max8997.h         |    1 -
 7 files changed, 57 insertions(+), 44 deletions(-)

