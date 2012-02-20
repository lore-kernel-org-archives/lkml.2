Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2BTAOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:14:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2BTAOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:14:03 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com, Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 11/30] aio: Use __kernel_ulong_t to define aio_context_t
Date: Sun, 19 Feb 2012 16:07:49 -0800
Message-Id: <1329696488-16970-12-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:13:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Rather than using "unsigned long" which is ABI-dependent, use
__kernel_ulong_t to define the externally visible type aio_context_t.

Note: the change in this form will cause unsigned long/unsigned int
differences on existing ABIs.  If that is unacceptable we may have to
define a new type.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
---
 include/linux/aio_abi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/aio_abi.h b/include/linux/aio_abi.h
index 2c87316..86fa7a7 100644
--- a/include/linux/aio_abi.h
+++ b/include/linux/aio_abi.h
@@ -30,7 +30,7 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
-typedef unsigned long	aio_context_t;
+typedef __kernel_ulong_t aio_context_t;
 
 enum {
 	IOCB_CMD_PREAD = 0,
-- 
1.7.6.5

