Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0ESPgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:36:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55204 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab0ESPga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:36:30 -0400
Date: Thu, 20 May 2010 01:36:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/17] fsnotify: update gfp/slab.h includes
Message-Id: <20100520013628.74a8c5a2.sfr@canb.auug.org.au>
In-Reply-To: <1269885165-18617-4-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-4-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Tue, 30 Mar 2010 02:52:31 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.

Please apply to the fsnotify tree (patch reposted below).

From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 03/17] fsnotify: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:31 +0900

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Eric Paris <eparis@redhat.com>
---
 fs/notify/fanotify/fanotify_user.c |    1 +
 fs/notify/vfsmount_mark.c          |    1 -
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 7c869fa..c437bd4 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -10,6 +10,7 @@
 #include <linux/poll.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
 
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index 8f1aa02..ec580a2 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/mutex.h>
-#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/writeback.h> /* for inode_lock */
 
-- 
1.6.4.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
