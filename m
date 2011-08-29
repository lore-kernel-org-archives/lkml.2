Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1H2JGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 05:06:30 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:48418 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1H2JGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 05:06:24 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 0/3] [RESEND v3] VME Driver Changes
Date: Mon, 29 Aug 2011 11:02:47 +0200
Message-ID: <1314608570-32766-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martyn,

These are the updated patches with the discussed issues resolved. Let
me know if you spot anything else. A note on the changes:

* staging: vme: add functions for bridge module refcounting

Fixed the parameter imbalance in vme_bridge_[get|put]. They both now
take a struct vme_bridge * as their parameter. I used the vme_bridge *
instead of vme_dev as it more coherent with the names of the functions.


* staging: vme: add struct vme_dev for VME devices

Fixes based on the above changes.


* staging: vme: make match() driver specific to improve non-VME64x
    support

Cleaned up the loop in __vme_register_driver with a note on why there
is no race involved.

Thanks
Manohar

Manohar Vanga (3):
  staging: vme: add functions for bridge module refcounting
  staging: vme: add struct vme_dev for VME devices
  staging: vme: make match() driver specific to improve non-VME64x
    support

 drivers/staging/vme/bridges/vme_ca91cx42.c |    2 +
 drivers/staging/vme/bridges/vme_tsi148.c   |    2 +
 drivers/staging/vme/devices/vme_user.c     |   67 +++----
 drivers/staging/vme/devices/vme_user.h     |    2 +-
 drivers/staging/vme/vme.c                  |  305 +++++++++++++++-------------
 drivers/staging/vme/vme.h                  |   55 ++++--
 drivers/staging/vme/vme_api.txt            |   79 +++++---
 drivers/staging/vme/vme_bridge.h           |    6 +-
 8 files changed, 285 insertions(+), 233 deletions(-)

-- 
1.7.4.1

