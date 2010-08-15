Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab0HOUTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 16:19:36 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33306 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab0HOUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 16:19:35 -0400
Date: Sun, 15 Aug 2010 22:19:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] resource: fix userspace warning
Message-ID: <20100815201934.GC4571@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"make headers_check" gave following warning:

  CHECK   include/linux (364 files)
include/linux/resource.h:49: found __[us]{8,16,32,64} type without #include <linux/types.h>

The warning started to appear after rlimit64 structure was added.
The rlimit64 structure uses the correct types for export, but the
patch failed to include linux/types.h - thus the warning.

But include/linux/resource.h contains a _lot_ of native types,
which size may vary dependent on the architecture.

It would be good if all uses of native types could be
repalced by the intended exportable types.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Jiri Slaby <jslaby@suse.cz>
---

	Sam

diff --git a/include/linux/resource.h b/include/linux/resource.h
index 88d36f9..d01c96c 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -2,6 +2,7 @@
 #define _LINUX_RESOURCE_H
 
 #include <linux/time.h>
+#include <linux/types.h>
 
 /*
  * Resource control/accounting header file for linux
