Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab0JZLSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 07:18:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46275 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932396Ab0JZLSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 07:18:54 -0400
Date: Tue, 26 Oct 2010 12:17:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Message-ID: <20101026121749.298dc60a@lxorguk.ukuu.org.uk>
In-Reply-To: <20101026111344.GB24714@angua.secretlab.ca>
References: <1288013463-21722-1-git-send-email-ilkka.koskinen@nokia.com>
	<20101026111344.GB24714@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (!einfo->buf) {
> > +		einfo->buf = kzalloc(datalen, GFP_KERNEL | GFP_DMA);
> > +		if (!einfo->buf) {
> > +			ret = -ENOMEM;
> > +			goto exit;
> > +		}
> > +	}
> > +
> > +	memcpy(einfo->buf, p->custom_data, datalen);
> 
> It looks like raw data from userspace is being passed on to the
> device.  Is this sane?  Is there already a data format used by other
> vibration/feedback devices that should be used here instead and
> translated into the form expected by the hardware?

It also seems to be using GFP_DMA not dma_alloc functions which looks a
bit odd and certainly isn't portable.

