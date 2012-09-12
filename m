Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2IMAKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:10:23 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab2ILXj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:39:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Michael Hench <michaelhench@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 30/85] UBIFS: fix complaints about too small debug buffer size
Date: Wed, 12 Sep 2012 16:36:13 -0700
Message-Id: <20120912233544.892785625@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 65b455b123c7e2b835a0b7148f9bae584f95000e upstream.

When debugging is enabled, we use a temporary on-stack buffer for formatting
the key strings like "(11368871, direntry, 0xcd0750)". The buffer size is
32 bytes and sometimes it is not enough to fit the key string - e.g., when
inode numbers are high. This is not fatal, but the key strings are incomplete
and UBIFS complains like this:

	UBIFS assert failed in dbg_snprintf_key at 137 (pid 1)

This is a regression caused by "515315a UBIFS: fix key printing".

Fix the issue by increasing the buffer to 48 bytes.

Reported-by: Michael Hench <michaelhench@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Tested-by: Michael Hench <michaelhench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/debug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ubifs/debug.h
+++ b/fs/ubifs/debug.h
@@ -170,7 +170,7 @@ struct ubifs_global_debug_info {
 #define ubifs_dbg_msg(type, fmt, ...) \
 	pr_debug("UBIFS DBG " type ": " fmt "\n", ##__VA_ARGS__)
 
-#define DBG_KEY_BUF_LEN 32
+#define DBG_KEY_BUF_LEN 48
 #define ubifs_dbg_msg_key(type, key, fmt, ...) do {                            \
 	char __tmp_key_buf[DBG_KEY_BUF_LEN];                                   \
 	pr_debug("UBIFS DBG " type ": " fmt "%s\n", ##__VA_ARGS__,             \


