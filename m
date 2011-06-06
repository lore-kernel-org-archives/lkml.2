Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab1FFPrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:47:43 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:12850 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab1FFPrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:47:41 -0400
X-Greylist: delayed 1145 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jun 2011 11:47:41 EDT
Date: Mon, 6 Jun 2011 17:28:40 +0200
From: David Jander <david.jander@protonic.nl>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: Why does handle_simple_irq() require IRQ's to be disabled?
Message-ID: <20110606172840.322f09d4@archvile>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am trying to implement/fix interrupt controller functionality in
gpio/pca953x.c, and for some reason which I don't understand, I need to disable
interrupts with local_irq_disable() before calling generic_handle_irq(). This
does not seem right.
If I follow the code of handle_simple_irq(), the handler function setup for
this IRQ, I get to handle_irq_event_percpu(), which has a
WARN_ONCE(!irqs_disabled(),...
This WARN is triggered, since nobody explicitly disables interrupts. Why?

generic_hanlde_irq() is called from a threaded interrupt handler of the parent
of this interrupt controller, and calling local_irq_disable() here seems like
a crime. What am I doing wrong?

Best regards,

-- 
David Jander
Protonic Holland.
