Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab1D0Vgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:36:38 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:33979 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760068Ab1D0Vgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:36:35 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB88C39.4070102@verizon.net>
Date: Wed, 27 Apr 2011 17:35:53 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH V2 resend 7/7] kbuild: quiet commands unless V=1
Content-Type: multipart/mixed;
	boundary="------------030909080201010903070806"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------030909080201010903070806
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch quiets some commands unless V=1.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 0674e78..572e5fa 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -328,11 +328,11 @@ $(obj)/%.moc: $(src)/%.h
 	$(KC_QT_MOC) -i $< -o $@

 $(obj)/lkc_defs.h: $(src)/lkc_proto.h
-	sed < $< > $@ 's/P(\([^,]*\),.*/#define \1 (\*\1_p)/'
+	$(Q)sed < $< > $@ 's/P(\([^,]*\),.*/#define \1 (\*\1_p)/'

 # Extract gconf menu items for I18N support
 $(obj)/gconf.glade.h: $(obj)/gconf.glade
-	intltool-extract --type=gettext/glade --srcdir=$(srctree) \
+	$(Q)intltool-extract --type=gettext/glade --srcdir=$(srctree) \
 	$(obj)/gconf.glade

 ###
-- 
1.7.5.rc1



--------------030909080201010903070806
Content-Type: text/plain; name="kbuild-quiet-commands-when-V-0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-quiet-commands-when-V-0.patch"

>From a1ae26a8d3fa3d207c2729367ee8b1e958adc7db Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 18:16:53 -0400
Subject: [PATCH 7/7] kbuild: quiet commands when V=0


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 0674e78..572e5fa 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -328,11 +328,11 @@ $(obj)/%.moc: $(src)/%.h
 	$(KC_QT_MOC) -i $< -o $@
 
 $(obj)/lkc_defs.h: $(src)/lkc_proto.h
-	sed < $< > $@ 's/P(\([^,]*\),.*/#define \1 (\*\1_p)/'
+	$(Q)sed < $< > $@ 's/P(\([^,]*\),.*/#define \1 (\*\1_p)/'
 
 # Extract gconf menu items for I18N support
 $(obj)/gconf.glade.h: $(obj)/gconf.glade
-	intltool-extract --type=gettext/glade --srcdir=$(srctree) \
+	$(Q)intltool-extract --type=gettext/glade --srcdir=$(srctree) \
 	$(obj)/gconf.glade
 
 ###
-- 
1.7.5.rc1



--------------030909080201010903070806--
