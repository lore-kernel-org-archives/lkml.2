Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1BROzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:55:10 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59117 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1BROzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:55:07 -0500
Date: Fri, 18 Feb 2011 08:55:02 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Kees Cook <kees@ubuntu.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] Update manpages with CAP_SYSLOG info
Message-ID: <20110218145502.GA7138@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Here my attempt at a man-pages update to specify CAP_SYSLOG.

thanks,
-serge

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 man2/syslog.2       |    4 +++-
 man7/capabilities.7 |    9 +++++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/man2/syslog.2 b/man2/syslog.2
index fb018a6..7383e2f 100644
--- a/man2/syslog.2
+++ b/man2/syslog.2
@@ -237,7 +237,9 @@ An attempt was made to change console_loglevel or clear the kernel
 message ring buffer by a process without sufficient privilege
 (more precisely: without the
 .B CAP_SYS_ADMIN
-capability).
+or
+.B CAP_SYSLOG
+(since 2.6.38) capability).
 .TP
 .B ERESTARTSYS
 System call was interrupted by a signal; nothing was read.
diff --git a/man7/capabilities.7 b/man7/capabilities.7
index a751b21..55177dc 100644
--- a/man7/capabilities.7
+++ b/man7/capabilities.7
@@ -236,6 +236,9 @@ Perform a range of system administration operations including:
 .BR umount (2),
 .BR swapon (2),
 .BR swapoff (2),
+privileged
+.BR syslog(2)
+operations (see CAP_SYSLOG),
 .BR sethostname (2),
 and
 .BR setdomainname (2);
@@ -421,6 +424,12 @@ set real-time (hardware) clock.
 .B CAP_SYS_TTY_CONFIG
 Use
 .BR vhangup (2).
+.TP
+.B CAP_SYSLOG
+Since 2.6.38, this capability can be substituted for CAP_SYS_ADMIN for
+privileged syslog(2) actions.  When dmesg_restrict is set, that means
+any call to syslog.  Otherwise, it means any action other than reading
+the last kernel messages or getting the size of the log buffer.
 .\"
 .SS Past and Current Implementation
 A full implementation of capabilities requires that:
-- 
1.7.2.3

