Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0IXLaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 07:30:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37970 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751334Ab0IXLaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 07:30:17 -0400
Date: Fri, 24 Sep 2010 12:52:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christian Riesch <christian@riesch.at>
Cc: Christoph Lameter <cl@linux.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/8] ptp: Added a clock that uses the eTSEC found on the
 MPC85xx.
Message-ID: <20100924125238.4c30f3a4@lxorguk.ukuu.org.uk>
In-Reply-To: <4C9BC620.3@riesch.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
	<57b64051c816dc9cb856bbb9f38fc901c9d3d651.1285261535.git.richard.cochran@omicron.at>
	<alpine.DEB.2.00.1009231348150.2962@router.home>
	<20100923214359.3f287b11@lxorguk.ukuu.org.uk>
	<4C9BC620.3@riesch.at>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, if the clock selected by the BMC is switched off, loses its 
> network connection..., the second best clock is selected by the BMC and 
> becomes master. This clock may be less accurate and thus our slave clock 
> has to switch from one notion of time to another. Is that the conflict 
> you mentioned?

No you get situations where you have policy reasons for trusting
particular clocks for particular things.

So you may have a PTP or NTP clock providing basic system time but also
have other PTP clocks that are actually being used for synchronization
work.

With NTP it's not so far been a big issue - NTP isn't used for industrial
high precision control and the cases we end up with multiple NTP clocks
it's on a virtualised systems where it is isolated.

With high precision clocks you sometimes want to honour a specific PTP
time source and use it rather than try and merge it with your other time
sources (which may differ from the equipment elsewhere). What matters is
things like all the parts of a several mile long conveyor belt of hot
steel slab stopping at the same moment [1].

In lots of control applications you've got assorted different time planes
which wish to talk their own time and you have to accept it, so we need
to support that kind of use.

I agree entirely the normal boring 'I installed my distro and..' case for
PTP or for NTP is merging all the sources, running the algorithm and using
the system time for it. Likewise almost all "normal" application code
will be watching system time.

Alan
[1] Which was my first encounter with writing Vax/VMS assembly language
