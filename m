Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab0IWVLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:11:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39690 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752066Ab0IWVLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:11:37 -0400
Date: Thu, 23 Sep 2010 22:34:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: john stultz <johnstul@us.ibm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
Message-ID: <20100923223417.4ed62e5b@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.1009231533040.7522@router.home>
References: <cover.1285261533.git.richard.cochran@omicron.at>
	<alpine.DEB.2.00.1009231238170.2962@router.home>
	<1285268380.2587.11.camel@localhost.localdomain>
	<alpine.DEB.2.00.1009231402420.2962@router.home>
	<1285273684.2587.92.camel@localhost.localdomain>
	<alpine.DEB.2.00.1009231533040.7522@router.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no other scalable time source available for fast timer access
> than the time stamp counter in the cpu. Other time source require
> memory accesses which is inherently slower.

On what hardware ?

> An accurate other time source is used to adjust this clock. NTP does that
> via the clock interfaces from user space which has its problems with
> accuracy. PTP can provide the network synced time access
> that would a more accurate calibration of the time.

Accuracy does not require speed of access. Accuracy requires predictible
latency of access.

> Userland code would introduce latencies that would make sub microsecond
> time sync very difficult.

You can take a multiple micro-second I/O stall or SMI trap on a PC so you
already lost the battle on the platform you seem to be discussing.

> You dont need the user APIs if you directly use the PTP time source to
> steer the system clock. In fact I think you have to do it in kernel space
> since user space latencies will degrade accuracy otherwise.

PTP is not a 'time source' it is one or more source of time. The
distinction is rather important.

> It implies clock tuning in userspace for a potential sub microsecond
> accurate clock. The clock accuracy will be limited by user space
> latencies and noise. You wont be able to discipline the system clock
> accurately.

Noise matters, latency doesn't. And the kernel is getting more and more
real time support all the time.

