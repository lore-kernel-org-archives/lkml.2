Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab2GBACz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 20:02:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63107 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2GBACy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 20:02:54 -0400
X-AuditID: cbfee61a-b7f086d000000e64-55-4ff0e52a52f9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: thomas.abraham@linaro.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCH 0/2] mfd: MAX8997: Support irq domain for Maxim MAX8997
Date: Mon, 02 Jul 2012 09:02:42 +0900
Message-id: <1341187362-16298-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jAV2tpx/8DZbM4bK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ21c+Yyr4zl3x//AkxgbGzZxdjJwcEgImEs9frWaDsMUkLtxb
	D2RzcQgJLGKUWPD0KjuEs5RJovPpWmaQKjYBLYn9L26AdYgIyEk8uf2HGaSIWeAzo8Tkc+uY
	QBLCAn4St7fdZQGxWQRUJfb9uQzWwCvgKnHhwzmodQoSrcsOsU9g5F7AyLCKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTI9iLz6R2MK5ssDjEKMDBqMTD2/Dkg78Qa2JZcWXuIUYJDmYlEd6n
	x9/7C/GmJFZWpRblxxeV5qQWH2KU5mBREudtsr7gLySQnliSmp2aWpBaBJNl4uCUamDkOBNb
	mG3yt8zivE11F4uc+qyVW49le8rtLb+yKHLrp7XPlVUffT32bfrsyCLVZUr2e3i2TJ58+vCm
	d7uXq89WdVHg1rm2MSL2kux29m9/mDas3J9f/pr9lNMxIUtP79PXThX1HZmjWcQjc+YF77Pp
	98+xnf7F1vx4e9ANH2dzz+mT+Kcs+ztltRJLcUaioRZzUXEiACVACX3eAQAA
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

