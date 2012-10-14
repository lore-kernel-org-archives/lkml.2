Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab2JNO64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:58:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46525 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932202Ab2JNOn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:26 -0400
Message-Id: <20121014143543.836365515@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>
Subject: [ 074/147] kbuild: Do not package /boot and /lib in make tar-pkg
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Marek <mmarek@suse.cz>

commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d upstream.

There were reports of users destroying their Fedora installs by a kernel
tarball that replaces the /lib -> /usr/lib symlink. Let's remove the
toplevel directories from the tarball to prevent this from happening.

Reported-by: Andi Kleen <andi@firstfloor.org>
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Michal Marek <mmarek@suse.cz>
[bwh: Backported to 3.2: drop redundant changes]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/Makefile.fwinst  |    4 ++--
 scripts/package/buildtar |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index 4d908d1..c3f69ae 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -42,7 +42,7 @@ quiet_cmd_install = INSTALL $(subst $(srctree)/,,$@)
 $(installed-fw-dirs):
 	$(call cmd,mkdir)
 
-$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)
+$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $$(dir $(INSTALL_FW_PATH)/%)
 	$(call cmd,install)
 
 PHONY +=  __fw_install __fw_modinst FORCE
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


