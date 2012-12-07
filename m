Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423132Ab2LGA40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:56:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40591 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423077Ab2LGAzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:55:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andi Kleen <andi@firstfloor.org>, Ben Hutchings <ben@decadent.org.uk>,
        Michal Marek <mmarek@suse.cz>
Subject: [ 20/20] kbuild: Do not package /boot and /lib in make tar-pkg
Date: Thu,  6 Dec 2012 16:54:35 -0800
Message-Id: <20121207005238.643334078@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005232.756641002@linuxfoundation.org>
References: <20121207005232.756641002@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Marek <mmarek@suse.cz>

commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d upstream.

There were reports of users destroying their Fedora installs by a kernel
tarball that replaces the /lib -> /usr/lib symlink. Let's remove the
toplevel directories from the tarball to prevent this from happening.

Reported-by: Andi Kleen <andi@firstfloor.org>
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Michal Marek <mmarek@suse.cz>
[bwh: Fold in commit 3ce9e53e788881da0d5f3912f80e0dd6b501f304 to avoid
 conflicts]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/package/buildtar |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


