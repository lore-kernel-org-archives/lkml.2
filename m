Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab1FQPgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:36:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:45330 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757749Ab1FQPgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:36:51 -0400
Date: Fri, 17 Jun 2011 17:36:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1106171548380.22872@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the fixes for the HID layer listed below.

It's mostly fixes for particular concrete devices, plus a revert 
(regression fix) for a magicmouse device.

I am mentioning this explicitly as the revert is not enough -- for full 
fix, there is a patch by Ville Tervo fixing 1.1 CSR dongles. It has been 
queued for quite a few days in wireless-2.6.git already, and John tells 
that this will be going upstream today.

Thanks!

Austin Zhang (1):
      HID: hid-multitouch: add support for Chunghwa multi-touch panel

Benjamin Tissoires (1):
      HID: hid-multitouch: fix broken eGalax

Dan Carpenter (1):
      HID: hiddev: fix use after free in hiddev_release

Jimmy Hon (1):
      HID: add quirk for HyperPen 10000U

Jiri Kosina (2):
      HID: hiddev: fix potential use-after-free
      Revert "HID: magicmouse: ignore 'ivalid report id' while switching modes"

Joe Perches (1):
      HID: MAINTAINERS: Update USB HID/HIDBP DRIVERS pattern

 MAINTAINERS                     |    2 +-
 drivers/hid/Kconfig             |    1 +
 drivers/hid/hid-core.c          |    1 +
 drivers/hid/hid-ids.h           |    4 ++
 drivers/hid/hid-magicmouse.c    |   10 +-----
 drivers/hid/hid-multitouch.c    |   62 +++++++++++++++++++++++++++-----------
 drivers/hid/usbhid/hid-quirks.c |    1 +
 drivers/hid/usbhid/hiddev.c     |    8 ++++-
 8 files changed, 59 insertions(+), 30 deletions(-)
