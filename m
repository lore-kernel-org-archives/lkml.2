Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab2FLIOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:14:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55642 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2FLIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:14:18 -0400
MIME-Version: 1.0
In-Reply-To: <1339165501.2507.30.camel@laptop>
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
	<1339165501.2507.30.camel@laptop>
Date: Tue, 12 Jun 2012 10:14:16 +0200
Message-ID: <CABPqkBTKHy0prGqsoHcya_AVqMDFP65S3OniJtdybszohar9ew@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 4:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, 2012-06-08 at 16:07 +0200, Stephane Eranian wrote:
> > > +static const u32 snb_ucode_rev = 0x28;
> > > +
> >
> > That needs to be a per CPU model value. It
> > is not the same for SNB vs. SNB-EP. On EP
> > it may even depends on stepping.
>
> Yeah, you said, easiest is removing the const and putting some
> assignments to the thing somewhere in our model switch.
>
> Do you know what values for what chip we should use?
>

Ok, so to close on this, I tried the 6/6/2012 ucode update on a few
SNB-EP systems.

I got two answers depending on the stepping:
C1 (stepping 6) -> 0x618
C2 (stepping 7) -> 0x70c

So we need to check x86_mask for stepping and adjust the value of
snb_ucode_rev accordingly for model 45.
