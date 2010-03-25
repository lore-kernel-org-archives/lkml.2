Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0CYTl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 15:41:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48356
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934Ab0CYTl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 15:41:57 -0400
Date: Thu, 25 Mar 2010 12:42:20 -0700 (PDT)
Message-Id: <20100325.124220.258885098.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       andi@firstfloor.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.1003251206550.3721@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org>
	<20100325182930.GA7709@elte.hu>
	<alpine.LFD.2.00.1003251206550.3721@i5.linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Mar 2010 12:10:22 -0700 (PDT)

> 
> 
> On Thu, 25 Mar 2010, Ingo Molnar wrote:
>> 
>> So the patch below should at most trigger bugs in areas that need fixing 
>> anyway, and i'm quite sure that under no circumstance would it cause 
>> unforeseen problems in 'thousands of drivers'.
> 
> If we do this, then we should just remove all the IRQF_DISABLED code in 
> kernel/irq/manage.c too, and basically make IRQF_DISABLED a clear no-op 
> (still leave it around as a #define, to not break any users). 

FWIW, I'm currently using IRQF_DISABLED for virtual network
device interrupts on sparc64 as a workaround for some stack
overflow issues.

This change will just force me to work harder to find out a better way
to fix the problem, so don't let my issue hold this back, it's just
an FYI...
