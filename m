Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab1GDNW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:22:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33826 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab1GDNW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:22:28 -0400
Date: Mon, 4 Jul 2011 15:22:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 5/6] x86: Remove useless unwinder backlink from irq regs
 saving
Message-ID: <20110704132158.GA5551@somewhere>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
 <1309624184-9790-6-git-send-email-fweisbec@gmail.com>
 <4E1187E4020000780004BF2C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1187E4020000780004BF2C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 08:29:08AM +0100, Jan Beulich wrote:
> >>> On 02.07.11 at 18:29, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > The unwinder backlink in interrupt entry is very useless.
> > It's actually not part of the stack frame chain and thus is
> > never used.
> 
> I very much doubt this - see dump_trace()'s comment in its IRQ-stack
> related code portion (and the corresponding use of irq_stack_end[-1]).
> 
> Jan

Good point. I misunderstood that.

But then I believe I accidentally fixed it back in
"x86: Don't use frame pointer to save old stack on irq entry" by
pushing %rsi instead in the new stack. It contains the backlink to
the old stack.

If we keep the macro as-is, I'll add a comment to explain further
what is involved there.
