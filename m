Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0H0Odn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:33:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45938 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753994Ab0H0Odi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 10:33:38 -0400
Date: Fri, 27 Aug 2010 15:50:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>,
        Christian Riesch <christian.riesch@omicron.at>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Message-ID: <20100827155040.0502ec1b@lxorguk.ukuu.org.uk>
In-Reply-To: <20100827140205.GA3293@riccoc20.at.omicron.at>
References: <20100817085324.GB3330@riccoc20.at.omicron.at>
	<1282090963.1734.97.camel@localhost>
	<20100818071942.GA4096@riccoc20.at.omicron.at>
	<1282176776.2865.100.camel@localhost.localdomain>
	<20100819055518.GA4084@riccoc20.at.omicron.at>
	<1282594125.3111.344.camel@localhost.localdomain>
	<AANLkTi=nKrRHH6+9mvny718gov8Q+u7DHFikdgNY8YdX@mail.gmail.com>
	<1282874269.4371.74.camel@localhost.localdomain>
	<20100827075727.GA3818@riccoc20.at.omicron.at>
	<20100827134154.50eef56c@lxorguk.ukuu.org.uk>
	<20100827140205.GA3293@riccoc20.at.omicron.at>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To tell the truth, my original motivation for the patch set was to
> support PTP clocks and applications. I don't think that is such a bad

ptp *clocks*

> idea. After all, the adjtimex interface was added just to support NTP.
> 
> At the same time, I can understand the desire to have a generic
> hardware clock adjustment API. Let me see if I can understand and
> summarize what people are asking for:
> 
> 	  clock_adjtime(clockid_t id, struct timex *t);
> 
> and struct timex gets some new fields at the end.

For a new syscall you could equally make it

	(clockid_t id, void *args)

> Using the call, NTPd can call clock_adjtime(CLOCK_REALTIME) and PTPd
> can call clock_realtime(CLOCK_PTP) and everyone is happy, no?

If you only have one clock that you are calling 'the PTP clock' - but is
that a good assumption ?

I agree with your fundamental arguments as I understand them

- That it's another clock or clocks possibly not synchronized with the
  system clock

- That there should be a sensible API for doing slews and steps on other
  clocks but the systen clock.

I'm concerned about the assumption that there is a single magic PTP
clock, and calling it a PTP clock for two reasons

- There can be more than one

- PTP is just a protocol, in five years time it might be TICTOC or
  something newer and more wonderous, in some environments it'll be a
  synchronous distributed clock generation not PTP etc. Wiring PTP or
  IEE1588v2 into the clock name doesn't make sense.

I'd be happier with a model which says we have some arbitary number of
synchronization sources which may or may not have a connection to system
time, and may be using all sorts of synchronization methods. Clock in
fact seems almost a misnomer.

Alan


