Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab1DZWqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:46:33 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:58690 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759037Ab1DZWq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:46:28 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB74B1B.3000100@verizon.net>
Date: Tue, 26 Apr 2011 18:45:47 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH V2 6/7] kbuild: change update-po-config to reflect new layout
 of arch/um
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes update-po-config to reflect the new layout of arch/um.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 4507336..0674e78 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -84,7 +84,7 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    --directory=$(srctree) --directory=$(objtree)           \
 	    --output $(obj)/config.pot
 	$(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
-	$(Q)ln -fs Kconfig.i386 arch/um/Kconfig.arch
+	$(Q)ln -fs Kconfig.x86 arch/um/Kconfig
 	$(Q)(for i in `ls $(srctree)/arch/*/Kconfig`;    \
 	    do                                           \
 		echo "  GEN $$i";                        \
@@ -93,7 +93,7 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    done )
 	$(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
 	    --output $(obj)/linux.pot
-	$(Q)rm -f $(srctree)/arch/um/Kconfig.arch
+	$(Q)rm -f $(srctree)/arch/um/Kconfig
 	$(Q)rm -f $(obj)/config.pot

 PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig
-- 
1.7.5.rc1

