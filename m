Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042Ab1DZWqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:46:02 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:58548 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759032Ab1DZWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:45:57 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB74AFB.6080404@verizon.net>
Date: Tue, 26 Apr 2011 18:45:15 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH V2 3/7] kbuild: change gconf to modify hostprogs-y like nconf
 and mconf
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
