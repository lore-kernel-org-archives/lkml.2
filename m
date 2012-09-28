Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2I1HhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:37:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:45640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab2I1HhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:37:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,499,1344236400"; 
   d="scan'208";a="228021189"
Message-ID: <1348817863.10877.320.camel@rui.sh.intel.com>
Subject: [RFC PATCH 0/6] ACPI: ACPI 5.0 device enumeration proposal
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Date: Fri, 28 Sep 2012 15:37:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

I'm working on ACPI device enumeration support recently, and here is the
proposal I made to enumerate devices via ACPI namespace.

the main idea is that, for Serial Buses like I2C and SPI, we enumerate
the controller as a platform device, and then enumerate the slaves via
i2c/spi_register_board_info. And then, when the controller is really
probed and enabled in the platform driver, the SPI/I2C bus code will
enumerate I2C/SPI slaves automatically.
And for the other devices, we will enumerate all of them as platform
devices, which is not covered in this patch set yet.

Patch 1 & 2 Introduce ACPI style device match method in platform_match.
this is because an ACPI device may have multiple hardware ID (_HID) and
Compatible IDs, aka, _CID, but in platform device code, only pdev->name
is used to match the driver id_table currently.
Patch 3 introduces a new API acpi_get_generic_resources().
this API is used to convert ACPI style resources to the generic struct
resource.
Patch 4 changes i2c_register_board_info from __init to __devinit.
This is needed because I want to enumerate the slave devices in ACPI I2C
control Driver, which supports hotplug in theory.
Patch 5 introduces the ACPI I2C controller enumeration drive.
it enumerate the ACPI I2C controller to a platform device and then
enumerate the I2C slaves as I2C_board_info.
Patch 6 is an example driver for an ACPI enuemrated I2C controller.

Note that this is just prototype patch set, which just passes build
test. Because I'd like to get your ideas about this before going on.
any comments are welcome.

thanks,
rui

