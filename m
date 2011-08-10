Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1HJJhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:37:14 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:45610 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab1HJJhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:37:12 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 0/6] [RESEND] VME framework fixes
Date: Wed, 10 Aug 2011 11:33:44 +0200
Message-ID: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martyn,

This is the resend of the patches with the recommended fixes. Some notes
on the various patches:

  staging: vme: allow explicit assignment of bus numbers

I have left this as it is with a simple array of numbers. I think we should
apply this for now and work on the UUID method separately as this solves a
major issue in a relatively decent way.

  staging: vme: make [alloc|free]_consistent bridge specific

Added the bridge names to the prink's.

  staging: vme: add functions for bridge module refcounting

I have added calls in probe and remove to automatically refcount the devices
that are probed. I have left symbol exports for the refcounting functions if
any drivers want to use them in some unforseen way.

  staging: vme: add struct vme_dev for VME devices
  staging: vme: make match() driver specific to improve non-VME64x
    support

Fixes based on the changes introduced before. Note that I have removed the
patch with the rename of the vme_slot_get function. Also removed the
kzalloc patch as it can be applied from the previous send.

Another note: I have not added the documentation yet. Based on the changes
that are approved, I will write it up today and send it in :)

Looking forward to your feedback. Thanks!

--
/manohar

Emilio G. Cota (1):
  staging: vme: allow explicit assignment of bus numbers

Manohar Vanga (5):
  staging: vme: make [alloc|free]_consistent bridge specific
  staging: vme: keep track of registered buses
  staging: vme: add functions for bridge module refcounting
  staging: vme: add struct vme_dev for VME devices
  staging: vme: make match() driver specific to improve non-VME64x
    support

 drivers/staging/vme/bridges/vme_ca91cx42.c |   46 +++
 drivers/staging/vme/bridges/vme_tsi148.c   |   47 +++
 drivers/staging/vme/devices/vme_user.c     |   39 ++-
 drivers/staging/vme/devices/vme_user.h     |    2 +-
 drivers/staging/vme/vme.c                  |  418 ++++++++++++++++------------
 drivers/staging/vme/vme.h                  |   56 +++-
 drivers/staging/vme/vme_bridge.h           |   17 +-
 7 files changed, 419 insertions(+), 206 deletions(-)

-- 
1.7.4.1

