Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1F2OGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:06:52 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6271 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1F2OGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:06:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 29 Jun 2011 07:06:49 -0700
From: Jin Park <jinyoungp@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, Jin Park <jinyoungp@nvidia.com>
Subject: Re: [PATCH 0/3] aat2870: Adding mfd, backlight and regulator drivers
Date: Wed, 29 Jun 2011 23:06:49 +0900
Message-Id: <1309356412-23881-1-git-send-email-jinyoungp@nvidia.com>
X-Mailer: git-send-email 1.7.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing subject because the patch was separated.
Adding relevant maintainers for backlight and regulator.

Hi Samuel,

> Before reviewing this patch, could you please do the following:
> 
> 1) Split it into 3 actual patches: the MFD one, the regulator one and the
> backlight one.
I have separated the patch to mfd, backlight and regulator.

> 2) Add the relevant maintainers (See MAINTAINERS) if you want to get a proper
> regulator and backlight driver review.
I submitting the patches with relevant maintainers.

> You also need to take the io_lock mutex here, to prevent someone else to write
> a different value to your register between your read and write.
> So what you typically want is an unlocked version of aat2870_[read|write]
> (let's say we call it __aat2870_[read|write]). Then your aat2870_[read|write]
> become wrappers around the __aat2870_[read|write] with the lock taken. And
> your update_bits routine can use __aat2870_[read|write] with the lock taken
> from the beginning.
I have modified mfd driver according to your comment.

Thanks,
Jin.

Jin Park (3):
  mfd: aat2870: Add AAT2870 mfd driver
  backlight: aat2870: Add AAT2870 backlight driver
  regulator: aat2870: Add AAT2870 regulator driver

 drivers/mfd/Kconfig                   |   10 +
 drivers/mfd/Makefile                  |    1 +
 drivers/mfd/aat2870-core.c            |  534 +++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig             |    7 +
 drivers/regulator/Makefile            |    1 +
 drivers/regulator/aat2870-regulator.c |  264 ++++++++++++++++
 drivers/video/backlight/Kconfig       |    7 +
 drivers/video/backlight/Makefile      |    1 +
 drivers/video/backlight/aat2870_bl.c  |  246 +++++++++++++++
 include/linux/mfd/aat2870.h           |  181 +++++++++++
 10 files changed, 1252 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/aat2870-core.c
 create mode 100644 drivers/regulator/aat2870-regulator.c
 create mode 100644 drivers/video/backlight/aat2870_bl.c
 create mode 100644 include/linux/mfd/aat2870.h

