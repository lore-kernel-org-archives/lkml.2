Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1AWNGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 08:06:19 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41524 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751289Ab1AWNGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 08:06:18 -0500
Date: Sun, 23 Jan 2011 14:06:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: unbreak billionton CF card (was Re: [000/152] 2.6.36.3-stable
 review)
Message-ID: <20110123130611.GA2713@ucw.cz>
References: <20110106002500.GA3172@kroah.com>
 <20110106134254.68fa27ac@lxorguk.ukuu.org.uk>
 <20110106215705.GA30799@suse.de>
 <20110107150724.GA29082@atrey.karlin.mff.cuni.cz>
 <20110107183716.GA14895@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107183716.GA14895@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unbreak Billionton CF bluetooth card. This actually fixes a regression
on zaurus.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---

(now fixed typo)

> > Flow control flag seems to be responsible.
> > 
> > But... it hits me and then... me. So I'd like to see it resolved in
> > devel tree, but it may not 100% vital for stable.
> 
> Ok, care to make up a patch I can apply for Linus's tree first that
> works for you?

./drivers/serial - ./drivers/serial.ofic
diff -X /usr/src/linux/.gitignore -ur ./drivers/serial.ofic/8250.c ./drivers/serial/8250.c
--- ./drivers/serial.ofic/8250.c	2011-01-02 21:25:29.000000000 +0100
+++ ./drivers/serial/8250.c	2011-01-09 08:10:39.000000000 +0100
@@ -236,7 +236,8 @@
 		.fifo_size	= 128,
 		.tx_loadsz	= 128,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
-		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
+		/* UART_CAP_EFR breaks Billionton CF bluetooth card. */
+		.flags		= UART_CAP_FIFO | UART_CAP_SLEEP,
 	},
 	[PORT_16654] = {
 		.name		= "ST16654",

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
