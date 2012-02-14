Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685Ab2BNPVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:21:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52516 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2BNPVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:21:45 -0500
Message-ID: <1329232814.2293.7.camel@twins>
Subject: Re: smp: Start up non-boot CPUs asynchronously
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjanvandeven@gmail.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, mikey@neuling.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        gregkh@linuxfoundation.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 14 Feb 2012 16:20:14 +0100
In-Reply-To: <CADyApD0o4UYsTkqf2H2yJZ-d05NAyRAEc6z+m1gJEogc=cZLqQ@mail.gmail.com>
References: <20120130205444.22f5e26a@infradead.org>
	 <20120131125232.GD4408@elte.hu> <20120131054155.371e8307@infradead.org>
	 <20120131143130.GF13676@elte.hu> <20120131072216.1ce78e50@infradead.org>
	 <20120131161207.GA18357@elte.hu> <20120131082439.575978c0@infradead.org>
	 <4F3A1891.8060001@linux.vnet.ibm.com> <4F3A2DFB.5000209@linux.vnet.ibm.com>
	 <CADyApD0o4UYsTkqf2H2yJZ-d05NAyRAEc6z+m1gJEogc=cZLqQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 06:31 -0800, Arjan van de Ven wrote:
> 
> frankly, such code HAS to worry about cpus going online and offline
> even today; the firmware, at least on X86, can start taking cores
> offline/online once ACPI is initialized.... (as controlled by a data
> center manager from outside the box, usually done based on thermal or
> power conditions on a datacenter level). Now, no doubt that we have
> bugs in this space, since this only happened very rarely before. 

Which frankly is an utter piece of crap, that ACPI spec is total garbage
and completely useless. You might have noticed that the ACPI code
supporting that failure carries a big nacked-by from me.

That's not to say we shouldn't try to fix hotplug, but bringing that
ACPI nonsense to the table makes me care less, not more.

I mean, really, that spec is broken, the support is worse.
