Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab0LBIhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 03:37:39 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:54860 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab0LBIhh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:2:1>);
	Thu, 2 Dec 2010 03:37:37 -0500
Message-Id: <4CF768DA02000078000255FE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 02 Dec 2010 08:37:30 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: use of set_irq_chip_and_handler...() for chained handlers vs
	 sparse IRQs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

looking (originally from a Xen perspective) at the use of non-platform
specific drivers that set chained IRQ handlers (drivers/mfd/ezx-pcap.c,
drivers/gpio/langwell_gpio.c, and drivers/gpio/timbgpio.c are the ones
that I could clearly identify) I wonder not only how a conflict between
the IRQ ranges they use with "normal" IRQs is being avoided, but
also how they can work at all with sparse IRQs, and how races in
trying to set up IRQs' chips/handlers are supposed to be avoided (on
x86, alloc_irq_and_cfg_at() blindly takes the result of
get_irq_chip_data() no matter what ->chip actually points to, and
the call to set_irq_chip_data() is all but race free).

Is it possible that the setup of chained handlers really isn't meant
to be used without precise knowledge of the platform, possibly
including the knowledge that sparse IRQs aren't in use there (and
hence the cited drivers have incomplete Kconfig dependencies)?

While for native x86 it may be that races in setting up IRQ chips
and handlers can be considered implicitly race free (leaving aside
the chained handler situation), under Xen and in the general
case (given that set_irq_chip() and __set_irq_handler() are
exported symbols) currently there seems to be no way to
avoid collisions.

Thanks, Jan

