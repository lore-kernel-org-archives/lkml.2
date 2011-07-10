Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1GJMro (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 08:47:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43807 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab1GJMrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 08:47:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 10 Jul 2011 14:47:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: 3.0-rc6+: hid_report_raw_event -- unable to handle kernel paging
 request (during boot)
Message-ID: <20110710144736.78e4abb6@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following once during a series of several boot-ups.
This is 3.0-rc6-71-g4dd1b49 x86-64 plus Alan Stern's
"USB: additional regression fix for device removal".

input: Logitech USB Receiver as /devices/pci0000:00/0000:0012.0/usb3/3-1/3-1:1.0/input/input0
generic-usb 0003:046D:C518.0001: input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-1/input0
BUG: unable to handle kernel paging request at ffff880215514048
IP: [<ffffffff812c5b86>] hid_report_raw_event+0x292/0x405
PGD 1622063 PUD 21f6fa067 PMD 21f7a5067 PIE 8000000215514160
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 3
Modules linked in:

Pid: 0, comm: kworker/0:1 Not tainted 3.0.0-rc6 #14 System manufacturer System Product Name/M3A78-EM
RIP: 0010:[<ffffffff812c5b86>] [<ffffffff812c5b86>] hid_report_raw_event+0x292/0x405
RSP: 0018:ffff88021fd83c58 EFLAGS: 00010016
[...etc, screenshot available if necessary...]
Call Trace:
 <IRQ>
 [...] hid_input_report+0x1bb/0x1d8
 [...] hid_ctrl+0x99/0x146
 [...] usb_hcd_giveback_urb+0x5d/0x8d
 [...] finish_urb+0x9d+0xd6
 [...] takeback_td+0x45/0xff
 [...] ohci_irq+0x26f/0x3cf
 [...] usb_hci_irq+0x2f/0x7a
[...]
-- 
Stefan Richter
-=====-==-== -=== -=-=-
http://arcgraph.de/sr/
