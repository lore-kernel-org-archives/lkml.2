Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab1HXIJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:09:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52892 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1HXIJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:09:30 -0400
Date: Wed, 24 Aug 2011 12:09:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: James Bottomley <jbottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>
Subject: [PATCH resend] vfs: Add ->statfs callback for pipefs
Message-ID: <20110824080924.GG29452@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@parallels.com>

This is done to make it possible to distinguish pipes
from fifos when opening one via /proc/<pid>/fd/ link.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/pipe.c |    1 +
 1 file changed, 1 insertion(+)

Any objections to this one? It was a part of a patchset
but can be treated independently so I'm re-sending it alone.

Index: linux-2.6.git/fs/pipe.c
===================================================================
--- linux-2.6.git.orig/fs/pipe.c
+++ linux-2.6.git/fs/pipe.c
@@ -1254,6 +1254,7 @@ out:
 
 static const struct super_operations pipefs_ops = {
 	.destroy_inode = free_inode_nonrcu,
+	.statfs = simple_statfs,
 };
 
 /*
