Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0ITO0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:26:32 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:53078 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab0ITO0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:26:31 -0400
In-Reply-To: <1274433481_6943@mail4.comsite.net>
References: <4BF30793.5070300@us.ibm.com> <4BF30C32.1020403@linux.vnet.ibm.com> <4BF31322.5090206@us.ibm.com> <1274232324.29980.9.camel@concordia> <4BF3F2DB.7030701@us.ibm.com> <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain> <1274319125.22892.38.camel@concordia> <1274319125.22892.38.camel@concordia> <alpine.LFD.2.00.1005201014250.3368@localhost.localdomain> <1274433481_6943@mail4.comsite.net>
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded (IRQF_NODELAY)
X-KeepSent: 6B4F50FA:27908491-C12577A4:004EB556;
 type=4; name=$KeepSent
To: Milton Miller <miltonm@bga.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Doug Maxey <doug.maxey@us.ibm.com>,
        dvhltc@linux.vnet.ibm.com, Darren Hart <dvhltc@us.ibm.com>,
        linux-kernel@vger.kernel.org, linux-kernel-owner@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Milton Miller <miltonm@bga.com>, niv@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Schmidt <will_schmidt@vnet.ibm.com>
X-Mailer: Lotus Notes Release 8.5 HF58 February 06, 2009
Message-ID: <OF6B4F50FA.27908491-ONC12577A4.004EB556-C12577A4.004F51A1@de.ibm.com>
From: Jan-Bernd Themann <THEMANN@de.ibm.com>
Date: Mon, 20 Sep 2010 16:26:22 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 8.0.2FP2|June 22, 2009) at
 20/09/2010 16:26:22
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milton,

sorry for the delayed answer, was on vacation.

linux-kernel-owner@vger.kernel.org wrote on 21.05.2010 11:18:01:
> linux-kernel-owner@vger.kernel.org
>
> On Thu, 20 May 2010 at 10:21:36 +0200 (CEST) Thomas Gleixner  wrote:
> > On Thu, 20 May 2010, Michael Ellerman wrote:
> > > On Wed, 2010-05-19 at 16:38 +0200, Thomas Gleixner wrote:
> > > > On Wed, 19 May 2010, Darren Hart wrote:
> > > >
> > > > > On 05/18/2010 06:25 PM, Michael Ellerman wrote:
> > > > > > On Tue, 2010-05-18 at 15:22 -0700, Darren Hart wrote:
> > >
> > > > > > The result of the discussion about two years ago on this was
that we
> > > > > > needed a custom flow handler for XICS on RT.
> > > > >
> > > > > I'm still not clear on why the ultimate solution wasn't to
> have XICS report
> > > > > edge triggered as edge triggered. Probably some complexity
> of the entire power
> > > > > stack that I am ignorant of.
> > > > >
> > > > > > Apart from the issue of loosing interrupts there is also
> the fact that
> > > > > > masking on the XICS requires an RTAS call which takes a global
lock.
> > > >
> > > > Right, I'd love to avoid that but with real level interrupts we'd
run
> > > > into an interrupt storm. Though another solution would be to issue
the
> > > > EOI after the threaded handler finished, that'd work as well, but
> > > > needs testing.
> > >
> > > Yeah I think that was the idea for the custom flow handler. We'd
reset
> > > the processor priority so we can take other interrupts (which the EOI
> > > usually does for you), then do the actual EOI after the handler
> > > finished.
> >
> > That only works when the card does not issue new interrupts until the
> > EOI happens. If the EOI is only relevant for the interrupt controller,
> > then you are going to lose any edge which comes in before the EOI as
> > well.
>
> Well, the real MSIs have an extra bit to allow the eoi to dally behind
> the mmio on another path and that should cover this race when the irq
> is left enabled.
>
> Jan-Bernd HEA has that change, right?

I don't now. We never hit problems so we did not look very deep into this
area.
We probably have to talk to the HEA HW developers to be sure.

Regards,
Jan-Bernd

