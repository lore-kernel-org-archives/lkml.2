Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab1CDR5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:57:06 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37366 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab1CDR5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:57:03 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ian Dobson <i.dobson@planet-ian.com>, Andy Lutomirski <luto@mit.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, <binximeng@gmail.com>,
        <lmsensors@tapanitarvainen.fi>, <andrea.rizzolo@gmail.com>,
        <jeff.sadowski@gmail.com>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 00/11] hwmon: (w83627ehf) Add support for NCT6775F and NCT6776F
Date: Fri, 4 Mar 2011 09:57:55 -0800
Message-ID: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series adds support for NCT6775F and NCT6776F to the
w83627ehf driver. It also includes some cleanup and adds support for
the fourth temperature sensor on W83677HG-B.

No code changes since v4. Resubmitting and widening audience in the hope that
someone may find the time to review the changes prior to the next commit window.

v5:
- Update Kconfig to reference W83667HG, NCT6775F, and NCT6776F.

v4:
- Store rpm instead of raw fan speed readings
- For NCT6775F, increase fan divisor if the fan speed reads 0
  [ On NCT6775F, fan speed readings can return 0 instead of 0xff if the
    fan divisor value is too low ]
- Separate changes into more patches to simplify review

v3:
- Documentation: Remove references to datasheets which no longer exist
- Documentation: Add information about limits of SmartFan IV support.
- SmartFan III mode is not supported on NCT6776F, so remove related attributes
  and refuse to configure it.
- (additional patch) Improve support for chips with 16-bit fan count registers

v2:
- W83677HG-B does share the AUXTIN/VIN3 pin, so we can not skip this check.
- Cosmetic changes to fix a couple of checkpatch errors and to undo some
  unnecessary formatting changes in patch 5.
- Patch 1 introduced a bug in temp_to_reg which was fixed in a later patch.
  Modified code to not introduce the bug in the first place.
- Two dev_dbg messages were changed to dev_info for testing. Changed back
  to dev_dbg.

The patched driver can be downloaded as stand-alone driver from
	http://www.roeck-us.net/linux/drivers/w83627ehf/
