Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0LJD3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:29:17 -0500
Received: from mail.perches.com ([173.55.12.10]:2460 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab0LJD3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:29:15 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] hid: Use hid_<level> for logging messages
Date: Thu,  9 Dec 2010 19:29:02 -0800
Message-Id: <cover.1291951482.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
References: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and a few miscellaneous cleanups while at it.

Joe Perches (6):
  hid: Add and use hid_<level>: dev_<level> equivalents
  hid: Use vzalloc for vmalloc/memset(,0...)
  hid: Remove __inline__ from functions
  hid: Remove unnecessary multiplies from loops
  hid: Hoist assigns from ifs
  hid: Simplify an index check in hid_lookup_collection

 drivers/hid/hid-3m-pct.c       |    2 +-
 drivers/hid/hid-a4tech.c       |    6 +-
 drivers/hid/hid-apple.c        |   14 ++--
 drivers/hid/hid-axff.c         |   14 ++--
 drivers/hid/hid-belkin.c       |    4 +-
 drivers/hid/hid-cando.c        |    2 +-
 drivers/hid/hid-cherry.c       |    3 +-
 drivers/hid/hid-core.c         |  126 +++++++++++++++++++------------
 drivers/hid/hid-cypress.c      |    4 +-
 drivers/hid/hid-debug.c        |    4 +-
 drivers/hid/hid-drff.c         |   14 ++--
 drivers/hid/hid-egalax.c       |    2 +-
 drivers/hid/hid-elecom.c       |    3 +-
 drivers/hid/hid-emsff.c        |   13 ++--
 drivers/hid/hid-gaff.c         |   13 ++--
 drivers/hid/hid-input.c        |    2 +-
 drivers/hid/hid-kye.c          |    4 +-
 drivers/hid/hid-lg.c           |   15 ++--
 drivers/hid/hid-lg2ff.c        |    9 +-
 drivers/hid/hid-lg3ff.c        |    9 +-
 drivers/hid/hid-lg4ff.c        |    9 +-
 drivers/hid/hid-lgff.c         |    8 +-
 drivers/hid/hid-magicmouse.c   |   15 ++--
 drivers/hid/hid-microsoft.c    |    7 +-
 drivers/hid/hid-monterey.c     |    3 +-
 drivers/hid/hid-mosart.c       |    2 +-
 drivers/hid/hid-ntrig.c        |    9 +-
 drivers/hid/hid-ortek.c        |    3 +-
 drivers/hid/hid-petalynx.c     |    7 +-
 drivers/hid/hid-picolcd.c      |   45 +++++------
 drivers/hid/hid-pl.c           |   16 ++--
 drivers/hid/hid-prodikeys.c    |   21 +++---
 drivers/hid/hid-quanta.c       |    2 +-
 drivers/hid/hid-roccat-kone.c  |   22 +++---
 drivers/hid/hid-roccat-pyra.c  |   20 ++---
 drivers/hid/hid-roccat.c       |   10 +-
 drivers/hid/hid-samsung.c      |    8 +-
 drivers/hid/hid-sjoy.c         |   16 ++--
 drivers/hid/hid-sony.c         |   11 +--
 drivers/hid/hid-stantum.c      |    2 +-
 drivers/hid/hid-sunplus.c      |    3 +-
 drivers/hid/hid-tmff.c         |   27 +++----
 drivers/hid/hid-wacom.c        |   26 ++++---
 drivers/hid/hid-zpff.c         |   11 +--
 drivers/hid/hid-zydacron.c     |   11 +--
 drivers/hid/hidraw.c           |   12 ++-
 drivers/hid/usbhid/hid-core.c  |   48 ++++++------
 drivers/hid/usbhid/hid-pidff.c |  164 +++++++++++++++++++---------------------
 drivers/hid/usbhid/hiddev.c    |    2 +-
 drivers/hid/usbhid/usbkbd.c    |   24 ++++---
 include/linux/hid.h            |   32 ++++++--
 51 files changed, 438 insertions(+), 421 deletions(-)

-- 
1.7.3.3.464.gf80b6

