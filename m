Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1EDGAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 02:00:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49283 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab1EDGAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 02:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lqYmZzAF1LY0BkOK+pEF5HG4VL/7voHgTUw7LLUvCxKmdM8rkN6Ws2El3YCd3TXado
         C1mEOYLqJSeJo5YYcPgu/J5W46j6JU5LSMa08LJhN1hx9nuvujU+XvfYI9ovq5NW1Vpn
         JwADda2DbM/XLQYuKQBBdC+1UyT2xnOLnCMz4=
From: Nuno Subtil <subtil@gmail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nuno Subtil <subtil@gmail.com>
Subject: [PATCH 1/1] deb-pkg: fix cross-compile build
Date: Tue,  3 May 2011 22:59:10 -0700
Message-Id: <1304488750-13606-1-git-send-email-subtil@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When generating the header package, scripts/package/builddeb was inferring the
target architecture by looking at the output of dpkg --print-architecture. This
allows KBUILD_DEBARCH to override that.

Signed-off-by: Nuno Subtil <subtil@gmail.com>
---
 scripts/package/builddeb |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index f6cbc3d..9372145 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -246,7 +246,12 @@ mkdir -p "$destdir"
 (cd $srctree; tar -c -f - -T /tmp/files$$) | (cd $destdir; tar -xf -)
 (cd $objtree; tar -c -f - -T /tmp/objfiles$$) | (cd $destdir; tar -xf -)
 rm -f /tmp/files$$ /tmp/objfiles$$
-arch=$(dpkg --print-architecture)
+
+if [ -n "$KBUILD_DEBARCH" ] ; then
+	arch="$KBUILD_DEBARCH"
+else
+	arch=$(dpkg --print-architecture)
+fi
 
 cat <<EOF >> debian/control
 
-- 
1.7.4.4

Please Cc me on any replies related to this patch.

Thanks,
Nuno

