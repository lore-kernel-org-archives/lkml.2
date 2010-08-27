Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0H0PV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:21:59 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45117 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754495Ab0H0PVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:21:51 -0400
X-Authenticated: #489911
X-Provags-ID: V01U2FsdGVkX19ESCICW7hEOMMWMF86bbNwSy1rd2MSDTgozufJlo
	cK3XB9hHcmnRoG
Message-ID: <4C77D804.9060500@gmx.net>
Date: Fri, 27 Aug 2010 17:21:40 +0200
From: Patrick Loschmidt <Patrick.Loschmidt@gmx.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, john stultz <johnstul@us.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Krzysztof Halasa <khc@pm.waw.pl>, Rodolfo Giometti <giometti@linux.it>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
References: <363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>	<AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>	<20100817085324.GB3330@riccoc20.at.omicron.at>	<1282090963.1734.97.camel@localhost>	<20100818071942.GA4096@riccoc20.at.omicron.at>	<1282176776.2865.100.camel@localhost.localdomain>	<20100819055518.GA4084@riccoc20.at.omicron.at>	<1282594125.3111.344.camel@localhost.localdomain>	<20100827123849.GC11657@riccoc20.at.omicron.at>	<20100827143844.646eccf6@lxorguk.ukuu.org.uk>	<20100827143437.GB3293@riccoc20.at.omicron.at> <20100827160624.433b3374@lxorguk.ukuu.org.uk>
In-Reply-To: <20100827160624.433b3374@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'd like to add my two cents about the discussion. Just to shortly
introduce myself: I'm working with PTP since version 2002 (now 2008 or
PTPv2) and I'm developing matching network cards, drivers, and also
sometimes a bit of the stack.

I always had the problem of different HW implementations (even my own)
and how to access the clocks there. So reading this thread, I strongly
support the idea to provide a driver class, which allows the userspace
to run certain standard operations (settime, gettime, adjtime, ...) as
proposed and leave the detailed implementation to a specific PTP clock
driver. I always made my own char device, but I don't want to open this
discussion again as for me it doesn't matter.

Concerning the long discussion about PTP clock, system time, etc. I'd
like to say, that from a point of view of PTP every node/host has only
one clock. That means, that if you have a NIC with integrated clock
(required for HW timestamping) it is counted as a node. As soon as you
want to use multiple NICs this is actually outside the PTP protocol
definition, unless you have only one clock available to both network
interfaces (which is hard to achieve).

So the solution to treat a PTP enabled NIC as a time source for the
system time is in general sufficient, unless for applications that
require precise timestamps in applications. I know of use cases where
code gets instrumented to measure time delays, processing time, and
sequence in SW, e.g. distributed databases for trading systems at the
stock exchange.

Summarizing I think it would be a huge step forward, if all the
different HW implementations could be controlled via a standardised
interface through the kernel. I need timestamps from my network card
with ps resolution and to steer the onboard clock from user space. Then
I would be happy already. :-)

Thanks,
Patrick
