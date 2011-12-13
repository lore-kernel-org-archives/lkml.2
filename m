Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab1LMOvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:51:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:57638 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab1LMOvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:51:32 -0500
Date: Tue, 13 Dec 2011 15:51:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Avi Kivity <avi@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
In-Reply-To: <4EE75FF8.5060208@redhat.com>
Message-ID: <alpine.LFD.2.02.1112131547590.3020@ionos>
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos> <alpine.LFD.2.02.1112111014500.1663@tux.localdomain> <20111211103047.GA19299@elte.hu>
 <alpine.LFD.2.02.1112111459270.3020@ionos> <20111211155347.GA1297@elte.hu> <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com> <20111212172059.GC23870@elte.hu> <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
 <20111212192135.GA18876@elte.hu> <alpine.LFD.2.02.1112130056370.3020@ionos> <4EE72FCB.3070109@redhat.com> <alpine.LFD.2.02.1112131434320.3020@ionos> <4EE75FF8.5060208@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, Avi Kivity wrote:
> On 12/13/2011 03:52 PM, Thomas Gleixner wrote:
> > On Tue, 13 Dec 2011, Avi Kivity wrote:
> > > Run your guest with x2apic enabled, the timing will be very different. 
> >
> > And what magic do I have to use to make that happen other than having
> > x2apic support enabled in the kernel? Or do I need a certain kernel
> > version for host and guest to make that work?
> 
> With qemu, -cpu host or -cpu blah,+x2apic.  kvm-tool does the equivalent

Well, that was a trace from qemu-kvm (your latest tree). Now with -cpu
host it works and I get the same results as with kvm tool.

> of -cpu host, so I'm surprised it doesn't show up.  x2apic has been
> recognized by the guest for a long time (ce69a784; 2.6.32, I'll be
> surprised if you have anything older than that on your machine).
> 
> Does x2apic show up in your guest's /proc/cpuinfo?

Now it does :)

> > The whole APIC timer calibration and the back and forth
> > conversion is definitely nothing which falls into the category of
> > smart.
> 
> APIC timer calibration is silly but it hasn't proven to be a real-world
> problem.

Well, that depends on the world. The issue with that calibration is
that it can be off and for a certain category of application it
matters. Definitely not for the usual virt workload stuff. But saving
cycles for highres/nohz enabled guests would be nice. Maybe I have a
go when I find a some time.

Thanks,

	tglx
