Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1LLLOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:14:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49767 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab1LLLOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:14:05 -0500
Date: Mon, 12 Dec 2011 12:12:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
Message-ID: <20111212111222.GA21121@elte.hu>
References: <20111210132220.083204833@linutronix.de>
 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
 <alpine.LFD.2.02.1112102144370.3020@ionos>
 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
 <20111211103047.GA19299@elte.hu>
 <alpine.LFD.2.02.1112111459270.3020@ionos>
 <20111211155347.GA1297@elte.hu>
 <1323667836.4190.4.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323667836.4190.4.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <levinsasha928@gmail.com> wrote:

> 50k cycles for every single byte is pretty much as good as it 
> will get with serial console. See slide #5 in Marcelo's KVM 
> Forum 2010 presentation[1] where he timed a heavyweight exit 
> to about 40k cycles.

> [1]
> http://www.linux-kvm.org/wiki/images/e/ea/2010-forum-mtosatti_walkthrough_entry_exit.pdf

But what we do here is a PIO exit. That, according to Marcelo's 
measurements, is about 10K cycles, back to back. [*]

So where does the extra overhead come from?

We shouldn't care that there's virtio-console - the goal of 
tools/kvm it speed everything up as much as possible, so we 
should not jump to the next IO abstraction unless we know where 
every cycle was spent with simpler IO models ...

Thanks,

	Ingo

[*] Also, those 10K cycles include some significant Qemu 
    overhead - a couple of thousand cycles - that should be much 
    lower in the tools/kvm case.

