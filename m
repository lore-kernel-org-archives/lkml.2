Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab2DKKZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:25:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34230 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab2DKKZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:25:18 -0400
Date: Wed, 11 Apr 2012 11:24:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120411112411.11825eec@pyramind.ukuu.org.uk>
In-Reply-To: <20120410175846.GQ7499@opensource.wolfsonmicro.com>
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
	<20120410131206.GB31551@sirena.org.uk>
	<20120410142501.6045c6c0@pyramind.ukuu.org.uk>
	<20120410133339.GK7499@opensource.wolfsonmicro.com>
	<20120410144235.1e05efd4@pyramind.ukuu.org.uk>
	<20120410140749.GL7499@opensource.wolfsonmicro.com>
	<20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
	<20120410151943.GM7499@opensource.wolfsonmicro.com>
	<20120410175632.5c11c36e@pyramind.ukuu.org.uk>
	<20120410175846.GQ7499@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Non-staging code cannot depend upon staging code. That is the rule GregKH
> > laid down. The Intel drivers involved are established non staging drivers
> > and the gpadc layer is basically cleaning up the fact they all do this
> > themselves in private right now without any central co-ordination or
> > abstraction.
> 
> So, that's a bit different and not at all obvious from your e-mail - the
> diffstat shows only the code you're adding, not the code you've factored
> out of the existing mainline drivers.  The diffstat you posted was:
> 
> | arch/x86/include/asm/intel_mid_gpadc.h   |   13 +
> | arch/x86/platform/mrst/Makefile          |    1
> | arch/x86/platform/mrst/intel_mid_gpadc.c |  645 ++++++++++++++++++++++++++++++
> | arch/x86/platform/mrst/mrst.c            |    6
> | 4 files changed, 665 insertions(+), 0 deletions(-)
> 
> which is a pure addition of code and I'm not seeing anything in the
> changelog about this either.

True.. the code factoring out stuff is supposed to follow once this is
sorted.

> We do have to be careful about this sort of "this is a little bit of low
> level code" thing - it (along with "our hardware is unique") comes up
> rather a lot and it's often missing a good chunk of the picture.

Yes. But it also helps - there is no user space API here so the only bit
of IIO that needs importing is small, and if the API in kernel changes
nothing userspace will break.

I don't btw think that layer should depend upon IIO though - IIO should
depend upon that layer. There's no need to drag all the rest of IIO in
for this, just as it can depend upon the gpio layer etc.

If that code gets pulled out of IIO dumped into drivers/adc and has a bit
of a different API to the gpadc code then no problem, gpadc can follow it
happily enough. IIO can use it from staging and IIO can migrate whenever.

It does make sense to think hard about userspace APIs for IIO but for
kernel APIs its really being too conservative - we break kernel APIs
every release. They are not set into stone.

Alan
