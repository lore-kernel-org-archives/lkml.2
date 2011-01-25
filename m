Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab1AYAuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:50:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42118 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751236Ab1AYAuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:50:01 -0500
Date: Tue, 25 Jan 2011 00:49:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org,
        San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 4/6] driver: Google Bootlog
Message-ID: <20110125004953.3e838962@lxorguk.ukuu.org.uk>
In-Reply-To: <20110125002454.12637.4700.stgit@mike.mtv.corp.google.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
	<20110125002454.12637.4700.stgit@mike.mtv.corp.google.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Search for the BLOG pointer.
> + */
> +static struct bootlog_ptr * __init bootlog_find_pointer(void)
> +{
> +	unsigned long address, length, cur;
> +	struct bootlog_ptr *bp;
> +
> +	/* EBDA pointer contains segment the extended BIOS data area */
> +	address = *(uint16_t *)phys_to_virt(BLOG_EBDA_POINTER);
> +	address <<= 4;	/* convert segment to physical address */
> +
> +	/* EBDA length is byte 0 of the EBDA (stored in kB) */
> +	length = *(uint8_t *)phys_to_virt(address);
> +	length <<= 10;	/* convert to bytes */

Ok this is wrong on two counts

1.	If the EBDA pointer is zero then no EBDA is present (older
boxes sometimes did this up to about the Athlon era).

2.	EBDA isn't an X86 property it's a PC property. asm/bios_ebda
provides one helper and perhaps it all belongs in there (along with 'is
it a PC' sanity check)

3.	And its probably a good idea given the standard of BIOS code to
also check the EBDA end if given is actually within the 640K limit ...



Alan
