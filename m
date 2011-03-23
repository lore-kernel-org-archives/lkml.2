Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1CWJiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:38:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40188 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932085Ab1CWJip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:38:45 -0400
Date: Wed, 23 Mar 2011 09:38:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, andy.green@linaro.org,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110323093847.55e9dbba@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1103222336030.11889@xanadu.home>
References: <4D79F068.2080009@linaro.org>
	<AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
	<1300828125.2402.300.camel@pasglop>
	<4D8924B6.8040403@linaro.org>
	<1300842219.2402.309.camel@pasglop>
	<alpine.LFD.2.00.1103222138320.11889@xanadu.home>
	<1300850595.2402.320.camel@pasglop>
	<alpine.LFD.2.00.1103222336030.11889@xanadu.home>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Does it make sense however to add platform data for generic probed
> > devices ? I don't think so.
> 
> Generally speaking, this wouldn't make sense.  but this is a case where 
> a generically probed device happens to be used in a very specific 
> hardware design with its own quirks.  in that very particular case then 
> it certainly makes some sense.

If it's a very specific hardware design it can do its own very specific
internal private kernel patch, or little config app in user space. There
isn't a valid reason to inflict that complexity on the other 99.999999%
of users.

> actual device registration.  So, while this is true that there is a 
> possibility for misuse, in practice this is rather unlikely to go very 
> far without being noticed, and therefore this argument alone is rather 
> weak in support of a significant world order change.

You mean it'll get missed and years later will get compiled into some
other device and a joker with a custom USB widget will add the ids to his
widget and declare it an exploit ?


The other thing being overlooked is that for board specific horrors you
can still put them in udev quite easily if your udev happens to know how
to parse some kind of firmware provided table. That might even be bits of
your device tree.

The kernel simply shouldn't get involved in machine specific namespace
fights.

Alan
