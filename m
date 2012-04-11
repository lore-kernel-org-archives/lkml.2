Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040Ab2DKCPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 22:15:34 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:3704
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756019Ab2DKCPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 22:15:32 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F84E919.8040604@am.sony.com>
Date: Tue, 10 Apr 2012 19:14:49 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Chanho Min <chanho0207@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jong-Sung Kim <neidhard.kim@lge.com>, stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ARM: v3.4-rc1 amba-pl011 regression (NULL pointer dereference)
References: <4F84E4F7.3020107@am.sony.com>
In-Reply-To: <4F84E4F7.3020107@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-kernel was left off the original message, resending.


commit 9b96fbac introduced use of pointer before it is initialized,
resulting in a NULL pointer dereference on boot for the ARM Realview.

uap->port.membase is initialized to base a few lines later, so just
use base.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 drivers/tty/serial/amba-pl011.c |    4 	2 +	2 -	0 !
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/tty/serial/amba-pl011.c
===================================================================
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1947,8 +1947,8 @@ static int pl011_probe(struct amba_devic
 	}
 
 	/* Ensure interrupts from this UART are masked and cleared */
-	writew(0, uap->port.membase + UART011_IMSC);
-	writew(0xffff, uap->port.membase + UART011_ICR);
+	writew(0, base + UART011_IMSC);
+	writew(0xffff, base + UART011_ICR);
 
 	uap->vendor = vendor;
 	uap->lcrh_rx = vendor->lcrh_rx;

