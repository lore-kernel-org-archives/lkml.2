Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049Ab2DKX1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:27:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38577 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933526Ab2DKX1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:27:37 -0400
Message-Id: <20120411231307.478617900@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Feiran Zhuang <zhuangfeiran@ict.ac.cn>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 01/42] x86 bpf_jit: fix a bug in emitting the 16-bit immediate operand of AND
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "zhuangfeiran@ict.ac.cn" <zhuangfeiran@ict.ac.cn>

[ Upstream commit 1d24fb3684f347226747c6b11ea426b7b992694e ]

When K >= 0xFFFF0000, AND needs the two least significant bytes of K as
its operand, but EMIT2() gives it the least significant byte of K and
0x2. EMIT() should be used here to replace EMIT2().

Signed-off-by: Feiran Zhuang  <zhuangfeiran@ict.ac.cn>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -289,7 +289,7 @@ void bpf_jit_compile(struct sk_filter *f
 					EMIT2(0x24, K & 0xFF); /* and imm8,%al */
 				} else if (K >= 0xFFFF0000) {
 					EMIT2(0x66, 0x25);	/* and imm16,%ax */
-					EMIT2(K, 2);
+					EMIT(K, 2);
 				} else {
 					EMIT1_off32(0x25, K);	/* and imm32,%eax */
 				}


