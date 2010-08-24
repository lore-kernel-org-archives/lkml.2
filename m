Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab0HXK7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:59:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0HXK7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:59:16 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: [PATCH] fanotify: Return EPERM when a process is not privileged
Date: Tue, 24 Aug 2010 12:58:54 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008241258.54580.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The appropriate error code when privileged operations are denied is
EPERM, not EACCES.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
---
 fs/notify/fanotify/fanotify_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c3a5742..4d7f7cb 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -641,7 +641,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 		__func__, flags, event_f_flags);
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	if (flags & ~FAN_ALL_INIT_FLAGS)
 		return -EINVAL;
-- 
1.7.1
