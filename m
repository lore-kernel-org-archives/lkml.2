Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab1HGVW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 17:22:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44278 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab1HGVWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 17:22:25 -0400
Date: Mon, 8 Aug 2011 01:22:22 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 4/4] vfs: Add ->statfs callback for pipefs
Message-ID: <20110807212221.GH2080@sun>
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
