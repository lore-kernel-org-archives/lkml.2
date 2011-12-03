Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1LCCng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 21:43:36 -0500
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:52572 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937Ab1LCCne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 21:43:34 -0500
Date: Fri, 2 Dec 2011 19:43:17 -0700
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Suspend and resume on ASUS Laptops
Message-ID: <20111203024317.GA5370@ellpspace.math.ualberta.ca>
References: <1322763379.30977.33.camel@frodo>
 <Pine.LNX.4.44L0.1112021039460.1420-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1112021039460.1420-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 10:43:30AM -0500, Alan Stern wrote:
> 
> It's possible that this problem is related to wakeup settings.  Have 
> you tried disabling wakeup for the EHCI controllers?

On my ASUS K52Jc these controllers are also reported "disabled".  This
is after switching to Fedora 16 with its 3.1.2-1 kernel.

After doing these updates I had also to add "ath ath9k" to my list of
SUSPEND_MODULES (which are removed and reinserted in these operations)
or otherwise I will loose my wireless connection on a resume and a
reboot after hibernate will silently die.  In logs I can find

 irq 17: nobody cared (try booting with the "irqpoll" option)
 Pid: 0, comm: swapper Not tainted 3.1.2-1.fc16.x86_64 #1
 Call Trace:
  <IRQ>  [<ffffffff810b2222>] __report_bad_irq+0x38/0xc3
  [<ffffffff810b24bc>] note_interrupt+0x176/0x1fa
  [<ffffffff810b0a0f>] handle_irq_event_percpu+0x15d/0x1a5
  [<ffffffff810b0a92>] handle_irq_event+0x3b/0x59
  [<ffffffff81078268>] ? sched_clock_cpu+0x42/0xc6
  [<ffffffff810b2c7c>] handle_fasteoi_irq+0x80/0xa4
  [<ffffffff81010af9>] handle_irq+0x88/0x8e
  [<ffffffff814c040d>] do_IRQ+0x4d/0xa5
  [<ffffffff814b756e>] common_interrupt+0x6e/0x6e
  <EOI>  [<ffffffff814b71ac>] ? _raw_spin_unlock_irqrestore+0x17/0x19
  [<ffffffff813a5cc3>] ? poll_idle+0x28/0x65
  [<ffffffff813a5cb6>] ? poll_idle+0x1b/0x65
  [<ffffffff813a5fe6>] cpuidle_idle_call+0xe8/0x182
  [<ffffffff8100e2e3>] cpu_idle+0xa4/0xe8
  [<ffffffff81494a8e>] rest_init+0x72/0x74
  [<ffffffff81b76b7d>] start_kernel+0x3ab/0x3b6
  [<ffffffff81b762c4>] x86_64_start_reservations+0xaf/0xb3
  [<ffffffff81b76140>] ? early_idt_handlers+0x140/0x140
  [<ffffffff81b763ca>] x86_64_start_kernel+0x102/0x111
 handlers:
 [<ffffffffa02c0d80>] ath_isr
 Disabling IRQ #17

These "irq 17: nobody cared" were happening before but I could get away
without touching ath and aht9k modules.

   Michal
