Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab1CXPt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:49:56 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53674 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab1CXPtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:49:55 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.35+drm33.15
Date: Thu, 24 Mar 2011 15:49:53 +0000
Message-Id: <1300981793-26673-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: linux-kernel@vger.kernel.org
To: stable@kernel.org
To: kernel-team@lists.ubuntu.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.35+drm33.15 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release contains patches from upstream 2.6.32.35, but dropped any patches
to the DRM subsystem.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* Revert "perf: Handle stopped state with tracepoints"
* Linux 2.6.32.35

 Makefile            |    2 +-
 kernel/perf_event.c |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 63ad218..7f6e11d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .34+drm33.15
+EXTRAVERSION = .35+drm33.15
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f9af60f..183d437 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4167,8 +4167,6 @@ static void tp_perf_event_destroy(struct perf_event *event)

 static const struct pmu *tp_perf_event_init(struct perf_event *event)
 {
-	if (event->hw.state & PERF_HES_STOPPED)
-		return 0;
 	/*
 	 * Raw tracepoint data is a severe data leak, only allow root to
 	 * have these.
