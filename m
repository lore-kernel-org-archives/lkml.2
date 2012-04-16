Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2DPHw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:52:27 -0400
Received: from forward19.mail.yandex.net ([95.108.253.144]:50379 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2DPHwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:52:25 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 03:52:25 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: David Miller <davem@davemloft.net>
Cc: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>, Tkhai Kirill <tkhai@yandex.ru>
In-Reply-To: <20120416.021613.606704342231219042.davem@davemloft.net>
References: <20120416155907.32c0041caa002f72da4635b7@canb.auug.org.au> <20120416.021613.606704342231219042.davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (sparc-next tree related)
MIME-Version: 1.0
Message-Id: <273521334562355@web29.yandex.ru>
Date: Mon, 16 Apr 2012 11:45:55 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



16.04.2012, 10:16, "David Miller" <davem@davemloft.net>:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 16 Apr 2012 15:59:07 +1000
>
>> šAfter merging the final tree, today's linux-next build (sparc32 defconfig)
>> šfailed like this:
>>
>> šarch/sparc/kernel/pcic.c: In function 'pci_time_init':
>> šarch/sparc/kernel/pcic.c:741:2: error: 'timer_cs_period' undeclared (first use in this function)
>>
>> šCaused by commit 62f082830d63 ("sparc32: generic clockevent support").
>>
>> šI have reverted that commit for today.
>
> Sam, Tkhai, please fix this.

Hi! This place is a mix from two last patches. The fix is below.

Regards,
KT

P.S. I'm sending the message from a web mail client to answer faster. I hope, it won't be problems.

---
 arch/sparc/kernel/pcic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 118a3f5..866aa34 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -738,7 +738,7 @@ void __init pci_time_init(void)
 	 * It's in SBUS dimension, because timer_cs is in this dimension.
 	 * We take into account this in pcic_cycles_offset()
 	 */
-	timer_cs_period = SBUS_CLOCK_RATE / HZ;
+	sparc_config.cs_period = SBUS_CLOCK_RATE / HZ;
 	sparc_config.features |= FEAT_L10_CLOCKEVENT;
 #endif
 	sparc_config.features |= FEAT_L10_CLOCKSOURCE;
