Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2C2JdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:33:20 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:39050 "EHLO cstnet.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753322Ab2C2JdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:33:12 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2012 05:33:11 EDT
Message-ID: <4F742AE4.6050006@ict.ac.cn>
Date: Thu, 29 Mar 2012 17:27:00 +0800
From: "zhuangfeiran@ict.ac.cn" <zhuangfeiran@ict.ac.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: davem@davemloft.net
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: [PATCH] fix a bug in emitting the 16-bit immediate operand of AND
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: RgCowJCbCGjVKnRPwCnNAg--.55256S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKF4fCr47KFy8GF4xAw47Arb_yoW3ZrX_Xr
	1UJa97GwsYv347A3W5Cr4fCrsxCwnxCr4fXrnagry2y3s0yF45JFWvg3Wjq3y7GFWDZrW7
	Zr4kZ34Ivan0qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbbxYjxAI6xkYrwAYjxAI6xCIbckI1I0E57IF64kEYxAxM7k042IE
	4asKkaVY67AtM7k042IEIxkG67AtM7k0a2IF6F4UM7kC6x804xWl14x267AKxVWUJVW8Jw
	AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2z4x0Y4vE
	2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4
	x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAawVAY
	YI1S6c8GOVWUur45Jryln4vEF2I2jVAIwVAKzxkI7VAqrcv_JFW8Xr15M2kK6xCIbVAIwI
	AEc20F6c8GOVW8Jr15Jr4lnxkEFVAGz4kfMc804VCY07AIYIkI8VC2zVCFFI0UMc02F40E
	FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr
	1j6rxdM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l
	4IxY624lx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xAIw20EY4v20x
	vaj40_WFyUJVCq3bIYCTnIWIevJa73UjIFyTuYvjxUg48BUUUUU
X-CM-SenderInfo: p2kxt0pjihx21dq6xunwoduhdfq/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When K >= 0xFFFF0000, AND needs the two least significant bytes of K as
its operand, but EMIT2() gives it the least significant byte of K and
0x2. EMIT() should be used here to replace EMIT2().

Signed-off-by: Feiran Zhuang  <zhuangfeiran@ict.ac.cn>
---
 arch/x86/net/bpf_jit_comp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 5671752..5a5b6e4 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -289,7 +289,7 @@ void bpf_jit_compile(struct sk_filter *fp)
 					EMIT2(0x24, K & 0xFF); /* and imm8,%al */
 				} else if (K >= 0xFFFF0000) {
 					EMIT2(0x66, 0x25);	/* and imm16,%ax */
-					EMIT2(K, 2);
+					EMIT(K, 2);
 				} else {
 					EMIT1_off32(0x25, K);	/* and imm32,%eax */
 				}
-- 
1.7.5.4


