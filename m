Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab2FHOTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:19:10 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:15306 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757068Ab2FHOTH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:19:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(z1823lz98dIc89bh1432Izz1202hzzz2dh668h839h93fhd25hf0ah)
X-WSS-ID: 0M5AYFN-02-6MC-02
X-M-MSG: 
Date: Fri, 8 Jun 2012 16:19:21 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>, <andi@firstfloor.org>, <mingo@elte.hu>,
        <ming.m.lin@intel.com>, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120608141921.GF31359@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad>
 <1339064319.23343.13.camel@twins>
 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
 <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
 <CABPqkBQprykpCH=A4VQhNAc2j8JQm3Z0d_EV=Nb3bV1QZ_++nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CABPqkBQprykpCH=A4VQhNAc2j8JQm3Z0d_EV=Nb3bV1QZ_++nw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 04:07:43PM +0200, Stephane Eranian wrote:
> > The very worst is that it does per-cpu micro-code updates, not machine
> > wide. This results in it being able to have different revisions on
> > different cpus. This in turn makes the below O(n^2) :/
> >
> But it's not like this is a frequent operation either...

Yep, you're only doing it when there's new version from the hw vendor or
when rebooting...

[ … ]

> > +extern struct blocking_notifier_head microcode_notifier;
> > +
> That is a problem because microcode can be compiled as a module.
> When I tried compiling your patch I got undefined for this notifier because
> I have microcode update as a module...

Yes, because it uses request_firmware() and it needs userspace.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

