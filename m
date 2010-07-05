Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750927Ab0GEEMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 00:12:48 -0400
Received: from imr3.ericy.com ([198.24.6.13]:45021 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0GEEMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 00:12:46 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>, Crane Cai <crane.cai@amd.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Ralf Baechle <ralf@linux-mips.org>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH/RFC v2 0/4] hwmon: PMBus device driver
Date: Sun, 4 Jul 2010 21:10:14 -0700
Message-ID: <1278303018-22069-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for hardware monitoring features of PMBus devices.

The driver has not yet been tested with actual hardware. It is submitted for
early review and to solicit test coverage.

A PMBus device emulator is provided for reference, to show the level of testing
performed. I don't currently plan to submit this emulator in the final patchset.
If there is interest to have it included, and if someone is willing to review
the code, I will be happy to clean it up and include it.

I will test the driver with real HW for BMR453 and LTC2978 as soon as I get
access to it. For other devices, I will add a remark that support is untested,
unless I get feedback that a specific device was tested and is working. 

---
Open issues/questions:
- The driver adds new power monitoring attributes to the hwmon sysfs API.
  Need to get feedback if those are acceptable.
- Currently no support for chips with multiple phases (PHASE command).
  Adding this will require access to a system with a chip supporting
  multiple phases (e.g., UCD9240/46/48) to determine a feasible implementation.
- Need to add support for COEFFICIENTS command. Will require system with
  real chip for testing, or will not add support at this time.
- Need to add fan support. Will require system with real chip for testing, or
  will not add support at this time.
  Datasheets of chips with fan control support indicate that chip specific
  code may be necessary. See UCD9240 or UCD90124 datasheets.

---
v2 changes:
- Calculate maximum number of attributes / sensors / booleans / labels instead
  of using defines
- Increased maximum number of supported pages to the PMBus maximum of 32.
- Replaced most fixed size arrays with dynamically allocated arrays/structures.
- Added comments and clarifications
- Renamed local defines to start with PB_ or PMBUS_ prefix
- Removed pages module parameter. Replaced with code to auto-detect the number
  of supported pages.
- Split probe code into several functions to make it better readable
- Replaced _fault attributes with _lcrit_alarm and _crit_alarm attributes
- Several other minor changes to address review feedback
- PMBus emulator: Fixed fault status detection code. Also use more reasonable
  power limits (eg 200W instead of 2kW).
