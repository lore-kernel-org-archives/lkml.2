Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0L3NhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 08:37:18 -0500
Received: from smtp.nokia.com ([147.243.128.26]:64651 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab0L3NhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 08:37:16 -0500
From: tapio.vihuri@nokia.com
To: dmitry.torokhov@gmail.com, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        ilkka.koskinen@nokia.com, samu.p.onkalo@nokia.com
Subject: [PATCH v2 0/3] input: Add support for ECI (multimedia) accessories
Date: Thu, 30 Dec 2010 15:36:56 +0200
Message-Id: <1293716219-26089-1-git-send-email-tapio.vihuri@nokia.com>
X-Mailer: git-send-email 1.6.5
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tapio Vihuri <tapio.vihuri@nokia.com>

Thank you for comments.

In series two there Kconfig dependency problem fixed, preventing compilation
if X86_MRST (Intel Moorestown) or INPUT_MISC is not selected.

Also created against linux-2.6.37-rc8

--- v1 message ---

Hi all

This patch set introduce Multimedia Headset Accessory support for
Nokia phones. Technically those are known as ECI (Enhancement Control Interface)
	
If headset has many buttons, like play, vol+, vol- etc. then it is propably ECI
accessory.

Among several buttons ECI accessories contains memory for storing several
parameters.

This ECI input driver provides the following features:
 - reading ECI configuration memory
 - ECI buttons as input events

Drive is constructed as follows:
 - ECI accessory input driver deals with headset accessory
 - ECI bus control driver deals the HW transfering data to/from headset
 - platform data match used HW

In the future accessory detection logic will be added using ALSA jack reporting.

Created against linux-2.6.37-rc6

Please review.

Tapio Vihuri (3):
  ECI: input: introduce ECI accessory input driver
  ECI: introducing ECI bus driver
  ECI: adding platform data for ECI driver

 arch/x86/platform/mrst/mrst.c |   59 +++
 drivers/Kconfig               |    2 +
 drivers/Makefile              |    1 +
 drivers/ecibus/Kconfig        |   35 ++
 drivers/ecibus/Makefile       |   10 +
 drivers/ecibus/ecibus.c       |  583 ++++++++++++++++++++++++
 drivers/input/misc/Kconfig    |   18 +
 drivers/input/misc/Makefile   |    2 +-
 drivers/input/misc/eci.c      | 1002 +++++++++++++++++++++++++++++++++++++++++
 include/linux/input/eci.h     |  165 +++++++
 10 files changed, 1876 insertions(+), 1 deletions(-)
 create mode 100644 drivers/ecibus/Kconfig
 create mode 100644 drivers/ecibus/Makefile
 create mode 100644 drivers/ecibus/ecibus.c
 create mode 100644 drivers/input/misc/eci.c
 create mode 100644 include/linux/input/eci.h

