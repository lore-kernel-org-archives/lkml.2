Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294Ab2FHODr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:03:47 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:13651
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933313Ab2FHODl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:03:41 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(z1823lz98dI1432Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5AXPZ-01-1C3-02
X-M-MSG: 
Date: Fri, 8 Jun 2012 16:03:52 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <andi@firstfloor.org>, <mingo@elte.hu>, <ming.m.lin@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120608140352.GC31359@aftab.osrc.amd.com>
References: <1339064319.23343.13.camel@twins>
 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
 <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
 <20120608135117.GB31359@aftab.osrc.amd.com>
 <1339163771.2507.18.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339163771.2507.18.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 03:56:11PM +0200, Peter Zijlstra wrote:
> >  static __init void intel_sandybridge_quirk(void)
> >  {
> > +       intel_snb_verify_ucode();
> > +       /*
> > +        * we're still single threaded, so while there's a hole here,
> > +        * you can't trigger it.
> > +        */
> > +       microcode_notifier(intel_snb_ucode_notifier);
> >  }
> 
> Like that you mean?

Oh ok, this is regged through x86_add_quirk() in the pmu init code. Yep,
this is what I mean.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

