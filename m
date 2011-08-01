Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1HAK3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:29:33 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:44733 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1HAK3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:29:30 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Aug 2011 06:29:30 EDT
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 0/8] VME Driver Fixes
Date: Mon, 1 Aug 2011 12:20:45 +0200
Message-ID: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little background: I work at CERN in the device drivers section and
we have a lot of VME crates we use in the accelerator controls. We have
been using an in-house driver for some time now and want to slowly port
our existing device drivers over to the kernel driver.

This set of patches adds multiple changes to the VME driver that fix
various issues, mostly dealing with the device driver model. Some of
these are based on the changes made by Emilio G. Cota in a previous
LKML thread at:

    https://lkml.org/lkml/2010/10/25/480

Thanks and best regards,
Manohar Vanga

Emilio G. Cota (1):
  staging: vme: allow explicit assignment of bus numbers

Manohar Vanga (7):
  staging: vme_user: change kmalloc+memset to kzalloc
  staging: vme: make [alloc|free]_consistent bridge specific
  staging: vme: keep track of registered buses
  staging: vme: add functions for bridge module refcounting
  staging: vme: rename *_slot_get to *_get_slot
  staging: vme: add struct vme_dev for VME devices
  staging: vme: make match() driver specific to improve non-VME64x
    support

 drivers/staging/vme/bridges/vme_ca91cx42.c |   54 ++++-
 drivers/staging/vme/bridges/vme_tsi148.c   |   53 ++++-
 drivers/staging/vme/devices/vme_user.c     |   63 ++++-
 drivers/staging/vme/devices/vme_user.h     |    2 +-
 drivers/staging/vme/vme.c                  |  414 ++++++++++++++++------------
 drivers/staging/vme/vme.h                  |   56 +++-
 drivers/staging/vme/vme_api.txt            |    2 +-
 drivers/staging/vme/vme_bridge.h           |   19 +-
 8 files changed, 435 insertions(+), 228 deletions(-)

-- 
1.7.4.1

