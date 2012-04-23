Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2DWWQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:16:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51577 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2DWWQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:16:49 -0400
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 1/3] kbuild, deb-pkg: Try to determine distribution
Date: Tue, 24 Apr 2012 00:16:27 +0200
Message-Id: <1335219389-10887-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 scripts/package/builddeb |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index eee5f8e..f5b56ac 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -172,9 +172,22 @@ else
 fi
 maintainer="$name <$email>"
 
+# Try to determine distribution
+if [ -e $(which lsb_release) ]; then
+       codename=$(lsb_release --codename --short)
+       if [ "$codename" != "" ]; then
+		distribution=$codename
+       else
+		distribution="UNRELEASED"
+		echo "WARNING: The distribution could NOT be determined!"
+       fi
+else
+       echo "HINT: Install lsb_release binary, this helps to identify your distribution!"
+fi
+
 # Generate a simple changelog template
 cat <<EOF > debian/changelog
-linux-upstream ($packageversion) unstable; urgency=low
+linux-upstream ($packageversion) $distribution; urgency=low
 
   * Custom built Linux kernel.
 
-- 
1.7.9.5

