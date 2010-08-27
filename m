Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0H0Pg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:36:27 -0400
Received: from smtp.nokia.com ([192.100.105.134]:22648 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab0H0Pg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:36:26 -0400
From: Yuri Ershov <ext-yuri.ershov@nokia.com>
To: eric.piel@tremplin-utc.net, samu.p.onkalo@nokia.com,
        akpm@linux-foundation.org, daniel@caiaq.de
Cc: ext-yuri.kululin@nokia.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, ext-yuri.ershov@nokia.com
Subject: [PATCH 0/2] Accelerometer driver unload
Date: Fri, 27 Aug 2010 18:33:19 +0400
Message-Id: <1282919601-21821-1-git-send-email-ext-yuri.ershov@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 27 Aug 2010 15:35:07.0953 (UTC) FILETIME=[6DB0B210:01CB45FD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I2C part of lis3 accelerometer driver can be unloaded while in use which may
cause kernel oops.

These patches allow to change /dev/freefall file ops owner to prevent driver
unloading while device in use.

Please review.

Best regards,
Yuri

Yuri Kululin (2):
  lis3: Add device owner
  lis3: Set device owner

 drivers/hwmon/lis3lv02d.c     |    8 ++++++--
 drivers/hwmon/lis3lv02d.h     |    2 ++
 drivers/hwmon/lis3lv02d_i2c.c |    2 ++
 3 files changed, 10 insertions(+), 2 deletions(-)
