Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0JKUdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:33:05 -0400
Received: from www.tglx.de ([62.245.132.106]:57021 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0JKUdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:33:04 -0400
Date: Mon, 11 Oct 2010 22:32:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcio Saito <marcio@cyclades.com>, Jiri Slaby <jirislaby@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        John Stultz <johnstul@us.ibm.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] [PATCH] allow low HZ values?
In-Reply-To: <20101011201121.GA953@tpepper-t61p.dolavim.us>
Message-ID: <alpine.LFD.2.00.1010112227190.2909@localhost6.localdomain6>
References: <20101011201121.GA953@tpepper-t61p.dolavim.us>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010, Tim Pepper wrote:

> I'm not necessarily wanting to open up the age old question of "what is
> a good HZ", but we were doing some testing on timer tick overheads for
> HPC applications and this came up...

Yeah. This comes always up when the timer tick overhead on HPC is
tested. And this patch is again the fundamentally wrong answer.

We have told HPC folks for years that we need a kind of "NOHZ" mode
for HPC where we can transparently switch off the tick when only one
user space bound thread is active and switch back to normal once this
thing terminates or goes into the kernel via a syscall. Sigh, nothing
happened ever except for repeating the same crap patches over and
over.

FYI, Frederic is working on that right now. He will talk about it at
the plumbers RT microconf, so you might catch him there.

Thanks,

	tglx
