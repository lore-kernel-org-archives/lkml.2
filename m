Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab2EJKzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:55:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39732 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab2EJKzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:55:02 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-22-4fab9e84f264
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, broonie@opensource.wolfsonmicro.com,
        thomas.abraham@linaro.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/2] mfd: MAX8997: Support irq domain for Maxim MAX8997
Date: Thu, 10 May 2012 19:54:48 +0900
Message-id: <1336647288-10858-1-git-send-email-cw00.choi@samsung.com>
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

But, I posted following patchset related to MAX8997 driver.
This patchset support Extcon framework in extcon-max8997 driver to
control external connector instead of max8997-muic driver. So, first
patch add MAX8997 extcon driver(drivers/extcon/extcon-max8997.c) and
last patch remove old MAX8997 muic driver(drivers/misc/max8997-muic.c).
- https://lkml.org/lkml/2012/5/8/98

This patchset was applied in below git repository of Greg Kroah-Hartman.
- http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=shortlog;h=refs/heads/driver-core-next

I think that this patchset should be applied on the git repository
of Greg Kroah-Hartman to remove possible conflict issue when merged.

Chanwoo Choi (1):
  Extcon: MAX8997: Add support irq domain for MAX8997 muic

Thomas Abraham (1):
  mfd: add irq domain support for max8997 interrupts

 arch/arm/mach-exynos/mach-nuri.c    |    4 --
 arch/arm/mach-exynos/mach-origen.c  |    1 -
 drivers/extcon/extcon-max8997.c     |   26 +++++++++------
 drivers/mfd/max8997-irq.c           |   62 +++++++++++++++++++++--------------
 drivers/mfd/max8997.c               |    1 -
 include/linux/mfd/max8997-private.h |    4 ++-
 include/linux/mfd/max8997.h         |    1 -
 7 files changed, 56 insertions(+), 43 deletions(-)

