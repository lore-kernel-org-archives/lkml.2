Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845Ab2FHVSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:18:36 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:23944
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256Ab2FHVSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:18:34 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(z1823lz98dI1432Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5BHUS-01-2W5-02
X-M-MSG: 
Date: Fri, 8 Jun 2012 23:16:08 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <andi@firstfloor.org>, <mingo@elte.hu>, <ming.m.lin@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120608211608.GE5220@aftab.osrc.amd.com>
References: <1339064319.23343.13.camel@twins>
 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
 <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
 <20120608135117.GB31359@aftab.osrc.amd.com>
 <20120608210239.GB16470@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120608210239.GB16470@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 06:02:39PM -0300, Henrique de Moraes Holschuh wrote:
> > Reportedly, there are some obscure systems which need different
> > microcode versions per CPU:
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/01010.html
> 
> I wrote that email you linked above.  All it means is that you can have
> more than one microcode *type* per system, because you can have more
> than one processor type per system.

I know ;).

Btw, with microcode type you mean two or more different versions of
microcode which the respective CPUs need, right?

> The lack of per-system microcode handling is, as far as I am concerned,
> a rather annoying misfeature, plain and simple.  A per-core interface
> that lets you have mismatched microcode across cores of the same type
> (i.e. that take the same microcode) is, IMO, a bottomless pit of pain
> and suffering which should diediediediedie as soon as possible.

Yeah, but we need to support your use case where you have mixed
processor revisions and you want them to get the microcode suitable for
each one of them.

Otherwise, I'm all for making it per-system too. Or are you saying you
want to have one per-system interface and not per-CPU like what we have
now?

/sys/devices/system/cpu/cpu0/microcode
/sys/devices/system/cpu/cpu1/microcode
...

> It just means the firmware core has to do a per-cpu job, not that we
> should have mismatched microcodes across the same type of cpus, or
> even that we should have the required per-cpu handling of firmware
> exposed to the rest of the kernel and the worst of it all, exposed to
> userspace.

Yeah.

> > Actually, the deal here is that you could have received microcode
> > already from BIOS and you won't have to necessarily load ucode from
> > userspace with the Linux ucode loader.
> 
> Or from an enhanced bootloader.  Yes.

Yeah, I'd like to see that too.

> > Btw, this is why we wanted to load ucode as early as possible but
> > there's no progress on the whole thing right now...
> 
> Which is a pity.

Well, there was this other effort with ACPI tables passed on as blobs
through the initrd and it was an interesting one because we don't have
to change the bootloaders but it kinda died out too.

I know how this is going to happen: some hw vendor will really need to
load ucode very early and will have to code the thing up :-).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

