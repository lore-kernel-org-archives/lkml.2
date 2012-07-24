Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2GXUyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:54:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34498 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab2GXUyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:54:35 -0400
Message-ID: <500F0BAB.7060001@gmail.com>
Date: Tue, 24 Jul 2012 22:55:07 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: INFO: rcu_preempt detected stalls on CPUs/tasks on v3.6
References: <500ED719.2010002@gmail.com> <20120724174017.GE2390@linux.vnet.ibm.com>
In-Reply-To: <20120724174017.GE2390@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 07:40 PM, Paul E. McKenney wrote:
> The interrupt flag is zero, so interrupts are disabled.  So my question
> to you is "Why did do_pageattr_test() or one of the functions it called
> disable interrupts for more than one hundred thousand jiffies?"
> 
> I can't see where it is disabling interrupts, but the EFLAGS register
> above does indicate that they are disabled.  Or is this something useless
> that is just telling us that receiving the NMI disabled interrupts?

Doesn't the stack of CPU1 show that it's currently handling an interrupt:

[  215.026612] Call Trace:
[  215.026612]  <IRQ>
[  215.026612]  [<ffffffff81095d07>] native_apic_msr_eoi_write+0x27/0x30
[  215.026612]  [<ffffffff810901c4>] smp_apic_timer_interrupt+0x34/0xa0
[  215.026612]  [<ffffffff8369c4af>] apic_timer_interrupt+0x6f/0x80
[  215.026612]  <EOI>

Or am I reading that wrong?

In that case, it had nothing to do with pageattr which just happened to be on the stack at that time.
