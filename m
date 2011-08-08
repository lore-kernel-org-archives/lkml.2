Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1HHIyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:54:46 -0400
Received: from trent.utfs.org ([194.246.123.103]:56848 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab1HHIyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:54:43 -0400
Date: Mon, 8 Aug 2011 01:54:39 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: jeremy.fitzhardinge@citrix.com, konrad.wilk@oracle.com
cc: LKML <linux-kernel@vger.kernel.org>
Subject: redefinition of typedef '__guest_handle_uint64_t'
Message-ID: <alpine.DEB.2.01.1108080146000.9183@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when trying to compile xen/next-3.0 from Jeremy's tree, this happens:

---------------------------------------------------
/usr/local/src/linux-xen-next-3-git/arch/x86/kernel/asm-offsets.c:8:
/usr/local/src/linux-xen-next-3-git/include/xen/interface/xen.h:527:1: 
error: redefinition of typedef '__guest_handle_uint64_t'
/usr/local/src/linux-xen-next-3-git/arch/x86/include/asm/xen/interface.h:58:1: 
note: previous declaration of '__guest_handle_uint64_t' was here
---------------------------------------------------

The .config is here: http://nerdbynature.de/bits/3.0-rc7/
The following makes it compile again, but it may not be the Right Thing 
to do:

diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 3c072c8..5a91c66 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -524,8 +524,6 @@ struct tmem_op {
 	} u;
 };
 
-DEFINE_GUEST_HANDLE(uint64_t);
-
 #else /* __ASSEMBLY__ */
 
 /* In assembly code we cannot use C numeric constant suffixes. */


Thanks,
Christian.
-- 
BOFH excuse #100:

IRQ dropout
