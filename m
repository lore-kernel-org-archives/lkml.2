Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0FZSTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 14:19:52 -0400
Received: from imr1.ericy.com ([198.24.6.9]:32878 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab0FZSTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 14:19:47 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@linux.intel.com>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 0/3] hwmon: Driver for SMM665 Six-Channel Active DC Output Controller/Monitor
Date: Sat, 26 Jun 2010 11:17:50 -0700
Message-ID: <1277576273-14153-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the monitoring features of the Summit
Microelectronics SMM665 Six-Channel Active DC Output Controller/Monitor.

Resend: Looks like copies to the mailing lists got lost the first time around.
My apologies if you recveive this twice.

------

v2 changes:
- Added (untested) support for SMM465, SMM764, and SMM766.
- Added vref module parameter to support non-default values of VREF_ADC.
- Added an explanation describing what the chip does with _min and _max limit
  values.
- Removed alarm sysfs files (since the chip does not report alarm status in a
  register, alarm detection was implemented by comparing limits with ADC readings,
  which can as well be done in userland).
- Replaced register enums with defines.
- Made limit variable names better readable.
- Removed retries from smm665_read_adc().
- Check error reply from i2c_smbus_read_byte_data() and only accept ENXIO
  when expecting NACK.
- Explained reason for byte swap after reading ADC registers in some more detail.
- Added debug messages to display the error reason when reading ADC registers
  failed.

v3 changes:
- Return error codes from smm665_read_adc().
- Abort after first error in smm665_update_device() and return error code.
- Return ADC read errors to user.
- Added inX_lcrit and inX_crit attributes for min/max critical voltages.
- Added tempX_lcrit attribute for critical low temperature.
- Updated sysfs-interface to document support for new attributes.

v4 changes:
- Added missing unlock in error handling of smm665_update_device().
- Fixed minor style issue in MAINTAINERS
- Removed update to sysfs-interface from patchset since it has already
  been applied.
- Added lcrit and crit attributes to driver documentation.

v5 changes:
- Removed obsolete comment
- Added datasheet links to driver documentation.
