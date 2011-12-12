Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1LLRkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:40:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37262 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1LLRk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:40:29 -0500
Message-ID: <1323711623.3269.10.camel@lappy>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
From: Sasha Levin <levinsasha928@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>
Date: Mon, 12 Dec 2011 19:40:23 +0200
In-Reply-To: <20111212111222.GA21121@elte.hu>
References: <20111210132220.083204833@linutronix.de>
	 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
	 <alpine.LFD.2.02.1112102144370.3020@ionos>
	 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
	 <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos>
	 <20111211155347.GA1297@elte.hu> <1323667836.4190.4.camel@lappy>
	 <20111212111222.GA21121@elte.hu>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 12:12 +0100, Ingo Molnar wrote:
> * Sasha Levin <levinsasha928@gmail.com> wrote:
> 
> > 50k cycles for every single byte is pretty much as good as it 
> > will get with serial console. See slide #5 in Marcelo's KVM 
> > Forum 2010 presentation[1] where he timed a heavyweight exit 
> > to about 40k cycles.
> 
> > [1]
> > http://www.linux-kvm.org/wiki/images/e/ea/2010-forum-mtosatti_walkthrough_entry_exit.pdf
> 
> But what we do here is a PIO exit. That, according to Marcelo's 
> measurements, is about 10K cycles, back to back. [*]
> 
> So where does the extra overhead come from?
> 
> We shouldn't care that there's virtio-console - the goal of 
> tools/kvm it speed everything up as much as possible, so we 
> should not jump to the next IO abstraction unless we know where 
> every cycle was spent with simpler IO models ...
> 
> Thanks,
> 
> 	Ingo
> 
> [*] Also, those 10K cycles include some significant Qemu 
>     overhead - a couple of thousand cycles - that should be much 
>     lower in the tools/kvm case.

No, everything on slide 5 is part of a PIO exit. Starting from 'out' and
up to until it's back to the guest. A total of over 40k cycles.

KVM tools does have less overhead than qemu regarding PIO exits, but
even if you take those completely out of the equation we're still pretty
close to 40k cycles.

-- 

Sasha.

