Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985Ab1DZWpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:45:31 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:58484 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758973Ab1DZWpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:45:30 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB74AE0.80409@verizon.net>
Date: Tue, 26 Apr 2011 18:44:48 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH V2 1/7] kbuild: only build kxgettext when needed
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch only builds kxgettext when running update-po-config
which is the only target that uses it.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 368ae30..fec830f 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -169,7 +169,7 @@ mconf-objs     := mconf.o zconf.tab.o $(lxdialog)
 nconf-objs     := nconf.o zconf.tab.o nconf.gui.o
 kxgettext-objs	:= kxgettext.o zconf.tab.o

-hostprogs-y := conf qconf gconf kxgettext
+hostprogs-y := conf qconf gconf

 ifeq ($(MAKECMDGOALS),nconfig)
 	hostprogs-y += nconf
@@ -179,6 +179,10 @@ ifeq ($(MAKECMDGOALS),menuconfig)
 	hostprogs-y += mconf
 endif

+ifeq($(MAKECMDGOALS),update-po-config)
+	hostprogs-y += kxgettext
+endif
+
 ifeq ($(MAKECMDGOALS),xconfig)
 	qconf-target := 1
 endif
-- 
1.7.5.rc1

