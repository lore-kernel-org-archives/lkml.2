Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965815Ab2C3VTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:19:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965759Ab2C3VTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:14 -0400
Message-Id: <20120330194833.795278454@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [ 050/175] math: Introduce div64_long
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <levinsasha928@gmail.com>

commit f910381a55cdaa097030291f272f6e6e4380c39a upstream.

Add a div64_long macro which is used to devide a 64bit number by a long (which
can be 4 bytes on 32bit systems and 8 bytes on 64bit systems).

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: johnstul@us.ibm.com
Link: http://lkml.kernel.org/r/1331829374-31543-1-git-send-email-levinsasha928@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/math64.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -6,6 +6,8 @@
 
 #if BITS_PER_LONG == 64
 
+#define div64_long(x,y) div64_s64((x),(y))
+
 /**
  * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
  *
@@ -45,6 +47,8 @@ static inline s64 div64_s64(s64 dividend
 
 #elif BITS_PER_LONG == 32
 
+#define div64_long(x,y) div_s64((x),(y))
+
 #ifndef div_u64_rem
 static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
 {


