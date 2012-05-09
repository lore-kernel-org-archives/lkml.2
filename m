Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab2EIDbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 23:31:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26887 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2EIDby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 23:31:54 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-90-4fa9e5283729
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, arnd@arndb.de
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v4 0/2] Extcon: Add MAX8997 extcon driver for MUIC feature
Date: Wed, 09 May 2012 12:31:44 +0900
Message-id: <1336534304-26273-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset use Extcon framework in extcon-max8997 driver to control
external connector instead of max8997-muic driver which is implemented
with callback function through platform_data to control external connector.

So, first patch add MAX8997 extcon driver (drivers/extcon/extcon-max8997.c),
the last patch remove previous MAX8997 MUIC driver(drivers/misc/max8997-muic.c)
which support MUIC feature of Maxim MAX8997 with callback function.

v1
- Use Extcon interface to notify cable state of notifee instead of
 callback function when external connector is attached or detached.
- Bug fix of getting platform_data for irq_base value.

v2,v3,v4
- Fix line-wrapping problem

Chanwoo Choi (2):
  Extcon: add MAX8997 extcon driver
  misc: MAX8997: Remove max8997-muic driver

 drivers/extcon/Kconfig          |    8 +
 drivers/extcon/Makefile         |    1 +
 drivers/extcon/extcon-max8997.c |  537 +++++++++++++++++++++++++++++++++++++++
 drivers/misc/Kconfig            |    8 -
 drivers/misc/Makefile           |    1 -
 drivers/misc/max8997-muic.c     |  495 ------------------------------------
 include/linux/mfd/max8997.h     |   23 --
 7 files changed, 546 insertions(+), 527 deletions(-)
 create mode 100644 drivers/extcon/extcon-max8997.c
 delete mode 100644 drivers/misc/max8997-muic.c

