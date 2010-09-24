Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0IXNkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:40:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36308 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753106Ab0IXNkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:40:53 -0400
Date: Fri, 24 Sep 2010 15:02:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
Message-ID: <20100924150246.0e6064b6@lxorguk.ukuu.org.uk>
In-Reply-To: <20100924131407.GA3113@riccoc20.at.omicron.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
	<20100923213654.0c64b047@lxorguk.ukuu.org.uk>
	<20100924131407.GA3113@riccoc20.at.omicron.at>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 15:14:07 +0200
Richard Cochran <richardcochran@gmail.com> wrote:

> On Thu, Sep 23, 2010 at 09:36:54PM +0100, Alan Cox wrote:
> > Drop the clockid_t and swap it for a file handle like a proper Unix or
> > Linux interface. The rest is much the same
> > 
> > 	fd = open /sys/class/timesource/[whatever]
> > 
> > 	various queries you may want to do to check the name etc
> > 
> > 	fclock_adjtime(fd, ...)
> 
> Okay, but lets extend the story:
> 
> 	clock_getttime(fd, ...);
> 
> 	clock_settime(fd, ...);
> 
> 	timer_create(fd, ...);
> 
> Can you agree to that as well?
> 
> (We would need to ensure that 'fd' avoids the range 0 to MAX_CLOCKS).

You can't do that avoiding as you might like because the behaviour of
file handle numbering is defined by the standards. Hence the "f*"
versions of the calls (and of lots of other stuff)

Whether you add new syscalls or do the fd passing using flags and hide
the ugly bits in glibc is another question.

