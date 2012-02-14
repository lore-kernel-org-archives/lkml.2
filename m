Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2BNGOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 01:14:14 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:57042 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751033Ab2BNGOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 01:14:11 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19GOWAkBBhGpeMdzUJZUUAhqLc0yHacvySAISVYPm
	/65VpuXzhcKFbe
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 0/3] viafb auxiliary device support
Date: Tue, 14 Feb 2012 06:35:00 +0000
Message-Id: <cover.1329200232.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this patch series aims to add infrastructure to viafb to support 
devices that are connected via I2C. Even before these patches viafb 
had support for some of these but no structure, instead ranging from 
a single file for a device to various places in the code writing to 
such devices, probably even sometimes without knowing that it is 
talking to the correct device.
This patch series adds just the infrastructure to add such devices 
and a few stub driver which print the name of the chips, if detected.
Even this is quite useful for debugging or recruiting testers. The 
long term goal is to move all existing support for such devices in 
those drivers and extend them to whatever is required.
The chip detection aside the only user visible change is that if no 
viafb_mode/viafb_mode1 is given on startup the initial resolution 
is derived from EDID data, if present for the desired configuration.


Best regards,

Florian Tobias Schandinat


Florian Tobias Schandinat (3):
  viafb: add auxiliary device management infrastructure
  viafb: fix I2C emulation on GPIO ports
  viafb: add initial EDID support

 drivers/video/via/Makefile         |    5 ++-
 drivers/video/via/via_aux.c        |   88 ++++++++++++++++++++++++++++++++
 drivers/video/via/via_aux.h        |   93 ++++++++++++++++++++++++++++++++++
 drivers/video/via/via_aux_ch7301.c |   50 ++++++++++++++++++
 drivers/video/via/via_aux_edid.c   |   97 ++++++++++++++++++++++++++++++++++++
 drivers/video/via/via_aux_sii164.c |   54 ++++++++++++++++++++
 drivers/video/via/via_aux_vt1621.c |   44 ++++++++++++++++
 drivers/video/via/via_aux_vt1622.c |   50 ++++++++++++++++++
 drivers/video/via/via_aux_vt1625.c |   50 ++++++++++++++++++
 drivers/video/via/via_aux_vt1631.c |   46 +++++++++++++++++
 drivers/video/via/via_aux_vt1632.c |   54 ++++++++++++++++++++
 drivers/video/via/via_aux_vt1636.c |   46 +++++++++++++++++
 drivers/video/via/via_i2c.c        |   10 +++-
 drivers/video/via/viafbdev.c       |   53 +++++++++++++++++---
 drivers/video/via/viafbdev.h       |    6 ++
 15 files changed, 736 insertions(+), 10 deletions(-)
 create mode 100644 drivers/video/via/via_aux.c
 create mode 100644 drivers/video/via/via_aux.h
 create mode 100644 drivers/video/via/via_aux_ch7301.c
 create mode 100644 drivers/video/via/via_aux_edid.c
 create mode 100644 drivers/video/via/via_aux_sii164.c
 create mode 100644 drivers/video/via/via_aux_vt1621.c
 create mode 100644 drivers/video/via/via_aux_vt1622.c
 create mode 100644 drivers/video/via/via_aux_vt1625.c
 create mode 100644 drivers/video/via/via_aux_vt1631.c
 create mode 100644 drivers/video/via/via_aux_vt1632.c
 create mode 100644 drivers/video/via/via_aux_vt1636.c

-- 
1.7.9

