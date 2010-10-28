Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538Ab0J1VcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:32:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933698Ab0J1VcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:32:01 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 04/20] fanotify: use __aligned_u64 in fanotify userspace
	metadata
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:31:57 -0400
Message-ID: <20101028213157.24810.3528.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the userspace struct exposed by fanotify uses
__attribute__((packed)) to make sure that alignment works on multiarch
platforms.  Since this causes a severe performance penalty on some
platforms we are going to switch to using explicit alignment notation on
the 64bit values so we don't have to use 'packed'

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fanotify.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 2c89ce7..8a621c1 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -79,10 +79,10 @@
 struct fanotify_event_metadata {
 	__u32 event_len;
 	__u32 vers;
-	__u64 mask;
+	__aligned_u64 mask;
 	__s32 fd;
 	__s32 pid;
-} __attribute__ ((packed));
+};
 
 struct fanotify_response {
 	__s32 fd;

