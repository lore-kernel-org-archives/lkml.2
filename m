Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab2DKLLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:11:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52766 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2DKLLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:11:05 -0400
Date: Wed, 11 Apr 2012 12:13:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120411121309.4b8f8e40@pyramind.ukuu.org.uk>
In-Reply-To: <4F856173.8000901@cam.ac.uk>
References: <20120410131206.GB31551@sirena.org.uk>
	<20120410142501.6045c6c0@pyramind.ukuu.org.uk>
	<20120410133339.GK7499@opensource.wolfsonmicro.com>
	<20120410144235.1e05efd4@pyramind.ukuu.org.uk>
	<20120410140749.GL7499@opensource.wolfsonmicro.com>
	<20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
	<20120410151943.GM7499@opensource.wolfsonmicro.com>
	<20120410175632.5c11c36e@pyramind.ukuu.org.uk>
	<20120410175846.GQ7499@opensource.wolfsonmicro.com>
	<20120411112411.11825eec@pyramind.ukuu.org.uk>
	<20120411103827.GH3163@opensource.wolfsonmicro.com>
	<4F856173.8000901@cam.ac.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> happily enough. IIO can use it from staging and IIO can migrate whenever.
> IIO is about a heck of a lot other than ADCs.  Keep that in mind. They 
> are a substantial
> corner but we handle a lot of output devices and other input devices 
> (though these
> might be adc's inside, that's not what your average users think of them as).
> We 'have' to ensure anything we do works for the other device types as well.

At the IIO layer, but an ADC layer itself needs very very little indeed.

You've got
	allocate
	deallocate
	read_samples (block/nonblock)
	setup
	->samples() callback

and devices are either polled, IRQ driven or DMA.

Now setup is a lot of different things but those can be abstracted and
added as needed (and much probably taken from the IIO bits).

A pure ADC abstraction ought to be a very very thin layer of code.

> I  know it's not ideal, but at the end of the day IIO had a rather 
> different target when
> we wrote it from SoC ADCs. That target of consistent userspace 
> interfaces and
> brute force data capture still has to be met without introducing major 
> regressions.

I don't see the two conflicting. At one level we have a need for a simple
abstraction for low level ADC access within devices (akin to gpio). At the
level above we have a need for a consistent, sensible interface to
userspace with a stable API.

Your simple IIO examples would just use the ADC abstraction, your complex
IIO examples would use the ADC abstraction *and* layer it with IIO level
code that is mixing it with all the other needed work.

Alan
