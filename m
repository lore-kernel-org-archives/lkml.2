Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab2DSVII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:08:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab2DSVID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:08:03 -0400
Message-Id: <20120419210308.149505284@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:04:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 59/75] serial: PL011: move interrupt clearing
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1930,10 +1930,6 @@ static int pl011_probe(struct amba_devic
 		goto unmap;
 	}
 
-	/* Ensure interrupts from this UART are masked and cleared */
-	writew(0, uap->port.membase + UART011_IMSC);
-	writew(0xffff, uap->port.membase + UART011_ICR);
-
 	uap->vendor = vendor;
 	uap->lcrh_rx = vendor->lcrh_rx;
 	uap->lcrh_tx = vendor->lcrh_tx;
@@ -1951,6 +1947,10 @@ static int pl011_probe(struct amba_devic
 	uap->port.line = i;
 	pl011_dma_probe(uap);
 
+	/* Ensure interrupts from this UART are masked and cleared */
+	writew(0, uap->port.membase + UART011_IMSC);
+	writew(0xffff, uap->port.membase + UART011_ICR);
+
 	snprintf(uap->type, sizeof(uap->type), "PL011 rev%u", amba_rev(dev));
 
 	amba_ports[i] = uap;


