Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2HFVXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:23:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab2HFVXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:23:18 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        mjg@redhat.com, ibm-acpi@hmh.eng.br
Subject: [PATCH] thinkpad-acpi: recognize latest V-Series using
Date: Mon,  6 Aug 2012 16:23:12 -0500
Message-Id: <1344288192-8469-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>


Please consider this patch to thinkapd_acpi, it loads the module
on V-series systems that do not report with "Lenovo" or "ThinkPad"
prefix to DMI_PRODUCT_VERSION query, but only returns model name.


=========================================================================
Test on V490u
=============
== After the patch ==

[ 1350.295757] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[ 1350.295760] thinkpad_acpi: http://ibm-acpi.sf.net/
[ 1350.295761] thinkpad_acpi: ThinkPad BIOS H7ET21WW (1.00 ), EC unknown
[ 1350.295763] thinkpad_acpi: Lenovo LENOVO, model LV5DXXX
[ 1350.296086] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[ 1350.296694] thinkpad_acpi: radio switch found; radios are enabled
[ 1350.296703] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[ 1350.306466] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[ 1350.307082] Registered led device: tpacpi::thinklight
[ 1350.307215] Registered led device: tpacpi::power
[ 1350.307255] Registered led device: tpacpi::standby
[ 1350.307294] Registered led device: tpacpi::thinkvantage
[ 1350.308160] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[ 1350.308333] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[ 1350.312287] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input14

== Before the patch ==
sudo modprobe thinkpad_acpi 
FATAL: Error inserting thinkpad_acpi (/lib/modules/3.2.0-27-generic/kernel/drivers/platform/x86/thinkpad_acpi.ko): No such device

=========================================================================
Test on B485
=============
This patch was also test in a B485 where the thinkpad_acpi module does not 
have any issues loading. But, I tested it to make sure this patch does not 
break on already functioning models of Lenovo products. 

[13486.746359] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[13486.746364] thinkpad_acpi: http://ibm-acpi.sf.net/
[13486.746368] thinkpad_acpi: ThinkPad BIOS HJET15WW(1.01), EC unknown
[13486.746373] thinkpad_acpi: Lenovo Lenovo LB485, model 814TR01
[13486.747300] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[13486.752435] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[13486.752883] Registered led device: tpacpi::thinklight
[13486.752915] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[13486.753216] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[13486.757147] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input15


Manoj Iyer (1):
  thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR

 drivers/platform/x86/thinkpad_acpi.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

-- 
1.7.9.5

