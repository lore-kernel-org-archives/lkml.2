Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965125Ab2DSVRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:17:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933674Ab2DSVRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:17:06 -0400
Message-Id: <20120419210822.323013396@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:09:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 43/68] serial: PL011: move interrupt clearing
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit c3d8b76f61586714cdc5f219ba45592a54caaa55 upstream.

Commit 360f748b204275229f8398cb2f9f53955db1503b
"serial: PL011: clear pending interrupts"
attempts to clear interrupts by writing to a
yet-unassigned memory address. This fixes the issue.

The breaking patch is marked for stable so should be
carried along with the other patch.

Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>
Reported-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/amba-pl011.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1919,10 +1919,6 @@ static int pl011_probe(struct amba_devic
 		goto unmap;
 	}
 
-	/* Ensure interrupts from this UART are masked and cleared */
-	writew(0, uap->port.membase + UART011_IMSC);
-	writew(0xffff, uap->port.membase + UART011_ICR);
-
 	uap->vendor = vendor;
 	uap->lcrh_rx = vendor->lcrh_rx;
 	uap->lcrh_tx = vendor->lcrh_tx;
@@ -1939,6 +1935,10 @@ static int pl011_probe(struct amba_devic
 	uap->port.line = i;
 	pl011_dma_probe(uap);
 
+	/* Ensure interrupts from this UART are masked and cleared */
+	writew(0, uap->port.membase + UART011_IMSC);
+	writew(0xffff, uap->port.membase + UART011_ICR);
+
 	snprintf(uap->type, sizeof(uap->type), "PL011 rev%u", amba_rev(dev));
 
 	amba_ports[i] = uap;


