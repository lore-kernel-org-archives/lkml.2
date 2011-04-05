Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1DEOrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:47:42 -0400
Received: from smtp.nokia.com ([147.243.128.26]:50598 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab1DEOrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:47:41 -0400
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: eric.piel@tremplin-utc.net, mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        samu.p.onkalo@nokia.com, ilkka.koskinen@nokia.com
Subject: [RFC PATCHv2 0/5] lis3lv02d: Regulator fix & support for multiple devices  
Date: Tue,  5 Apr 2011 17:45:09 +0300
Message-Id: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.7.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch fixes a bug in lis3 i2c driver when probe() fails.

The rest of the patches converts statically allocated lis3 device
to dynamically allocated one, which enables support for multiple
lis3 devices on board. In addition, this patch set makes it
possible to load both i2c and spi drivers so that they don't
disturb each other. hp_accel is hacked to work and, thus, doesn't
support multiple devices.

I have tested the i2c based driver on target device, but haven't
the other two.

Changes since v1:
The patches are rebased on top of 2.6.39-rc1 as requested. That is,
no code changes. Only the paths of the files were changed.

Cheers, Ilkka


Ilkka Koskinen (5):
  hwmon: lis3: Free regulators if probe() fails.
  hwmon: lis3: Change naming to consistent
  hwmon: lis3: Change exported function to use given device
  hwmon: lis3: Remove the referencies to the global variable in core
    driver
  hwmon: lis3: Register hwif and remove references to global variable

 drivers/misc/lis3lv02d/lis3lv02d.c     |  391 ++++++++++++++++++--------------
 drivers/misc/lis3lv02d/lis3lv02d.h     |   11 +-
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |   67 ++++---
 drivers/misc/lis3lv02d/lis3lv02d_spi.c |   35 ++-
 drivers/platform/x86/hp_accel.c        |   52 +++--
 5 files changed, 319 insertions(+), 237 deletions(-)

