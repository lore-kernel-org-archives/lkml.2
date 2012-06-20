Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab2FTShZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:37:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab2FTSWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:22:19 -0400
Message-Id: <20120620173023.344606261@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [ 28/61] Make hard_irq_disable() actually hard-disable interrupts
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit f948501b36c6b3d9352ce212a197098a7e958971 upstream.

At present, hard_irq_disable() does nothing on powerpc because of
this code in include/linux/interrupt.h:

    #ifndef hard_irq_disable
    #define hard_irq_disable()      do { } while(0)
    #endif

So we need to make our hard_irq_disable be a macro.  It was previously
a macro until commit 7230c56441 ("powerpc: Rework lazy-interrupt
handling") changed it to a static inline function.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
--
 arch/powerpc/include/asm/hw_irq.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -99,6 +99,9 @@ static inline void hard_irq_disable(void
 	get_paca()->irq_happened |= PACA_IRQ_HARD_DIS;
 }
 
+/* include/linux/interrupt.h needs hard_irq_disable to be a macro */
+#define hard_irq_disable	hard_irq_disable
+
 /*
  * This is called by asynchronous interrupts to conditionally
  * re-enable hard interrupts when soft-disabled after having


