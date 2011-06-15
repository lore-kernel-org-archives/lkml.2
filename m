Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1FPHAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:04 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54051 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357Ab1FPHAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:02 -0400
X-Sasl-enc: 59oZ6vDzC1nSDGAzd+Z/KZTdPCSPkgAsouSYSdjXgkOO 1308207601
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:29 2011
Message-Id: <20110616000229.100571770@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [01/89] lguest: fix timer interrupt setup
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 15517f7c213442e4d8a098cf0732b237f764c576 upstream.

Without an IRQ chip set, we now get a WARN_ON and no timer interrupt.  This
prevents booting.

Fortunately, the fix is a one-liner: set up the timer IRQ like everything
else.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/lguest/boot.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -995,6 +995,7 @@ static void lguest_time_irq(unsigned int
 static void lguest_time_init(void)
 {
 	/* Set up the timer interrupt (0) to go to our simple timer routine */
+	lguest_setup_irq(0);
 	irq_set_handler(0, lguest_time_irq);
 
 	clocksource_register(&lguest_clock);


