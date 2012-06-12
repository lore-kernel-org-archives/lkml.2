Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2FLP0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:26:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34731 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2FLP0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:26:46 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1206121639420.3086@ionos>
References: <20120522032554.GA11358@gmail.com> <Pine.LNX.4.64.1206121201130.6800@axis700.grange>
 <alpine.LFD.2.02.1206121639420.3086@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Jun 2012 18:26:24 +0300
X-Google-Sender-Auth: uxz0_PU7bEoFWM3S0Yb5zv41qgw
Message-ID: <CA+55aFxNy2-DnWVDUiOuF+NncRBUC=frZN+CTLsJ+o2ofXtZYQ@mail.gmail.com>
Subject: Re: [GIT PULL] irq/core changes for v3.5
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 5:56 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Thinking more about it, it's probably the best thing to simply force
> the IRQF_ONESHOT flag if it's missing.

No, that's just crazy.

Now you make broken shit code work, and then you break the *correct*
code that didn't want threading and didn't set IRQF_ONESHOT.

Just face it: if somebody doesn't have an interrupt-time function
pointer, they need to rethink their code. It's a mistake. It's broken
shit.

Why pander to crap? What is the advantage of allowing people to think
that they don't need an interrupt-time function? It's a fundamentaly
broken model, since it *cannot* work tgether with another driver that
wants to have the normal semantics and happens to share the irq.

               Linus
