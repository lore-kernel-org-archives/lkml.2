Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1LIS7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:59:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36271 "EHLO
	pyramind.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751361Ab1LIS7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:59:44 -0500
Date: Fri, 9 Dec 2011 19:00:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Matthias Fuchs <mfuchs@ma-fu.de>
Subject: Re: [PATCH RESEND 2/8] serial: 8250: Add ioctl to enable auto rs485
 mode with some Exar UARTs
Message-ID: <20111209190019.0b983f48@pyramind.ukuu.org.uk>
In-Reply-To: <1323450440-414-3-git-send-email-w.sang@pengutronix.de>
References: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
	<1323450440-414-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Dec 2011 18:07:14 +0100
Wolfram Sang <w.sang@pengutronix.de> wrote:

> From: Matthias Fuchs <mfuchs@ma-fu.de>
> 
> Some Exar UARTs support an auto rs485 mode. In this mode
> the UART's RTS# pin is activated during transmitting and
> can be used to enable a rs485 line driver. This has nothing
> to do with attempts to do this by manually asserting/
> deasserting handshake lines in software.

Please split this out so that the ioctl handler calls a pair of port->
methods or errors if NULL. That'll future proof it and keep chip specific
stuff out of the direct paths.

Other than that I'm fine with it. Functionality, locking etc.

Alan
