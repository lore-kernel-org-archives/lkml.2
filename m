Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab0KVO3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:29:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:49592 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab0KVO3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:29:23 -0500
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20101122142212.GS18100@redhat.com>
References: <4CE52048.5080802@windriver.com>
	 <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com>
	 <4CE583D0.8050407@windriver.com> <20101118200807.GC8131@redhat.com>
	 <1290112234.2109.1534.camel@laptop> <20101119165952.GJ18100@redhat.com>
	 <1290191158.2109.1614.camel@laptop> <20101119225902.GQ18100@redhat.com>
	 <1290208179.2114.13.camel@laptop>  <20101122142212.GS18100@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 22 Nov 2010 15:29:29 +0100
Message-ID: <1290436169.2072.251.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 09:22 -0500, Don Zickus wrote:
> > > +static bool check_hw_exists(void)
> > > +{
> > > +       u64 val, val_new;
> > > +
> > > +       val = 0xabcdUL;
> > > +       (void) checking_wrmsrl(x86_pmu.perfctr, val);
> > > +       rdmsrl(x86_pmu.perfctr, val_new);
> > 
> > 
> > Yeah, this looks about right, although for extreme prudence I'd also
> use
> > a checking_rdmsrl().
> 
> I didn't realize such a function existed, I'll look into it.

yeah, the msr functions are a bit of a mess, but I think its called
something like rdmsrl_safe()
