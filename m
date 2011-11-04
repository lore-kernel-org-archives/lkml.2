Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1KDKQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 06:16:48 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:45896 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab1KDKQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 06:16:47 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 0/3] VME driver fixes
Date: Fri, 4 Nov 2011 11:12:28 +0100
Message-ID: <1320401551-29287-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martyn,

These three patches fix the issues raised by you in the discussion
regarding the removal of the VME driver from the staging tree.

* staging: vme: fix comment in __vme_register_driver()

This patch fixes the comment which doesn't apply as we didn't add the
bridge reference counting functions patch.

The code is still safe as vme_buses_lock is held when registering devices
(and vme_unregister_bridge needs to acquire it in order to remove the
bridge). The only different I can see is that the probe() calls will go
through entirely in this case before remove() is immediately called on
them (whereas with the vme_bridge_get(), a probe in the middle could fail
and we could quickly unregister the bridge).

* staging: vme: remove vme_add_bus() and vme_remove_bus()

These have been renamed to vme_register/unregister_bridge respectively.

Please let me know if you feel any other changes need to be made. Thanks
and best regards.

Manohar Vanga

Manohar Vanga (3):
  staging: vme: fix comment in __vme_register_driver()
  staging: vme: remove vme_add_bus() and vme_remove_bus()
  staging: vme: fix comment for struct vme_dev

 drivers/staging/vme/vme.c |   31 +++++++++----------------------
 drivers/staging/vme/vme.h |    2 +-
 2 files changed, 10 insertions(+), 23 deletions(-)

-- 
1.7.4.1

