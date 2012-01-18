Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2ARLj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:39:56 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60356 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2ARLjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:39:54 -0500
Date: Wed, 18 Jan 2012 11:41:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amba-pl011: clear previous interrupts before
 request_irq
Message-ID: <20120118114100.064e2c8f@pyramind.ukuu.org.uk>
In-Reply-To: <20120118100410.GB889@bnru02.bnr.st.com>
References: <1326796493-16080-1-git-send-email-shreshthakumar.sahu@stericsson.com>
	<20120118100410.GB889@bnru02.bnr.st.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	/*
> +	 * Clear previous interrupts before installing interrupt handler
> +	 */
> +	spin_lock_irq(&uap->port.lock);
> +	uap->im = 0;
> +	writew(uap->im, uap->port.membase + UART011_IMSC);
> +	writew(0xffff, uap->port.membase + UART011_ICR);
> +	spin_unlock_irq(&uap->port.lock);

I'm confused why you use spin_lock_irq before you've enabled the IRQ in
the first place but looks fine.

Alan
