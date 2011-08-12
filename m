Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab1HLKeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 06:34:15 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:30449 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1HLKeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 06:34:14 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 0/5] [RESEND v2] VME Framework Fixes
Date: Fri, 12 Aug 2011 12:30:46 +0200
Message-ID: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martyn,

This is the updated list of patches. I have removed the bus numbering
patch as we can work on it further before adding it in. Some notes on
the various patches below:

  staging: vme: make [alloc|free]_consistent bridge specific

Shortened printk messages and used pr_err where lines were too long.

  staging: vme: keep track of registered buses

Made modifications based on the removal of the bus-numbering patch. I
have checked the patch but I might have introduced some bug so a third
person check is a good idea.

  staging: vme: add functions for bridge module refcounting

Changed the return value of the 'vme_bridge_get' function. I will add
device refcounting later,

  staging: vme: add struct vme_dev for VME devices
  staging: vme: make match() driver specific to improve non-VME64x
    support

Updated vme_api.txt and cleaned up the patches here and there.

Thanks!

--
/manohar

Manohar Vanga (5):
  staging: vme: make [alloc|free]_consistent bridge specific
  staging: vme: keep track of registered buses
  staging: vme: add functions for bridge module refcounting
  staging: vme: add struct vme_dev for VME devices
  staging: vme: make match() driver specific to improve non-VME64x
    support

 drivers/staging/vme/bridges/vme_ca91cx42.c |   26 ++
 drivers/staging/vme/bridges/vme_tsi148.c   |   26 ++
 drivers/staging/vme/devices/vme_user.c     |   67 ++---
 drivers/staging/vme/devices/vme_user.h     |    2 +-
 drivers/staging/vme/vme.c                  |  383 ++++++++++++++++------------
 drivers/staging/vme/vme.h                  |   56 +++-
 drivers/staging/vme/vme_api.txt            |   79 ++++---
 drivers/staging/vme/vme_bridge.h           |   17 +-
 8 files changed, 393 insertions(+), 263 deletions(-)

-- 
1.7.4.1

