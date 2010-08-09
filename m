Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab0HIPBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:01:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36742 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab0HIPBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:01:09 -0400
Date: Mon, 09 Aug 2010 17:02:25 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv7 0/8] Various USB patches
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <cover.1281365237.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes compared to v6:
- USB: gadget: storage_common: fixed warning building mass storage function

    Removed, no longer needed after implementing nofua in mass storage
    (the last pathc):

  USB: gadget: g_multi: fixed vendor and product ID
  USB: gadget: g_ffs: fixed vendor and product ID

    No changes here.

* USB: gadget: composite: Better string override handling

    Previous code missed one #include.

  USB: gadget: mass_storage: moved strings handling code to composite

    Na changes here.

* USB: gadget: functionfs: code cleanup

    MODULE_PARAM_DESC() was used instead of MODULE_PARM_DESC().

  USB: gadget: g_multi: moved strings handling code to composite

    No changes.

+ usb: gadget: storage: remove nofua file when unbinding

    New patch.  Fixes issue with Andy Shevchenko's patch.

+ usb: gadget: mass_storage: optional SCSI WRITE FUA bit

    New patch.  Implements nofua from Andy Shevchenko's patch in
    the Mass Storage Function.

 drivers/usb/gadget/composite.c      |   96 +++++++++++++++++++++++------------
 drivers/usb/gadget/f_mass_storage.c |   15 +++++-
 drivers/usb/gadget/file_storage.c   |    1 +
 drivers/usb/gadget/g_ffs.c          |   85 ++++++++++---------------------
 drivers/usb/gadget/mass_storage.c   |   72 ++------------------------
 drivers/usb/gadget/multi.c          |   23 ++-------
 include/linux/usb/composite.h       |   13 +++++
 7 files changed, 131 insertions(+), 174 deletions(-)

