Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab2KZSQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:16:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47168 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab2KZRCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Marek <mmarek@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 036/270] kbuild: Do not package /boot and /lib in make tar-pkg
Date: Mon, 26 Nov 2012 14:55:26 -0200
Message-Id: <1353949160-26803-37-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Marek <mmarek@suse.cz>

commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d upstream.

There were reports of users destroying their Fedora installs by a kernel
tarball that replaces the /lib -> /usr/lib symlink. Let's remove the
toplevel directories from the tarball to prevent this from happening.

Reported-by: Andi Kleen <andi@firstfloor.org>
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Michal Marek <mmarek@suse.cz>
[ herton: dropped unrelated changes to arch/x86/Makefile and
  scripts/Makefile.fwinst, which don't apply anyway on 3.5, see commit
  3ce9e53e788881da0d5f3912f80e0dd6b501f304 upstream ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 scripts/package/buildtar |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/buildtar b/scripts/package/buildtar
index 8a7b155..d0d748e 100644
--- a/scripts/package/buildtar
+++ b/scripts/package/buildtar
@@ -109,7 +109,7 @@ esac
 	if tar --owner=root --group=root --help >/dev/null 2>&1; then
 		opts="--owner=root --group=root"
 	fi
-	tar cf - . $opts | ${compress} > "${tarball}${file_ext}"
+	tar cf - boot/* lib/* $opts | ${compress} > "${tarball}${file_ext}"
 )
 
 echo "Tarball successfully created in ${tarball}${file_ext}"
-- 
1.7.9.5

