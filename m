Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040Ab1D0VgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:36:04 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:33757 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756699Ab1D0Vf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:35:59 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB88C14.4010900@verizon.net>
Date: Wed, 27 Apr 2011 17:35:16 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH V2 resend 3/7] kbuild: change gconf to modify hostprogs-y
 like nconf and mconf
Content-Type: multipart/mixed;
	boundary="------------010801000507040802040508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------010801000507040802040508
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch makes gconf more like nconf and mconf
by modifying hostprogs insted of gconf-objs.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index b0b3dcb..74d9512 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -170,8 +170,9 @@ nconf-objs     := nconf.o zconf.tab.o nconf.gui.o
 kxgettext-objs	:= kxgettext.o zconf.tab.o
 qconf-cxxobjs	:= qconf.o
 qconf-objs	:= kconfig_load.o zconf.tab.o
+gconf-objs	:= gconf.o kconfig_load.o zconf.tab.o

-hostprogs-y := conf gconf
+hostprogs-y := conf

 ifeq ($(MAKECMDGOALS),nconfig)
 	hostprogs-y += nconf
@@ -198,7 +199,7 @@ ifeq ($(qconf-target),1)
 endif

 ifeq ($(gconf-target),1)
-gconf-objs	:= gconf.o kconfig_load.o zconf.tab.o
+	hostprogs-y += gconf
 endif

 clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck \
-- 
1.7.5.rc1




--------------010801000507040802040508
Content-Type: text/plain;
	name="kbuild-change-gconf-to-modify-hostprogs-y-like-nconf.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-change-gconf-to-modify-hostprogs-y-like-nconf.patch"

>From 1e1409fed85ecc657f7929154c6c0930bfebab96 Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 18:02:08 -0400
Subject: [PATCH 3/7] kbuild: change gconf to modify hostprogs-y like nconf
 and mconf


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index b0b3dcb..74d9512 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -170,8 +170,9 @@ nconf-objs     := nconf.o zconf.tab.o nconf.gui.o
 kxgettext-objs	:= kxgettext.o zconf.tab.o
 qconf-cxxobjs	:= qconf.o
 qconf-objs	:= kconfig_load.o zconf.tab.o
+gconf-objs	:= gconf.o kconfig_load.o zconf.tab.o
 
-hostprogs-y := conf gconf
+hostprogs-y := conf
 
 ifeq ($(MAKECMDGOALS),nconfig)
 	hostprogs-y += nconf
@@ -198,7 +199,7 @@ ifeq ($(qconf-target),1)
 endif
 
 ifeq ($(gconf-target),1)
-gconf-objs	:= gconf.o kconfig_load.o zconf.tab.o
+	hostprogs-y += gconf
 endif
 
 clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck \
-- 
1.7.5.rc1




--------------010801000507040802040508--
