Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2EIB1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 21:27:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29684 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab2EIB1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 21:27:16 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-05-4fa9c7f332ca
Message-id: <4FA9C7F4.1070308@samsung.com>
Date: Wed, 09 May 2012 10:27:16 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/2] Extcon: Add MAX8997 extcon driver for MUIC feature
X-Forwarded-Message-Id: 
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset use Extcon framework in extcon-max8997 driver to control
external connector instead of max8997-muic driver which is implemented
with callback function through platform_data to control external connector.

So, first patch add MAX8997 extcon driver (drivers/extcon/extcon-max8997.c),
the last patch remove previous MAX8997 MUIC
driver(drivers/misc/max8997-muic.c)
which support MUIC feature of Maxim MAX8997 with callback function.

v1
- Use Extcon interface to notify cable state of notifee instead of
 callback function when external connector is attached or detached.
- Bug fix of getting platform_data for irq_base value.

v2,v3
- Fix line-wrapping problem

Chanwoo Choi (2):
  Extcon: add MAX8997 extcon driver
  misc: MAX8997: Remove max8997-muic driver

 drivers/extcon/Kconfig          |    8 +
 drivers/extcon/Makefile         |    1 +
 drivers/extcon/extcon-max8997.c |  537
+++++++++++++++++++++++++++++++++++++++
 drivers/misc/Kconfig            |    8 -
 drivers/misc/Makefile           |    1 -
 drivers/misc/max8997-muic.c     |  495 ------------------------------------
 include/linux/mfd/max8997.h     |   23 --
 7 files changed, 546 insertions(+), 527 deletions(-)
 create mode 100644 drivers/extcon/extcon-max8997.c
 delete mode 100644 drivers/misc/max8997-muic.c

