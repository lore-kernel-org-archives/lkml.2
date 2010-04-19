Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0DSRBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 13:01:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43831 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab0DSRBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 13:01:51 -0400
Date: Mon, 19 Apr 2010 10:00:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Subject: trace-cmd: make Makefile rpm-friendly
Message-Id: <20100419100058.6f1457dd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BCC8C7C.0140:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update Makefile to support rpmbuild DESTDIR usage.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Makefile |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- trace-cmd-0.7.0.orig/Makefile
+++ trace-cmd-0.7.0/Makefile
@@ -18,10 +18,11 @@ AR = $(CROSS_COMPILE)ar
 EXT = -std=gnu99
 INSTALL = install
 
+DESTDIR =
 prefix ?= /usr/local
 bindir_relative = bin
-bindir = $(prefix)/$(bindir_relative)
-man_dir = $(prefix)/share/man
+bindir = $(DESTDIR)/$(prefix)/$(bindir_relative)
+man_dir = $(DESTDIR)/$(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
 
 export man_dir man_dir_SQ INSTALL
@@ -29,7 +30,7 @@ export man_dir man_dir_SQ INSTALL
 ifeq ($(prefix),$(HOME))
 plugin_dir = $(HOME)/.trace-cmd/plugins
 else
-plugin_dir = $(prefix)/share/trace-cmd/plugins
+plugin_dir = $(DESTDIR)/$(prefix)/share/trace-cmd/plugins
 PLUGIN_DIR = -DPLUGIN_DIR=$(plugin_dir)
 PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
 endif
