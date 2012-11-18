Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab2KRHLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 02:11:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17147 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab2KRHJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 02:09:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 10/13] x86, boot: update cmd_line_ptr to unsigned long
Date: Sat, 17 Nov 2012 23:09:28 -0800
Message-Id: <1353222571-31544-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

boot/compressed/misc.c could be with 64 bit, and cmd_line_ptr could
above 4g.

So change to unsigned long instead. that will be 64bit in 64bit,
and 32bit in 32bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/boot.h    |    8 ++++----
 arch/x86/boot/cmdline.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 7fadf80..5b75319 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -285,11 +285,11 @@ struct biosregs {
 void intcall(u8 int_no, const struct biosregs *ireg, struct biosregs *oreg);
 
 /* cmdline.c */
-int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int bufsize);
-int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option);
+int __cmdline_find_option(unsigned long cmdline_ptr, const char *option, char *buffer, int bufsize);
+int __cmdline_find_option_bool(unsigned long cmdline_ptr, const char *option);
 static inline int cmdline_find_option(const char *option, char *buffer, int bufsize)
 {
-	u32 cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
 
 	if (cmd_line_ptr >= 0x100000)
 		return -1;      /* inaccessible */
@@ -299,7 +299,7 @@ static inline int cmdline_find_option(const char *option, char *buffer, int bufs
 
 static inline int cmdline_find_option_bool(const char *option)
 {
-	u32 cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
+	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
 
 	if (cmd_line_ptr >= 0x100000)
 		return -1;      /* inaccessible */
diff --git a/arch/x86/boot/cmdline.c b/arch/x86/boot/cmdline.c
index 768f00f..625d21b 100644
--- a/arch/x86/boot/cmdline.c
+++ b/arch/x86/boot/cmdline.c
@@ -27,7 +27,7 @@ static inline int myisspace(u8 c)
  * Returns the length of the argument (regardless of if it was
  * truncated to fit in the buffer), or -1 on not found.
  */
-int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int bufsize)
+int __cmdline_find_option(unsigned long cmdline_ptr, const char *option, char *buffer, int bufsize)
 {
 	addr_t cptr;
 	char c;
@@ -99,7 +99,7 @@ int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int
  * Returns the position of that option (starts counting with 1)
  * or 0 on not found
  */
-int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option)
+int __cmdline_find_option_bool(unsigned long cmdline_ptr, const char *option)
 {
 	addr_t cptr;
 	char c;
-- 
1.7.7

