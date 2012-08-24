Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab2HXJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:57:16 -0400
Received: from forward7.mail.yandex.net ([77.88.61.37]:47173 "EHLO
	forward7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2HXJ5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:57:14 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2012 05:57:14 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: scripts/tags.sh: Add magic for pci access functions
MIME-Version: 1.0
Message-Id: <624341345801828@web28e.yandex.ru>
Date: Fri, 24 Aug 2012 13:50:28 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/tags.sh: Add magic for pci access functions

Make [ce]tags find the pci_bus_read_config_* and pci_bus_write_config_*
definitions

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
---
scripts/tags.sh |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)
diff --git a/scripts/tags.sh b/scripts/tags.sh
index cff8faa..79fdafb 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -154,7 +154,9 @@ exuberant()
 	--regex-c++='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/'	\
 	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
 	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
-	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'
+	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
+	--regex-c='/PCI_OP_READ\(([a-z]*[a-z]).*[1-4]\)/pci_bus_read_config_\1/' \
+	--regex-c='/PCI_OP_WRITE\(([a-z]*[a-z]).*[1-4]\)/pci_bus_write_config_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -197,7 +199,9 @@ emacs()
 	--regex='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/' \
 	--regex='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
 	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
-	--regex='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'
+	--regex='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
+	--regex='/PCI_OP_READ\(([a-z]*[a-z]).*[1-4]\)/pci_bus_read_config_\1/' \
+	--regex='/PCI_OP_WRITE\(([a-z]*[a-z]).*[1-4]\)/pci_bus_write_config_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
