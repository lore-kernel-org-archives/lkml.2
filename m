Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0IWEe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 00:34:58 -0400
Received: from ozlabs.org ([203.10.76.45]:56455 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab0IWEe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 00:34:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Convert preempt_disabled in module.c to rcu read lock
Date: Thu, 23 Sep 2010 10:37:08 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
References: <1285160840-16506-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1285160840-16506-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009231037.09417.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 10:37:20 pm Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Thomas Gleixner pointed out that the list_for_each_rcu()
> in module really need to use RCU read lock, not preempt disable.
> This is especially needed for the preemptive RCU code.
> >From what I understand the only reason for the preemption
> disabling is to protect against rcu, so using rcu_read_lock()
> is correct.

The preempt_disable() also protects against stop_machine() on
module remove.

I haven't been following the RCU story, but we were always slightly
abusing the infrastructure here just to do lockless insert.  If
list_for_each_entry_rcu() is changing, perhaps we need to open-code
the old version here?

Rusty.
