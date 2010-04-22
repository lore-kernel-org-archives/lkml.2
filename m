Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab0DVUi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:38:56 -0400
Received: from kroah.org ([198.145.64.141]:37437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab0DVT2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:05 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:11 2010
Message-Id: <20100422190911.855808834@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jslaby@suse.cz>, maximilian attems <max@stro.at>
Subject: [050/197] resource: move kernel function inside __KERNEL__
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 96d07d211739fd2450ac54e81d00fa40fcd4b1bd upstream
From: Jiri Slaby <jslaby@suse.cz>

resource: move kernel function inside __KERNEL__

It is an internal function. Move it inside __KERNEL__ ifdef, along
with task_struct declaration.

Then we get:
#--- /usr/include/linux/resource.h       2009-09-14 15:09:29.000000000 +0200
#+++ usr/include/linux/resource.h       2010-01-04 11:30:54.000000000 +0100
#@@ -3,8 +3,6 @@
#
##include <linux/time.h>
#
#-struct task_struct;
#-
#/*
#* Resource control/accounting header file for linux
#*/
#@@ -70,6 +68,5 @@
#*/
##include <asm/resource.h>
#
#-int getrusage(struct task_struct *p, int who, struct rusage *ru);
#
##endif
#
#***********

include/linux/Kbuild is untouched, since unifdef is run even on
headers-y nowadays.

backport to 2.6.32 by maximilian attems <max@stro.at>
Patch commented out by gregkh due to quilt complaining.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/resource.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -3,8 +3,6 @@
 
 #include <linux/time.h>
 
-struct task_struct;
-
 /*
  * Resource control/accounting header file for linux
  */
@@ -70,6 +68,12 @@ struct rlimit {
  */
 #include <asm/resource.h>
 
+#ifdef __KERNEL__
+
+struct task_struct;
+
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru);
 
+#endif /* __KERNEL__ */
+
 #endif


