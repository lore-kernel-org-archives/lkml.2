Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360Ab2EJReH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:34:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52779 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760324Ab2EJReB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:01 -0400
Message-Id: <20120510173134.085076323@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H.J. Lu" <hjl.tools@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [ 13/52] asm-generic: Use __BITS_PER_LONG in statfs.h
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/asm-generic/statfs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


