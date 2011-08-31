Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1HaKJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:09:14 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:3402 "EHLO CERNMX31.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab1HaKJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:09:12 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 0/3] [RESEND v4] VME Framework Fixes
Date: Wed, 31 Aug 2011 12:05:43 +0200
Message-ID: <1314785146-19163-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Martyn,

I have reordered the patches to separate the bridge refcounting patch
for now so that we can make some progress on getting the other patches
into the tree. I will rework the refcounting patch and send it later.

Please review these patches and let me know if I missed anything (quite
likely). A note on the various patches follows:

* staging: vme: change static device array to pointers
	This patch changes the static array of devices to an array of
	pointers that are dynamically allocated. Hopefully I understood
	what you meant correctly and the changes are sufficient. I assume
	you were referring to the requirement that all kobjects be allocated
	dynamically and never statically (found in Documentation/kobject.txt).

* staging: vme: add struct vme_dev for VME devices
* staging: vme: make match() driver specific to improve non-VME64x
    support
	Changes based on the moving of the bridge refcounting patch as well
	as changes based on comments from Emilio and Greg in the last resend.

Thanks!
Manohar

Manohar Vanga (3):
  staging: vme: change static device array to pointers
  staging: vme: add struct vme_dev for VME devices
  staging: vme: make match() driver specific to improve non-VME64x
    support

 drivers/staging/vme/devices/vme_user.c |   67 +++-----
 drivers/staging/vme/devices/vme_user.h |    2 +-
 drivers/staging/vme/vme.c              |  274 +++++++++++++++-----------------
 drivers/staging/vme/vme.h              |   55 +++++--
 drivers/staging/vme/vme_api.txt        |   79 ++++++----
 drivers/staging/vme/vme_bridge.h       |    5 -
 6 files changed, 244 insertions(+), 238 deletions(-)

-- 
1.7.4.1

