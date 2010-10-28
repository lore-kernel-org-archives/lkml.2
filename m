Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934577Ab0J1VdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:33:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934358Ab0J1VcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:32:19 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 07/20] fanotify: allow userspace to flush all marks
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:32:14 -0400
Message-ID: <20101028213214.24810.25807.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify is supposed to be able to flush all marks.  This is mostly useful
for the AV community to flush all cached decisions on a security policy
change.  This functionality has existed in the kernel but wasn't correctly
exposed to userspace.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fanotify.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 8a621c1..a97c96d 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -52,7 +52,8 @@
 				 FAN_MARK_ONLYDIR |\
 				 FAN_MARK_MOUNT |\
 				 FAN_MARK_IGNORED_MASK |\
-				 FAN_MARK_IGNORED_SURV_MODIFY)
+				 FAN_MARK_IGNORED_SURV_MODIFY |\
+				 FAN_MARK_FLUSH)
 
 /*
  * All of the events - we build the list by hand so that we can add flags in

