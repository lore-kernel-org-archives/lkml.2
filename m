Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab0H0MZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:25:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46307 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751620Ab0H0MY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:24:59 -0400
Date: Fri, 27 Aug 2010 13:41:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>,
        Christian Riesch <christian.riesch@omicron.at>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Message-ID: <20100827134154.50eef56c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100827075727.GA3818@riccoc20.at.omicron.at>
References: <363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>
	<AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>
	<20100817085324.GB3330@riccoc20.at.omicron.at>
	<1282090963.1734.97.camel@localhost>
	<20100818071942.GA4096@riccoc20.at.omicron.at>
	<1282176776.2865.100.camel@localhost.localdomain>
	<20100819055518.GA4084@riccoc20.at.omicron.at>
	<1282594125.3111.344.camel@localhost.localdomain>
	<AANLkTi=nKrRHH6+9mvny718gov8Q+u7DHFikdgNY8YdX@mail.gmail.com>
	<1282874269.4371.74.camel@localhost.localdomain>
	<20100827075727.GA3818@riccoc20.at.omicron.at>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The master node in a PTP network probably takes its time from a
> precise external time source, like GPS. The GPS provides a 1 PPS
> directly to the PTP clock hardware, which latches the PTP hardware
> clock time on the PPS edge. This provides one sample as input to a
> clock servo (in the PTPd) that, in turn, regulates the PTP clock
> hardware.

A PTP clock is TAI, Unix time is UTC.

> This is the core issue and source of misunderstanding, in my view. The
> fact of the matter is, the current generation of computers has
> multiple clocks, and these are usually unsynchronized. I think we
> should not try too hard to cover up or work around this. It is a fact
> of life.

In this case I don't think you can. Their divergence is rather difficult
to handle unless you have a GPS to hand.

But all this talk of "PTP this" and "PTP that" is not helpful. Any
interface for additional time sources should be generic with PTP being
one use case.

Alan
