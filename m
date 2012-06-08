Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab2FHVCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:02:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36066 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601Ab2FHVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:02:44 -0400
X-Sasl-enc: tUJak5GbssvxrifyL2EtfES1LpdGFvzo4+kQ1kzIE6GJ 1339189363
Date: Fri, 8 Jun 2012 18:02:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120608210239.GB16470@khazad-dum.debian.net>
References: <20120607071531.GA4849@quad>
 <1339064319.23343.13.camel@twins>
 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
 <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
 <20120608135117.GB31359@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608135117.GB31359@aftab.osrc.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2012, Borislav Petkov wrote:
> On Fri, Jun 08, 2012 at 03:26:12PM +0200, Peter Zijlstra wrote:
> > On Fri, 2012-06-08 at 12:00 +0200, Peter Zijlstra wrote:
> > > > > Or we could put a hook in the ucode loader.
> > > > 
> > > > I'd really suggest the latter - I doubt this will be our only 
> > > > ucode dependent quirk, going forward ...
> > > 
> > > Yeah, am in the middle of writing that.. 
> > 
> > OK so the micro-code stuff is a complete trainwreck.
> > 
> > The very worst is that it does per-cpu micro-code updates, not machine
> > wide. This results in it being able to have different revisions on
> > different cpus. This in turn makes the below O(n^2) :/
> 
> Reportedly, there are some obscure systems which need different
> microcode versions per CPU:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/01010.html

I wrote that email you linked above.  All it means is that you can have
more than one microcode *type* per system, because you can have more
than one processor type per system.

The lack of per-system microcode handling is, as far as I am concerned,
a rather annoying misfeature, plain and simple.  A per-core interface
that lets you have mismatched microcode across cores of the same type
(i.e. that take the same microcode) is, IMO, a bottomless pit of pain
and suffering which should diediediediedie as soon as possible.

> > Why do we have per-cpu firmware anyway?
> 
> See above.

It just means the firmware core has to do a per-cpu job, not that we
should have mismatched microcodes across the same type of cpus, or even
that we should have the required per-cpu handling of firmware exposed to
the rest of the kernel and the worst of it all, exposed to userspace.

> Actually, the deal here is that you could have received microcode
> already from BIOS and you won't have to necessarily load ucode from
> userspace with the Linux ucode loader.

Or from an enhanced bootloader.  Yes.

> Btw, this is why we wanted to load ucode as early as possible but
> there's no progress on the whole thing right now...

Which is a pity.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
