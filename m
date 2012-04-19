Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab2DSV63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:58:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38883 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634Ab2DSVHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:07:02 -0400
Message-Id: <20120419210306.541037055@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeremy Fitzhardinge <jeremy@goop.org>,
        Leigh Scott <leigh123linux@googlemail.com>,
        Thomas Reitmayr <treitmayr@devbase.at>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 40/75] x86: Use correct byte-sized register constraint in
 __xchg_op()
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Fitzhardinge <jeremy@goop.org>

commit 2ca052a3710fac208eee690faefdeb8bbd4586a1 upstream.

x86-64 can access the low half of any register, but i386 can only do
it with a subset of registers.  'r' causes compilation failures on i386,
but 'q' expresses the constraint properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Link: http://lkml.kernel.org/r/4F7A3315.501@goop.org
Reported-by: Leigh Scott <leigh123linux@googlemail.com>
Tested-by: Thomas Reitmayr <treitmayr@devbase.at>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/cmpxchg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -43,7 +43,7 @@ extern void __add_wrong_size(void)
 		switch (sizeof(*(ptr))) {				\
 		case __X86_CASE_B:					\
 			asm volatile (lock #op "b %b0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : "+q" (__ret), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_W:					\


