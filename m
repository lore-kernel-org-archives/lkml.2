Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1BKED3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 23:03:29 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53224 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1BKED1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 23:03:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vgUDZtzgTJLq6/8yp+mOUujiksU6ThrM66K193nJX8sycoP2Cs17El9nX1RrLpWo3B
         MLyrJ7bAJRKvytOZGqTDXbQs+OHAZf8CavF+F9DCkAY5EWbV3hKs3BwNHx2/pLn6WpQA
         addoJP75gLaCgWE8MRWxd7gj2mkU7wIFqbGDY=
Message-ID: <4D54B508.8060106@am.sony.com>
Date: Thu, 10 Feb 2011 20:03:20 -0800
From: Frank Rowand <frank.rowand@gmail.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        Linus Torvals <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 00/75] genirq: Overhaul for 2.6.39
References: <20110210222908.661199947@linutronix.de>
In-Reply-To: <20110210222908.661199947@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/11 15:35, Thomas Gleixner wrote:
> This is a major overhaul of the generic interrupt layer.
> 
>      - Namespace cleanup
> 
>      - Further encapsulation of the core state
> 
>      - Spurious/Poll handling fixes
> 
>      - Stop setaffinity blindly manipulating affinity mask
> 
>      - Cleanups and enhancements all over the place

Hi Thomas,

You seem to have overlooked a patch from me:

Update comments to match code change in 70aedd24
The comments for enable_irq() were updated correctly, but disable_irq_nosync()
and disable_irq() were missed.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

---
 kernel/irq/manage.c |    7 	5 +	2 -	0 !
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/kernel/irq/manage.c
===================================================================
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -353,7 +353,8 @@ void __disable_irq(struct irq_desc *desc
  *	Unlike disable_irq(), this function does not ensure existing
  *	instances of the IRQ handler have completed before returning.
  *
- *	This function may be called from IRQ context.
+ *	This function may be called from IRQ context only when
+ *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !
  */
 void disable_irq_nosync(unsigned int irq)
 {
@@ -381,7 +382,9 @@ EXPORT_SYMBOL(disable_irq_nosync);
  *	to complete before returning. If you use this function while
  *	holding a resource the IRQ handler may need you will deadlock.
  *
- *	This function may be called - with care - from IRQ context.
+ *	This function may be called - with care - from IRQ context only when
+ *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !
+ *	See synchronize_irq() comments for explanation of "with care".
  */
 void disable_irq(unsigned int irq)
 {
