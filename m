Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0EYPwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:52:40 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:61077 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0EYPwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:52:39 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>,
       Tejun Heo <tj@kernel.org>, Scott James Remnant <scott@ubuntu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Harald Hoyer <harald@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, agk@redhat.com,
       snitzer@redhat.com, Will Drewry <wad@chromium.org>
Subject: [PATCH 2/2] init, mount: export the name_to_dev_t symbol
Date: Tue, 25 May 2010 10:46:51 -0500
Message-Id: <1274802411-26613-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274802411-26613-1-git-send-email-wad@chromium.org>
References: <1274802411-26613-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change only adds EXPORT_SYMBOL() for name_to_dev_t.

name_to_dev_t is in use outside of init/ but is not 'officially'
exported.  It provides behavior that is useful for any code that may be
need to lookup a block device by major:minor or registered kernel name,
especially before there is a root filesystem.

Hopefully, this is the appropriate use of EXPORT_SYMBOL().  This
specific function seems to be a stable interface and is available
in include/linux/mount.h.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 init/do_mounts.c      |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index a322b13..b9206e7 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -144,6 +144,7 @@ fail:
 done:
 	return res;
 }
+EXPORT_SYMBOL(name_to_dev_t);
 
 static int __init root_dev_setup(char *line)
 {
-- 
1.7.0.4

