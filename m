Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2C0JKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 05:10:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36849 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2C0JKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 05:10:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 27 Mar 2012 11:10:26 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH v2 0/2] i2c: Don't assume bus nr 0 if none was specified
To: w.sang@pengutronix.de
Cc: ben-linux@fluff.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        kyungmin.park@samsung.com, hskinnemoen@gmail.com,
        bigeasy@linutronix.de, dirk.brandewie@gmail.com,
        linux@arm.linux.org.uk, Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1332839428-29705-1-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
 - Dropped reduntant i2c-octeon change

i2c controller drivers used to assume bus number 0 when none (-1) was
specified.

This worked on non-device tree systems, where one could explicitly
specify bus number via platform data.  On DT-enabled systems bus
number is always -1.

This patchset reworks few remaining drivers to use dynamic bus
allocation when no id has been provided.

[ I've found out this when I've tried to instantiate more than one
  i2c-gpio instance on DT-enabled system. I've, hopefully, fixed few
  other drivers too. ]

Karol Lewandowski (2):
  i2c-pxa: Drop leftover comment
  i2c: Dynamically assign adapter id if it wasn't explictly specified

 drivers/i2c/busses/i2c-gpio.c         |    7 +------
 drivers/i2c/busses/i2c-pca-platform.c |    2 +-
 drivers/i2c/busses/i2c-pxa.c          |    5 -----
 drivers/i2c/busses/i2c-versatile.c    |    9 ++-------
 4 files changed, 4 insertions(+), 19 deletions(-)

-- 
1.7.9.1

