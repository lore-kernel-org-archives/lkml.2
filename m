Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2JGDTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 23:19:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38864 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2JGDTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 23:19:34 -0400
Message-ID: <5070F4C3.4000501@kernel.org>
Date: Sat, 06 Oct 2012 23:19:31 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI & Power Management patches for Linux-3.7-merge
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these ACPI & Power Management patches.

acpidump utility added
intel_idle driver now supports IVB Xeon
turbostat utility can now count SMIs
ACPI can now bind to USB3 hubs
misc fixes

You will see two minor merge conflicts; acpixf.h and usb-acpi.c.
Note that the conflict resolution is available on my "next" branch,
which is the merge of my "release" and your latest upstream.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:

  Linux 3.6 (2012-09-30 16:47:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to 3f44ea0d1c3835872033a6633135e16f87161202:

  Merge branches 'acpica', 'acpidump', 'intel-idle', 'misc', 'module_acpi_driver-simplify', 'turbostat' and 'usb3' into release (2012-10-06 16:00:32 -0400)

----------------------------------------------------------------

Bob Moore (12):
      ACPICA: Enable Scope change to root during module-level code execution.
      ACPICA: Split ACPICA initialization functions to new file, utxfinit.c
      ACPICA: Comment update: Fix some typos in actble.h
      ACPICA: Add Windows8/Server2012 string for _OSI method.
      ACPICA: GPE Support: Update debug info for GPE tracing.
      ACPICA: Debug output: Update output for Processor object.
      ACPICA: Headers: Add support for CSRT and DBG2 ACPI tables.
      ACPICA: Add support for complex _PLD buffers.
      ACPICA: Add struct header support for _FDE, _GRT, _GTM, and _SRT names.
      ACPICA: Update version to 20120816.
      ACPICA: Headers: Add new ACPI 5 HEST notify type values.
      ACPICA: Update version to 20120913

Feng Tang (4):
      ACPI: delelte more BFS/GTS related definition and code
      ACPICA: GPE support: Remove extraneous parameter from low-level function.
      ACPI: Use ACPICA native way to decode the PLD buffer
      usb-acpi: Comply with the ACPI API change

Fenghua Yu (1):
      ACPI: Harden acpi_table_parse_entries() against BIOS bug

Lan Tianyu (1):
      ACPI: Allow ACPI binding with USB-3.0 hub

Lance Ortiz (1):
      ACPI: Add new sysfs interface to export device description

Len Brown (17):
      tools/power/acpi/acpidump: version 20051111
      tools/power/acpi/acpidump: version 20060606
      tools/power/acpi/acpidump: version 20070714
      tools/power/acpi/acpidump: version 20071116
      tools/power/acpi/acpidump: version 20101221 - find dynamic tables in sysfs
      tools/power/acpi/acpidump: create acpidump(8), local make install targets
      Merge branch 'acpidump' into acpica
      tools/power/acpi/acpidump: create acpidump(8), local make install targets
      tools/power turbostat: run on IVB Xeon
      tools/power turbostat: delete unused line
      tools/power turbostat: print more turbo-limit information
      tools/power turbostat: make -M output pretty
      tools/power turbostat: add [-m MSR#] option
      intel_idle: enable IVB Xeon support
      tools/power turbostat: add [-d MSR#][-D MSR#] options to print counter deltas
      tools/power/turbostat: add option to count SMIs, re-name some options
      Merge branches 'acpica', 'acpidump', 'intel-idle', 'misc', 'module_acpi_driver-simplify', 'turbostat' and 'usb3' into release

Lin Ming (1):
      ACPI: run _OSC after ACPI_FULL_INITIALIZATION

Lv Zheng (1):
      ACPICA: Table Manager: Merge duplicate code (root table)

Mika Westerberg (12):
      ACPI: introduce module_acpi_driver() helper macro
      ACPI/button: convert to module_acpi_driver()
      ACPI/fan: convert to module_acpi_driver()
      ACPI/hed: convert to module_acpi_driver()
      ACPI/sbshc: convert to module_acpi_driver()
      i2c-scmi: convert to module_acpi_driver()
      Input: atlas_btns - convert to module_acpi_driver()
      hp_accel: convert to module_acpi_driver()
      ideapad: convert to module_acpi_driver()
      topstar-laptop: convert to module_acpi_driver()
      toshiba_bluetooth: convert to module_acpi_driver()
      xo15-ebook: convert to module_acpi_driver()

Yakui Zhao (1):
      tools/power/acpi/acpidump: version 20101221 - find dynamic tables in sysfs

 .../ABI/testing/sysfs-devices-firmware_node        |  17 +
 drivers/acpi/acpica/Makefile                       |   1 +
 drivers/acpi/acpica/achware.h                      |   3 +-
 drivers/acpi/acpica/aclocal.h                      |  23 +-
 drivers/acpi/acpica/acmacros.h                     |  29 +-
 drivers/acpi/acpica/dswload.c                      |  14 +
 drivers/acpi/acpica/dswload2.c                     |  14 +
 drivers/acpi/acpica/evgpe.c                        |  24 +-
 drivers/acpi/acpica/evxfgpe.c                      |   3 +-
 drivers/acpi/acpica/hwgpe.c                        |  15 +-
 drivers/acpi/acpica/hwxfsleep.c                    |   1 -
 drivers/acpi/acpica/nsdump.c                       |   2 +-
 drivers/acpi/acpica/tbinstal.c                     |  20 +-
 drivers/acpi/acpica/tbxface.c                      |  41 +-
 drivers/acpi/acpica/utosi.c                        |   1 +
 drivers/acpi/acpica/utxface.c                      | 354 ++++---------
 drivers/acpi/acpica/utxfinit.c                     | 317 ++++++++++++
 drivers/acpi/bus.c                                 |   8 +-
 drivers/acpi/button.c                              |  13 +-
 drivers/acpi/fan.c                                 |  22 +-
 drivers/acpi/glue.c                                | 135 +++--
 drivers/acpi/hed.c                                 |  20 +-
 drivers/acpi/proc.c                                |  57 ++-
 drivers/acpi/sbshc.c                               |  18 +-
 drivers/acpi/scan.c                                |  56 ++-
 drivers/acpi/tables.c                              |  18 +-
 drivers/acpi/utils.c                               |  11 +-
 drivers/i2c/busses/i2c-scmi.c                      |  14 +-
 drivers/idle/intel_idle.c                          |   1 +
 drivers/input/misc/atlas_btns.c                    |  17 +-
 drivers/platform/x86/hp_accel.c                    |  25 +-
 drivers/platform/x86/ideapad-laptop.c              |  14 +-
 drivers/platform/x86/topstar-laptop.c              |  22 +-
 drivers/platform/x86/toshiba_bluetooth.c           |  22 +-
 drivers/platform/x86/xo15-ebook.c                  |  14 +-
 drivers/pnp/pnpacpi/core.c                         |   7 +-
 drivers/usb/core/usb-acpi.c                        |   5 +-
 include/acpi/acbuffer.h                            | 235 +++++++++
 include/acpi/acnames.h                             |   3 +-
 include/acpi/acpi_bus.h                            |  60 ++-
 include/acpi/acpixf.h                              |   7 +-
 include/acpi/actbl.h                               |  60 ++-
 include/acpi/actbl1.h                              |  16 +-
 include/acpi/actbl2.h                              | 123 ++++-
 include/acpi/actbl3.h                              |  13 +-
 include/acpi/actypes.h                             |   7 -
 tools/power/acpi/Makefile                          |  18 +
 tools/power/acpi/acpidump.8                        |  59 +++
 tools/power/acpi/acpidump.c                        | 560 +++++++++++++++++++++
 tools/power/x86/turbostat/turbostat.8              |  55 +-
 tools/power/x86/turbostat/turbostat.c              | 214 +++++++-
 51 files changed, 2072 insertions(+), 736 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-firmware_node
 create mode 100644 drivers/acpi/acpica/utxfinit.c
 create mode 100644 include/acpi/acbuffer.h
 create mode 100644 tools/power/acpi/Makefile
 create mode 100644 tools/power/acpi/acpidump.8
 create mode 100644 tools/power/acpi/acpidump.c
