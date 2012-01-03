Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2ACSJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:09:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53495 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab2ACSJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:09:46 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.52+drm33.21
Date: Tue,  3 Jan 2012 19:09:43 +0100
Message-Id: <1325614183-7785-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.52+drm33.21 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release contains patches from upstream 2.6.32.52, but dropped any patches
to the DRM subsystem.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
or
  git://kernel.ubuntu.com/smb/linux-2.6.32.y-drm33.z.git

and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary
or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* Revert "clockevents: Set noop handler in clockevents_exchange_device()"
* Linux 2.6.32.52

 Makefile                  |    2 +-
 kernel/time/clockevents.c |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 32dbdd6..8c56b60 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .51+drm33.21
+EXTRAVERSION = .52+drm33.21
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index b38baff..0d809ae 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -221,7 +221,6 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	 * released list and do a notify add later.
 	 */
 	if (old) {
-		old->event_handler = clockevents_handle_noop;
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
