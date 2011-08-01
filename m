Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1HAXiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:38:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab1HAXYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:24:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:52 2011
Message-Id: <20110801232052.608769171@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Parsons <lost.distance@yahoo.com>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [20/70] ARM: pxa: fix PGSR register address calculation
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Parsons <lost.distance@yahoo.com>

commit beb0c9b056b1c23d2029b46a425362e9ccbeba01 upstream.

The file mfp-pxa2xx.c defines a macro, PGSR(), which translates a gpio
bank number to a PGSR register address. The function pxa2xx_mfp_suspend()
erroneously passed in a gpio number instead of a gpio bank number.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-pxa/mfp-pxa2xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-pxa/mfp-pxa2xx.c
+++ b/arch/arm/mach-pxa/mfp-pxa2xx.c
@@ -347,9 +347,9 @@ static int pxa2xx_mfp_suspend(struct sys
 		if ((gpio_desc[i].config & MFP_LPM_KEEP_OUTPUT) &&
 		    (GPDR(i) & GPIO_bit(i))) {
 			if (GPLR(i) & GPIO_bit(i))
-				PGSR(i) |= GPIO_bit(i);
+				PGSR(gpio_to_bank(i)) |= GPIO_bit(i);
 			else
-				PGSR(i) &= ~GPIO_bit(i);
+				PGSR(gpio_to_bank(i)) &= ~GPIO_bit(i);
 		}
 	}
 


