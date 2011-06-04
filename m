Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1FDLsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 07:48:35 -0400
Received: from ccserver1.unican.es ([130.206.5.100]:55271 "EHLO
	ccserver1.unican.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab1FDLsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 07:48:33 -0400
Message-ID: <4DEA1BA9.7020303@unican.es>
Date: Sat, 4 Jun 2011 13:48:57 +0200
From: Monica Puig-Pey <puigpeym@unican.es>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) 
	Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: One Interrupted Threads per Interrupt line?
Content-Type: text/plain;
	charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [193.144.198.131]
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18178.006)
X-imss-scores: Clean:28.03731 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:2 S:2 R:2 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using Ubuntu 10.04 with the 2.6.31-11-rt patch installed. I'm 
developing a PCI device driver using hardware interrupts.
I read in the “Internals of the RT Patch” document 
(http://www.kernel.org/doc/ols/2007/ols2007v2-pages-161-172.pdf ) that 
when a device driver requests an IRQ, a thread is created to service 
this interrupt line (Threaded interrupts). Only ONE thread can be 
created per interrupt line, so shared interrupts are still handled by a 
single thread.

My driver requests IRQ 16, which is shared with others handlers. Typing 
on the shell  $ps -eo pid,pri,rtprio,cmd I can see my driver requesting 
irq 16 and with 50 RTPRIO. At the same time I can see the others drivers 
requesting IRQ 16 with different real time priorities than mine( 80, 85, 
50). Does this mean that there are more than ONE Threaded Interrupts for 
IRQ 16? or it's just the thread priority when running each handler for 
IRQ 16?
Finally, how could I change the 50 RT PRIO for my handler pci_9111?

Here you have the shell:

   PID PRI RTPRIO CMD

   658 120     80 [irq/16-uhci_hcd]
  3852 125     85 [irq/16-HDA Inte]
  4303  90     50 [irq/16-radeon@p]
  5863  90     50 [irq/16-pci_9111]
  5865  19      - ps -eo pid,pri,rtprio,cmd


Thank you very much,

Mónica
