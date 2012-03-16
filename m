Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422758Ab2CPMTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:19:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35641 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab2CPMTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:19:08 -0400
Date: Fri, 16 Mar 2012 13:19:01 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 0/2] i2c: Don't assume bus nr 0 if none was specified
To: w.sang@pengutronix.de
Cc: ben-linux@fluff.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hskinnemoen@gmail.com,
        dirk.brandewie@gmail.com, bigeasy@linutronix.de,
        m.szyprowski@samsung.com, grant.likely@secretlab.ca,
        kyungmin.park@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i2c controller drivers used to assume bus number 0 when none (-1) was specified.

This worked on non-device tree systems, where one could explicitly specify
bus number via platform data.  On DT-enabled systems bus number is always -1.

Some drivers assume bus number 0 when -1 is specified.  This patchset kills
this logic and switches to dynamic bus allocation (default when -1 is provided[1]).

[ I've found out this when I've tried to instantiate more than one i2c-gpio
  instance on DT-enabled system. I've, hopefully, fixed few other drivers too. ]

[1] Introduced by Grant Likely in 488bf314b ("i2c: Allow i2c_add_numbered_adapter()
    to assign a bus id")

Karol Lewandowski (2):
  i2c-pxa: Drop leftover comment
  i2c: Dynamically assign adapter id if it wasn't explictly specified

 drivers/i2c/busses/i2c-gpio.c         |    7 +------
 drivers/i2c/busses/i2c-octeon.c       |    2 +-
 drivers/i2c/busses/i2c-pca-platform.c |    2 +-
 drivers/i2c/busses/i2c-pxa.c          |    5 -----
 drivers/i2c/busses/i2c-versatile.c    |    9 ++-------
 5 files changed, 5 insertions(+), 20 deletions(-)

-- 
1.7.9

