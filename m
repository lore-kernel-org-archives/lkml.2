Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1EJK1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:27:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37601 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751445Ab1EJK1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:27:06 -0400
Date: Tue, 10 May 2011 11:27:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>, "Arnd Bergmann" <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, <sachi@mistralsolutions.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <Netdev@vger.kernel.org>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "CAN NETWORK DRIVERS" <socketcan-core@lists.berlios.de>,
        <m-watkins@ti.com>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Message-ID: <20110510112734.54160824@lxorguk.ukuu.org.uk>
In-Reply-To: <F1859F4DD03040248B42AC947304D39B@subhasishg>
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com>
	<201105041511.54095.arnd@arndb.de>
	<4DC163D7.9010309@grandegger.com>
	<201105041648.37199.arnd@arndb.de>
	<4DC17831.3070801@grandegger.com>
	<F1859F4DD03040248B42AC947304D39B@subhasishg>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011 15:41:49 +0530
"Subhasish Ghosh" <subhasish@mistralsolutions.com> wrote:

> >> 
> >> It sounds to me like the best solution would be change the firmware
> >> to lift that restriction and simply allow all IDs, in case it's not
> >> actually a hardware limitation (which sounds unlikely).
> > 
> > Yes, that would be best but they told us, that it's not possible with
> > the available hardware resources. Subhasish?
> 
> Yes, In case if we allow the ALL implementation, it hogs the CPU.
> In that case we do not need the PRU. The whole purpose of the PRU
> is to offload the processor for any such implementations. 

So the kernel presumably needs to switch between using the PRU and native
according to the number of ids being requested at the time ?

That would be roughly what we do with other things (eg IP multicast) so
that apps don't need to know all the innards
