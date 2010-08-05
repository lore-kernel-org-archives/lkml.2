Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab0HEOmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:42:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:41629 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab0HEOkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:40:24 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb,kdb,kms for 2.6.36 (2 of 2)
Date: Thu,  5 Aug 2010 09:39:49 -0500
Message-Id: <1281019198-6777-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 05 Aug 2010 14:40:03.0185 (UTC) FILETIME=[16CE9E10:01CB34AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please pull the kms-merge branch which merges the atomic kernel
mode setting hooks into the kernel debugger.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kms-merge

--- Notes for Linus ---

All the code patches are acked or signed off by Jesse Barnes as this
patch set was co-developed and tested by each of us.  These patches
are not in the drm git tree due to the dependence to kgdb/kdb patches.

--- End Notes for Linus ---

This patch set stacks on top of the kgdb / kdb patches and focuses on
further extending kdb to accommodate atomic kernel mode setting (kms).
The idea is that simply setting "kgdboc=kms,kbd" as a kernel argument
will allow you to catch a panic, kernel fault, or jump into the kernel
debugger shell from a graphics console session.

At the moment only the Intel i915 class video devices are supported,
but the API is generic and allows for other kms based drivers to
enable atomic mode setting.

Thanks,
Jason.

---
The following changes since commit 9f64eb95d0cfd50675067d7a76f9d8efc53dc21c:
  Jason Wessel (1):
        debug_core,kdb: fix crash when arch does not have single step

are available in the git repository at:

  . kms-merge

Jason Wessel (5):
      vt,console,kdb: automatically set kdb LINES variable
      kgdboc: Add call backs to allow kernel mode switching
      i915: when kgdb is active display compression should be off
      drm_fb_helper: Preserve capability to use atomic kms
      kgdb,docs: Update the kgdb docs to include kms

Jesse Barnes (4):
      vt,console,kdb: implement atomic console enter/leave functions
      fb: add hooks to handle KDB enter/exit
      drm: add KGDB/KDB support
      drm/i915: use new fb debug hooks

 Documentation/DocBook/kgdb.tmpl      |  108 +++++++++++++++++++++++++++++++---
 Documentation/kernel-parameters.txt  |    9 ++-
 drivers/char/vt.c                    |   78 ++++++++++++++++++++++++
 drivers/gpu/drm/drm_fb_helper.c      |   76 +++++++++++++++++++++++-
 drivers/gpu/drm/i915/intel_display.c |  102 +++++++++++++++++++++++++++++++-
 drivers/gpu/drm/i915/intel_fb.c      |    2 +
 drivers/serial/kgdboc.c              |   18 ++++++
 drivers/video/console/fbcon.c        |   26 ++++++++
 drivers/video/console/fbcon.h        |    1 +
 include/drm/drm_crtc_helper.h        |    2 +
 include/drm/drm_fb_helper.h          |    5 ++
 include/linux/console.h              |   13 ++++
 include/linux/fb.h                   |   13 ++++
 include/linux/kdb.h                  |    4 +
 kernel/debug/kdb/kdb_private.h       |    2 -
 15 files changed, 444 insertions(+), 15 deletions(-)
