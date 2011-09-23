Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1IWOTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:19:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52262 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab1IWOT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:19:26 -0400
From: penberg@cs.helsinki.fi
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>, <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] media, rc: Use static inline functions to kill warnings
Date: Fri, 23 Sep 2011 17:19:07 +0300
Message-Id: <1316787547-1971-2-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1316787547-1971-1-git-send-email-penberg@cs.helsinki.fi>
References: <1316787547-1971-1-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@kernel.org>

This patch converts some ifdef'd wrapper functions from macros to static inline
functions to kill the following warnings issued by GCC:

    CC [M]  drivers/media/rc/ir-raw.o
  drivers/media/rc/ir-raw.c: In function ‘init_decoders’:
  drivers/media/rc/ir-raw.c:353:2: warning: statement with no effect [-Wunused-value]
  drivers/media/rc/ir-raw.c:354:2: warning: statement with no effect [-Wunused-value]
  drivers/media/rc/ir-raw.c:355:2: warning: statement with no effect [-Wunused-value]
  drivers/media/rc/ir-raw.c:356:2: warning: statement with no effect [-Wunused-value]
  drivers/media/rc/ir-raw.c:357:2: warning: statement with no effect [-Wunused-value]
  drivers/media/rc/ir-raw.c:359:2: warning: statement with no effect [-Wunused-value]

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "David Härdeman" <david@hardeman.nu>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/media/rc/rc-core-priv.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 04c2c72..c6ca870 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -162,49 +162,49 @@ void ir_raw_init(void);
 #ifdef CONFIG_IR_NEC_DECODER_MODULE
 #define load_nec_decode()	request_module("ir-nec-decoder")
 #else
-#define load_nec_decode()	0
+static inline void load_nec_decode(void) { }
 #endif
 
 /* from ir-rc5-decoder.c */
 #ifdef CONFIG_IR_RC5_DECODER_MODULE
 #define load_rc5_decode()	request_module("ir-rc5-decoder")
 #else
-#define load_rc5_decode()	0
+static inline void load_rc5_decode(void) { }
 #endif
 
 /* from ir-rc6-decoder.c */
 #ifdef CONFIG_IR_RC6_DECODER_MODULE
 #define load_rc6_decode()	request_module("ir-rc6-decoder")
 #else
-#define load_rc6_decode()	0
+static inline void load_rc6_decode(void) { }
 #endif
 
 /* from ir-jvc-decoder.c */
 #ifdef CONFIG_IR_JVC_DECODER_MODULE
 #define load_jvc_decode()	request_module("ir-jvc-decoder")
 #else
-#define load_jvc_decode()	0
+static inline void load_jvc_decode(void) { }
 #endif
 
 /* from ir-sony-decoder.c */
 #ifdef CONFIG_IR_SONY_DECODER_MODULE
 #define load_sony_decode()	request_module("ir-sony-decoder")
 #else
-#define load_sony_decode()	0
+static inline void load_sony_decode(void) { }
 #endif
 
 /* from ir-mce_kbd-decoder.c */
 #ifdef CONFIG_IR_MCE_KBD_DECODER_MODULE
 #define load_mce_kbd_decode()	request_module("ir-mce_kbd-decoder")
 #else
-#define load_mce_kbd_decode()	0
+static inline void load_mce_kbd_decode(void) { }
 #endif
 
 /* from ir-lirc-codec.c */
 #ifdef CONFIG_IR_LIRC_CODEC_MODULE
 #define load_lirc_codec()	request_module("ir-lirc-codec")
 #else
-#define load_lirc_codec()	0
+static inline void load_lirc_codec(void) { }
 #endif
 
 
-- 
1.7.6.2

