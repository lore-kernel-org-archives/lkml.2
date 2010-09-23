Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0IWUVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:21:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50482 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753502Ab0IWUVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:21:30 -0400
Date: Thu, 23 Sep 2010 21:43:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/8] ptp: Added a clock that uses the eTSEC found on the
 MPC85xx.
Message-ID: <20100923214359.3f287b11@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.1009231348150.2962@router.home>
References: <cover.1285261533.git.richard.cochran@omicron.at>
	<57b64051c816dc9cb856bbb9f38fc901c9d3d651.1285261535.git.richard.cochran@omicron.at>
	<alpine.DEB.2.00.1009231348150.2962@router.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please do not introduce useless additional layers for clock sync. Load
> these ptp clocks like the other regular clock modules and make them sync
> system time like any other clock.

I don't think you understand PTP. PTP has masters, a system can need to
be honouring multiple conflicting masters at once.

> Really guys: I want a PTP solution! Now! And not some idiotic additional
> kernel layers that just pass bits around because its so much fun and
> screws up clock accurary in due to the latency noise introduced while
> having so much fun with the bits.

There are some interesting complications in putting a PTP sync
interface in kernel.
