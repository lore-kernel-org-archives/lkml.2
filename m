Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0GCWOY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:14:24 -0400
Received: from imr1.ericy.com ([198.24.6.9]:46385 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab0GCWOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:14:23 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ethan Lawrence <e.law87@yahoo.com>, Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Iain <selsinork@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, lars4910@hotmail.com,
       birdie@permonline.ru, jadcock@cox.net, binximeng@gmail.com,
       Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v4 0/2] hwmon: Add support for W83667HG-B to w83627ehf driver.
Date: Sat, 3 Jul 2010 15:13:20 -0700
Message-ID: <1278195202-2683-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series adds support for W83667HG-B to the w83627ehf driver.

The first patch makes generic changes to the driver, the second patch adds
support for W83667HG-B.

Key relevant difference between W83667HG and W83667HG-B are the Chip ID as well
as fan output and step output register addresses. Those differences are
addressed with this patch.

There are other relevant changes in the mapping of input sensors to fan
control (W83667HG datasheet chapter 8.7, W83667HG-B datasheet chapter 8.5).
However, control of those mappings is not implemented in the driver, thus the
respective changes should not have an impact on driver operation.

Patch has been tested with W83667HG-B on Asus P7F-E board. Fan and voltage
sensors are known to work. pwmcontrol does not have a noticeable effect,
though the reasons are unknown and might be board related.

Changes in v4: 
- Fixed error message "sysfs: cannot create duplicate filename".
- Split patch into generic and W83667HG-B specific parts.

Changes in v3:
- Updated driver documentation
- Read data from max and step registers in update_device function.
- In update_device, read fan pwm registers only for installed/supported fans.
- Removed W83667HG-I code; that should really have been W83677HG-I.
  Without datasheet, adding support for this chip would be too risky.
- For W83667HG-B, create max and step attribute files for all fans.

Changes in v2:
- Removed dash from hwmon device name.
- Moved global array pointers to per-device data.
- Added chip detection for W83667HG-I
  (assumed to be identical to W83667HG; needs to be validated).

