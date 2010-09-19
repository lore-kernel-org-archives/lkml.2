Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab0ISNJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 09:09:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab0ISNJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 09:09:34 -0400
Message-ID: <4C960B78.4010804@redhat.com>
Date: Sun, 19 Sep 2010 15:09:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: raw_spinlock_t rules
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Some time ago, the i8259 emulation code in kvm was changed to use 
raw_spinlock_t, as it was called in a preempt_disable() and 
local_irq_disable() context, which doesn't work with preemptible 
spinlocks used with CONFIG_PREEMPT_RT.

In Linux 2.6.37, the spinlock will no longer be taken in these contexts, 
so I'd like to change it to a normal spinlock_t.  However, it is still 
taken in a spin_lock_irq() context.

Is it okay to do this change?  I figured since spin_lock_irq() is part 
of the spinlock infrastructure it might to the right thing.

-- 
error compiling committee.c: too many arguments to function

