Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0CTImF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 04:42:05 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:37296 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0CTImB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 04:42:01 -0400
Date: Sat, 20 Mar 2010 09:41:57 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Cc: stefani@seibold.net
Subject: [PATCH] fix KFIFO_INIT in include/linux/kfifo.h
Message-ID: <20100320084157.GA5050@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org, stefani@seibold.net
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/kfifo.h first defines and then undefines __kfifo_initializer
which is used by INIT_KFIFO (which is also a macro, so building a module
which uses INIT_KFIFO will fail).

Signed-off-by: David Härdeman <david@hardeman.nu>
CC: stable@kernel.org
CC: stefani@seibold.net
---
 include/linux/kfifo.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index bc0fc79..ece0b1c 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -102,8 +102,6 @@ union { \
 	unsigned char name##kfifo_buffer[size]; \
 	struct kfifo name = __kfifo_initializer(size, name##kfifo_buffer)
 
-#undef __kfifo_initializer
-
 extern void kfifo_init(struct kfifo *fifo, void *buffer,
 			unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
-- 
1.7.0

