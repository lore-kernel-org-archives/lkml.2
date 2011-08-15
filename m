Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1HOFHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:07:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37521 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1HOFH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:07:29 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 00/11] Fix in-tree usage of EXTRA_{A,C,CPP,LD}FLAGS
Date: Mon, 15 Aug 2011 01:07:03 -0400
Message-Id: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

The attached serie fix in-tree usage of EXTRA_{A,C,CPP,LD}FLAGS. Usage of
these flags has been deprecated for nearly 4 years by:

    commit f77bf01425b11947eeb3b5b54685212c302741b8
    Author: Sam Ravnborg <sam@neptun.(none)>
    Date:   Mon Oct 15 22:25:06 2007 +0200

        kbuild: introduce ccflags-y, asflags-y and ldflags-y

Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
line use. By default, gmake(1) do not override command line setting, so this is
likely to result in build failure or unexpected behavior.

Their usage is replaced by Kbuild's `{as,cc,cpp,ld}flags-y'.

This serie has been build-tested on x86-64 `allyesconfig' where it fixes the
complete brokenness of the media tree, plus various other failure, espectially
in the SCSI tree when EXTRA_CFLAGS is defined on the command-line.

I did not build test other architectures.

 - Arnaud

Cc: Sam Ravnborg <sam@ravnborg.org>

Arnaud Lacombe (11):
  arch/m68k: do not use EXTRA_{A,C,LD}FLAGS
  arch/mips: do not use EXTRA_CFLAGS
  arch/unicore32: do not use EXTRA_AFLAGS or EXTRA_CFLAGS
  arch/x86: do not use EXTRA_CFLAGS
  drivers/media: do not use EXTRA_CFLAGS
  drivers/net/bna: do not use EXTRA_CFLAGS
  drivers/pps: do not use EXTRA_CFLAGS
  drivers/scsi: do not use EXTRA_CFLAGS
  drivers/staging: do not use EXTRA_CFLAGS
  scripts/Makefile.build: do not reference EXTRA_CFLAGS as CFLAGS
    replacement
  script/checkpatch.pl: warn about deprecated use of
    EXTRA_{A,C,CPP,LD}FLAGS

 arch/m68k/fpsp040/Makefile                 |    2 +-
 arch/m68k/ifpsp060/Makefile                |    2 +-
 arch/m68k/platform/54xx/Makefile           |    4 ++--
 arch/mips/netlogic/xlr/Makefile            |    2 +-
 arch/unicore32/boot/compressed/Makefile    |    4 ++--
 arch/x86/math-emu/Makefile                 |    4 ++--
 arch/x86/pci/Makefile                      |    4 +---
 drivers/media/common/tuners/Makefile       |    4 ++--
 drivers/media/dvb/b2c2/Makefile            |    4 ++--
 drivers/media/dvb/bt8xx/Makefile           |    8 ++++----
 drivers/media/dvb/ddbridge/Makefile        |    8 ++++----
 drivers/media/dvb/dm1105/Makefile          |    2 +-
 drivers/media/dvb/dvb-usb/Makefile         |    4 ++--
 drivers/media/dvb/frontends/Makefile       |    4 ++--
 drivers/media/dvb/mantis/Makefile          |    2 +-
 drivers/media/dvb/ngene/Makefile           |    8 ++++----
 drivers/media/dvb/pluto2/Makefile          |    2 +-
 drivers/media/dvb/pt1/Makefile             |    2 +-
 drivers/media/dvb/siano/Makefile           |    4 ++--
 drivers/media/dvb/ttpci/Makefile           |    4 ++--
 drivers/media/dvb/ttusb-budget/Makefile    |    2 +-
 drivers/media/dvb/ttusb-dec/Makefile       |    2 +-
 drivers/media/radio/Makefile               |    2 +-
 drivers/media/video/Makefile               |    6 +++---
 drivers/media/video/au0828/Makefile        |    8 ++++----
 drivers/media/video/bt8xx/Makefile         |    6 +++---
 drivers/media/video/cx18/Makefile          |    6 +++---
 drivers/media/video/cx231xx/Makefile       |   10 +++++-----
 drivers/media/video/cx23885/Makefile       |   10 +++++-----
 drivers/media/video/cx25840/Makefile       |    2 +-
 drivers/media/video/cx88/Makefile          |    8 ++++----
 drivers/media/video/em28xx/Makefile        |    8 ++++----
 drivers/media/video/gspca/gl860/Makefile   |    2 +-
 drivers/media/video/gspca/m5602/Makefile   |    2 +-
 drivers/media/video/gspca/stv06xx/Makefile |    2 +-
 drivers/media/video/hdpvr/Makefile         |    4 ++--
 drivers/media/video/ivtv/Makefile          |    8 ++++----
 drivers/media/video/omap3isp/Makefile      |    4 +---
 drivers/media/video/pvrusb2/Makefile       |    8 ++++----
 drivers/media/video/saa7134/Makefile       |    8 ++++----
 drivers/media/video/saa7164/Makefile       |   10 +++++-----
 drivers/media/video/tlg2300/Makefile       |    8 ++++----
 drivers/media/video/usbvision/Makefile     |    4 ++--
 drivers/net/bna/Makefile                   |    2 +-
 drivers/pps/generators/Makefile            |    4 +---
 drivers/scsi/cxgbi/cxgb3i/Kbuild           |    2 +-
 drivers/scsi/cxgbi/cxgb4i/Kbuild           |    2 +-
 drivers/staging/cxd2099/Makefile           |    6 +++---
 drivers/staging/go7007/Makefile            |    8 ++------
 drivers/staging/rtl8187se/Makefile         |    6 +++---
 drivers/staging/rts_pstor/Makefile         |    2 +-
 scripts/Makefile.build                     |    2 +-
 scripts/checkpatch.pl                      |   14 ++++++++++++++
 53 files changed, 130 insertions(+), 126 deletions(-)

-- 
1.7.6.153.g78432

