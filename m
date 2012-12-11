Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab2LKRLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:11:44 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60865 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2LKRLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:11:43 -0500
Date: Tue, 11 Dec 2012 17:16:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Yehuda Yitschak <yehuday@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Lior Amsalem <alior@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions in
 CONFIG_HAS_IOPORT
Message-ID: <20121211171610.01c2de16@pyramind.ukuu.org.uk>
In-Reply-To: <20121211162647.GS14363@n2100.arm.linux.org.uk>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<1354917879-32073-2-git-send-email-thomas.petazzoni@free-electrons.com>
	<201212111043.50627.arnd@arndb.de>
	<20121211162647.GS14363@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Correct.  If HAS_IOPORT is not selected then we are potentially missing
> the dependent functions (because the platform has no IOPORT support) _or_
> it does have ISA/PCI IO spaces _but_ they're not mappable via the
> ioport_map() mechanism due to some non-linearity involved in the
> translation.
> 
> To make that second point clear, that's platforms where:
> 
> 	ioport_map(addr + 4) != ioport_map(addr) + 4.

For inb/inw and friends this shouldn't matter.

You can implement inl for example 

as

	if (unlikely(addr & 3))
		// or in fact BUG on this for almost all h/w
		uninlined_hard_slow_inl(addr);
	else
		return *(u32 *)iospace_map[addr];






