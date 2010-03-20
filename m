Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab0CTKk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 06:40:59 -0400
Received: from www84.your-server.de ([213.133.104.84]:48525 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab0CTKk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 06:40:58 -0400
Subject: Re: [PATCH] fix KFIFO_INIT in include/linux/kfifo.h
From: Stefani Seibold <stefani@seibold.net>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100320084157.GA5050@hardeman.nu>
References: <20100320084157.GA5050@hardeman.nu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 20 Mar 2010 11:41:22 +0100
Message-ID: <1269081682.32116.3.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/kfifo.h first defines and then undefines __kfifo_initializer
which is used by INIT_KFIFO (which is also a macro, so building a module
which uses INIT_KFIFO will fail).

Signed-off-by: David Härdeman <david@hardeman.nu>
Acked-by: Stefani Seibold <stefani@seibold.net>
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


