Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab0HTKQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 06:16:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53837 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751499Ab0HTKQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 06:16:26 -0400
Date: Fri, 20 Aug 2010 11:31:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Michal Simek <monstr@monstr.eu>,
        michal.simek@petalogix.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: 8250: Initialize pointer to irq_info
Message-ID: <20100820113125.6d7b498f@lxorguk.ukuu.org.uk>
In-Reply-To: <20100819164354.09e30dc9.akpm@linux-foundation.org>
References: <1282031947-16483-1-git-send-email-monstr@monstr.eu>
	<20100817091720.56183993@linux.intel.com>
	<20100819164354.09e30dc9.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Use a newer compiler - modern ones get this right.
> 
> : static void serial_unlink_irq_chain(struct uart_8250_port *up)
> : {
> : 	struct irq_info *i;
> : 	struct hlist_node *n;
> : 	struct hlist_head *h;
> : 
> : 	mutex_lock(&hash_mutex);
> : 
> : 	h = &irq_lists[up->port.irq % NR_IRQ_HASH];
> : 
> : 	hlist_for_each(n, h) {
> : 		i = hlist_entry(n, struct irq_info, node);
> : 		if (i->irq == up->port.irq)
> : 			break;
> : 	}
> : 
> : 	BUG_ON(n == NULL);
> : 	BUG_ON(i->head == NULL);
> 
> How can any compiler possibly determine that the hlist_for_each() is
> never executed zero times?

We had this argument was it two years ago ?

Modern gcc is capable of at least working out it can't work it out and
doesn't emit a spurious warning.

