Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab2EIGLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:11:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39143 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618Ab2EIFxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:31 -0400
Message-Id: <20120509055050.559732444@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:53:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [ 152/167] [PATCH] asm-generic: Use __BITS_PER_LONG in statfs.h
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit f5c2347ee20a8d6964d6a6b1ad04f200f8d4dfa7 upstream.

<asm-generic/statfs.h> is exported to userspace, so using
BITS_PER_LONG is invalid.  We need to use __BITS_PER_LONG instead.

This is kernel bugzilla 43165.

Reported-by: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1335465916-16965-1-git-send-email-hpa@linux.intel.com
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/asm-generic/statfs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/statfs.h b/include/asm-generic/statfs.h
index 0fd28e0..c749af9 100644
--- a/include/asm-generic/statfs.h
+++ b/include/asm-generic/statfs.h
@@ -15,7 +15,7 @@ typedef __kernel_fsid_t	fsid_t;
  * with a 10' pole.
  */
 #ifndef __statfs_word
-#if BITS_PER_LONG == 64
+#if __BITS_PER_LONG == 64
 #define __statfs_word long
 #else
 #define __statfs_word __u32
-- 
1.7.10



