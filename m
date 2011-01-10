Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab1AJGRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 01:17:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61204 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1AJGRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 01:17:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vpkwRRyqkRuaW31NIEQ6TheVsz1ylYwIsG6Ixj+Otu87HOFxPqtLX9q3NS++ydZe73
         /B9vJ+Uu/yDT4VANInqhaq5x0RMle5L08gKdtsj9ykS+Y4VgRY3XQd2cWOCZqUz8TtPb
         6sc1G4sodumlhZ0H3A0qRNACxa6qwYCfjuc9A=
Date: Mon, 10 Jan 2011 08:17:10 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] headers: path.h redux
Message-ID: <20110110061710.GA19138@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove path.h from sched.h and other files.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/audit.h            |    1 +
 include/linux/dcookies.h         |    2 +-
 include/linux/sched.h            |    1 -
 security/apparmor/include/file.h |    3 +--
 security/selinux/include/avc.h   |    1 -
 5 files changed, 3 insertions(+), 5 deletions(-)

--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -372,6 +372,7 @@ struct audit_buffer;
 struct audit_context;
 struct inode;
 struct netlink_skb_parms;
+struct path;
 struct linux_binprm;
 struct mq_attr;
 struct mqstat;
--- a/include/linux/dcookies.h
+++ b/include/linux/dcookies.h
@@ -13,10 +13,10 @@
 #ifdef CONFIG_PROFILING
  
 #include <linux/dcache.h>
-#include <linux/path.h>
 #include <linux/types.h>
  
 struct dcookie_user;
+struct path;
  
 /**
  * dcookie_register - register a user of dcookies
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -70,7 +70,6 @@ struct sched_param {
 #include <linux/smp.h>
 #include <linux/sem.h>
 #include <linux/signal.h>
-#include <linux/path.h>
 #include <linux/compiler.h>
 #include <linux/completion.h>
 #include <linux/pid.h>
--- a/security/apparmor/include/file.h
+++ b/security/apparmor/include/file.h
@@ -15,12 +15,11 @@
 #ifndef __AA_FILE_H
 #define __AA_FILE_H
 
-#include <linux/path.h>
-
 #include "domain.h"
 #include "match.h"
 
 struct aa_profile;
+struct path;
 
 /*
  * We use MAY_EXEC, MAY_WRITE, MAY_READ, MAY_APPEND and the following flags
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -15,7 +15,6 @@
 #include <linux/audit.h>
 #include <linux/lsm_audit.h>
 #include <linux/in6.h>
-#include <linux/path.h>
 #include <asm/system.h>
 #include "flask.h"
 #include "av_permissions.h"
