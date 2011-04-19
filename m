Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1DSJn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:43:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57729 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1DSJn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:43:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o0HN8LWcqrrhf6qc9yAjBAcabcoMrH9vgK0ciCz9UOPwjzlnEdZfQapmzuck9gBn4l
         7PkG2nsZuKcqscdySmcGdO/gAW1vAMnrsAAo2EHVK0wTBNRuUgWIOM0bI/iV41B3kT8C
         YlQzrtoGnfKFKwinwvbxYUG2M8nUj6Y3tOOkk=
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 1/2] ovl: fix missing include
Date: Tue, 19 Apr 2011 11:43:18 +0200
Message-Id: <1303206199-852-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <BANLkTimp9Y7+TbK-DYBketCbuW61643Srg@mail.gmail.com>
References: <BANLkTimp9Y7+TbK-DYBketCbuW61643Srg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

  CC [M]  fs/overlayfs/copy_up.o
fs/overlayfs/copy_up.c: In function 'ovl_read_symlink':
fs/overlayfs/copy_up.c:135:2: error: implicit declaration of function 'get_fs'
fs/overlayfs/copy_up.c:135:9: error: incompatible types when assigning to type 'mm_segment_t' from type 'int'
fs/overlayfs/copy_up.c:136:2: error: implicit declaration of function 'set_fs'
fs/overlayfs/copy_up.c:136:2: error: implicit declaration of function 'get_ds'

Reported-by: Michal Suchanek <hramrach@centrum.cz>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/copy_up.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index fb9962c..308a80a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -13,6 +13,7 @@
 #include <linux/splice.h>
 #include <linux/xattr.h>
 #include <linux/security.h>
+#include <linux/uaccess.h>
 #include "overlayfs.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
-- 
1.7.1

