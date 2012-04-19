Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab2DSVMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:12:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50404 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2DSVMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:12:20 -0400
Message-Id: <20120419210306.628270838@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Leigh Scott <leigh123linux@googlemail.com>,
        Thomas Reitmayr <treitmayr@devbase.at>
Subject: [ 41/75] x86: Use correct byte-sized register constraint in __add()
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@zytor.com>

commit 8c91c5325e107ec17e40a59a47c6517387d64eb7 upstream.

Similar to:

 2ca052a x86: Use correct byte-sized register constraint in __xchg_op()

... the __add() macro also needs to use a "q" constraint in the
byte-sized case, lest we try to generate an illegal register.

Link: http://lkml.kernel.org/r/4F7A3315.501@goop.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Leigh Scott <leigh123linux@googlemail.com>
Cc: Thomas Reitmayr <treitmayr@devbase.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/cmpxchg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -173,7 +173,7 @@ extern void __add_wrong_size(void)
 		switch (sizeof(*(ptr))) {				\
 		case __X86_CASE_B:					\
 			asm volatile (lock "addb %b1, %0\n"		\
-				      : "+m" (*(ptr)) : "ri" (inc)	\
+				      : "+m" (*(ptr)) : "qi" (inc)	\
 				      : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_W:					\


