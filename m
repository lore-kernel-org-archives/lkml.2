Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0JaHvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 03:51:47 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:55017 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554Ab0JaHvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 03:51:44 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/8] hwmon: applesmc: Dynamic configuration rewrite
Date: Sun, 31 Oct 2010 08:50:26 +0100
Message-Id: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PCShW-0007Xy-6Y.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PCShW-0007Xy-6Y abc30290d3bbfa043ce5e314f677684f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The amount of machines supported by this driver has increased rapidly
over the past years, and the detailed driver support of the many
flavors is quickly becoming a problem.

This patchset introduces dynamic configuration by making the SMC
register set efficiently searchable, and fixes a number of outstanding
issues:

* Support for all new models since MacbookPro 6.
* Support for variable number of cpu sensors in the MacPros.
* Handles the odd temperature sensor types found on new models.
* Fixes minor read problems on many intermediate models.

The first patch is preparatory. The second patch adds the register
lookup cache. The third patch adds the dynamic temperature files, and
the fourth implements a new temperature register format. The fifth
patch makes the remaining features dynamically configured, and the
sixth patch sets up the fans dynamically. The seventh patch is purely
janitory, and the last patch updates the copyright.

As a side-effect, the file is reduced by almost five hundred lines.

Cheers,
Henrik

Henrik Rydberg (8):
  hwmon: applesmc: Relax the severity of device init failure
  hwmon: applesmc: Introduce a register lookup table
  hwmon: applesmc: Dynamic creation of temperature files
  hwmon: applesmc: Handle new temperature format
  hwmon: applesmc: Extract all features generically
  hwmon: applesmc: Dynamic creation of fan files
  hwmon: applesmc: Simplify feature sysfs handling
  hwmon: applesmc: Update copyright information

 drivers/hwmon/applesmc.c | 1542 ++++++++++++++++------------------------------
 1 files changed, 534 insertions(+), 1008 deletions(-)

