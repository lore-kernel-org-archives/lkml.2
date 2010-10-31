Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab0JaPNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 11:13:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64290 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab0JaPNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 11:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=pLNDIGz5/6R514+iK841fb/E+3XUHn6S1EcKayIfNvlUyX4dTjucHU3oJuH20x2rPk
         58y+YSA6VXjy6raM5WAZT6qpiq+oAiF+aJ5sp4P6/tuKQuxmRRk+Rp+sN32FR6lICc3X
         Fj3n4ZCqH6GSIoLdWia5ItLbtb/oczsSa0Csg=
MIME-Version: 1.0
Date: Sun, 31 Oct 2010 18:13:31 +0300
Message-ID: <AANLkTimtfUXN9oTQ=BaxNz+h+mgwFBPrzN_Nggbai+ZJ@mail.gmail.com>
Subject: Why get/put_unaligned are hidden behind #ifdef __KERNEL__ on PowerPC
 and Microblaze?
From: Igor Zhbanov <izh1979@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have found that functions get_unaligned and put_unaligned from unaligned.h
are hidden behind #ifdef __KERNEL__ on PowerPC and Microblaze architectures.
And are not hidden on other platforms. But why?
I think that these functions are very useful in user space.

So here is the patch:

diff -purN -U 5 linux-2.6.36/arch/microblaze/include/asm/unaligned.h
linux/arch/microblaze/include/asm/unaligned.h
--- linux-2.6.36/arch/microblaze/include/asm/unaligned.h	2010-10-21
00:30:22.000000000 +0400
+++ linux/arch/microblaze/include/asm/unaligned.h	2010-10-31
18:05:31.513345000 +0300
@@ -8,16 +8,13 @@
  */

 #ifndef _ASM_MICROBLAZE_UNALIGNED_H
 #define _ASM_MICROBLAZE_UNALIGNED_H

-# ifdef __KERNEL__
-
 # include <linux/unaligned/be_struct.h>
 # include <linux/unaligned/le_byteshift.h>
 # include <linux/unaligned/generic.h>

 # define get_unaligned	__get_unaligned_be
 # define put_unaligned	__put_unaligned_be

-# endif	/* __KERNEL__ */
 #endif /* _ASM_MICROBLAZE_UNALIGNED_H */
diff -purN -U 5 linux-2.6.36/arch/powerpc/include/asm/unaligned.h
linux/arch/powerpc/include/asm/unaligned.h
--- linux-2.6.36/arch/powerpc/include/asm/unaligned.h	2010-10-21
00:30:22.000000000 +0400
+++ linux/arch/powerpc/include/asm/unaligned.h	2010-10-31
18:05:43.968057400 +0300
@@ -1,16 +1,13 @@
 #ifndef _ASM_POWERPC_UNALIGNED_H
 #define _ASM_POWERPC_UNALIGNED_H

-#ifdef __KERNEL__
-
 /*
  * The PowerPC can do unaligned accesses itself in big endian mode.
  */
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>

 #define get_unaligned	__get_unaligned_be
 #define put_unaligned	__put_unaligned_be

-#endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_UNALIGNED_H */
