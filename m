Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1EQMSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:18:42 -0400
Received: from ccserver2.unican.es ([130.206.5.101]:48665 "EHLO
	ccserver2.unican.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1EQMSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:18:40 -0400
X-Greylist: delayed 1638 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 May 2011 08:18:40 EDT
Message-ID: <4DD2614A.4060003@unican.es>
Date: Tue, 17 May 2011 13:51:38 +0200
From: Monica Puig-Pey <puigpeym@unican.es>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) 
	Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: How to establish a priority to an interrupt handler
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [193.144.198.131]
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18140.006)
X-imss-scores: Clean:0.64781 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:2 S:2 R:2 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using Ubuntu 10.04 with the 2.6.31-11-rt patch installed. I'm
developing a PCI device driver using hardware interrupts.
As I read at the RT wiki
(https://rt.wiki.kernel.org/index.php/CONFIG_PREEMPT_RT_Patch )
interrupts are moved to kernel threads called Threaded Interrupts in the
RT patch.

I would like to give a priority chosen by me to my IRQ handler, but I
don't know how to do it, or if it is possible (it seems it is).

I've found (http://lwn.net/Articles/302043/ ) that what I had to use in
order to get Threaded Interrupt is:

int request_threaded_irq(unsigned int irq, irq_handler_t handler,
                      irq_handler_t quick_check_handler,
                      unsigned long flags, const char *name, void *dev)

But there is not priority there!

Using ps -eo pid,pri,rtprio,cmd I've seen my handler runs with priority 50.

I also used :

int request_irq (unsigned int irq, void (*handler) (int, void *, struct
pt_regs *), unsigned long irqflags, const char *devname, void *dev_id);

and using ps command here my handler still runs with priority 50.
Shouldn't it work as a non threaded interrupt then? Why 50 instead 99 or
the highest priority one?

Which function should I use to chose the priority for the IRQ thread?

Is there any other function to call from this context where my handler
could know its priority?

Please I wish to be personally CC'ed the answers/comments posted to the 
list in response to my posting because I'm not subscribed to the list.

Thank you very much

Mónica
