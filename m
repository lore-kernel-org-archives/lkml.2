Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab0HDCJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:09:16 -0400
Received: from ozlabs.org ([203.10.76.45]:56684 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079Ab0HDCJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:09:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
Date: Wed, 4 Aug 2010 11:39:05 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
References: <4C3A06E3.50402@kernel.org> <4C588C0C.1070702@goop.org>
In-Reply-To: <4C588C0C.1070702@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008041139.06739.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 07:07:16 am Jeremy Fitzhardinge wrote:
> Of course if it becomes core to the x86 architecture or the kernel 
> overall, then most of the irq-related paravirt-ops can go away and be 
> limited to the actual interrupt handler and the machinery needed to 
> really mask/unmask the hardware and set the pending flag (which would 
> likely just be contained within the hypervisor-specific code, and not 
> need any new kernel interfaces to replace the dropped paravirt irq ones).

Yep, we sweat over the cli/sti paravirtual implementations because it's so
common.  If the kernel used soft cli/sti we could simply implement it with
a hypercall and be much happier (though iret possibly still an issue).

Cheers,
Rusty.
