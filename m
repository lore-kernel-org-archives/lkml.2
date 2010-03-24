Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab0CXHSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 03:18:12 -0400
Received: from www84.your-server.de ([213.133.104.84]:43490 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab0CXHSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 03:18:10 -0400
Subject: Re: [PATCH] fix INIT_KFIFO in include/linux/kfifo.h - part 2
From: Stefani Seibold <stefani@seibold.net>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100323222613.GA6915@hardeman.nu>
References: <20100323222613.GA6915@hardeman.nu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 24 Mar 2010 08:18:40 +0100
Message-ID: <1269415120.19347.1.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DECLARE_KFIFO creates a union with a struct kfifo and a buffer array with
size [size + sizeof(struct kfifo)].

INIT_KFIFO then sets the buffer pointer in struct kfifo to point to the
beginning of the buffer array which means that the first call to kfifo_in
will overwrite members of the struct kfifo.

This patch was the least invasive fix I could come up with...

Signed-off-by: David Härdeman <david@hardeman.nu>
Acked-by: stefani@seibold.net
CC: stable@kernel.org
---
 include/linux/kfifo.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index ece0b1c..e117b1a 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -86,7 +86,8 @@ union { \
  */
 #define INIT_KFIFO(name) \
 	name = __kfifo_initializer(sizeof(name##kfifo_buffer) - \
-				sizeof(struct kfifo), name##kfifo_buffer)
+				sizeof(struct kfifo), \
+				name##kfifo_buffer + sizeof(struct kfifo))
 
 /**
  * DEFINE_KFIFO - macro to define and initialize a kfifo


