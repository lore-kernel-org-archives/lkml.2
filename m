Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798Ab0GPJbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:31:52 -0400
Received: from snt0-omc1-s39.snt0.hotmail.com ([65.54.61.76]:17575 "EHLO
	snt0-omc1-s39.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936078Ab0GPJbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:31:50 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jul 2010 05:31:50 EDT
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS20BA35E3097019A39A8694A7BC0@phx.gbl>
From: "limp" <johnkyr83@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Where system interrupts get disabled at LAPIC timer handler execution?
Date: Fri, 16 Jul 2010 10:25:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcskyNbV2W94SvyyS/2f4n5xwWizRQ==
Content-Language: en-gb
X-OriginalArrivalTime: 16 Jul 2010 09:25:40.0337 (UTC) FILETIME=[DB696E10:01CB24C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I am trying to demystify what happens when the kernel has configured to use
LAPIC timer as its timer and I've ran into some problems/questions.

AFAIK, when a LAPIC timer interrupt occurs, the assembly wrapper at
enrty_32.s jumps the execution at smp_apic_timer_interrupt(). At the
beginning of this function, I've checked to see if interrupts are enabled or
not using irqs_disabled() and I found out that they are disabled.
 
The problem is that I can't find where Linux disables interrupts before
calling smp_apic_timer_interrupt(). The only place this could be done is in
the assembly wrapper but I can't really find it.

Does the processor disables interrupts by default when a LAPIC timer
interrupt occurs?

Any help will be much appreciated.

Thanks in advance.

John.

