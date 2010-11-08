Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0KHLke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:40:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46092 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754492Ab0KHLkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:40:33 -0500
Date: Mon, 8 Nov 2010 11:38:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <ilkka.koskinen@nokia.com>
Cc: <linux-input@vger.kernel.org>, <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Message-ID: <20101108113853.772b960e@lxorguk.ukuu.org.uk>
In-Reply-To: <F80267346F10C541946CBE8909F1C39E36817A8845@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1288013463-21722-1-git-send-email-ilkka.koskinen@nokia.com>
	<20101107235157.728ea5b6@lxorguk.ukuu.org.uk>
	<F80267346F10C541946CBE8909F1C39E36817A8845@NOK-EUMSG-02.mgdnok.nokia.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010 12:08:07 +0100
<ilkka.koskinen@nokia.com> wrote:

> Hi,
> 
> >From: ext Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> >Sent: 08 November, 2010 01:52
> >
> >> +	datalen = p->custom_len * sizeof(p->custom_data[0]);
> >
> >signed
> >
> >> +	if (datalen > MAX_EFFECT_SIZE) {
> >
> >unsigned
> 
> It should be unsigned. I'll fix it.
> 
> >> +	memcpy(einfo->buf, p->custom_data, datalen);
> >
> >ungood
> 
> Yep, that's clearly wrong too. Should be copy_from_user() I suppose.

That I hadn't considered - and I'm not sure whether the caller is passed
a kernel copy or not. The problem I was looking at was just the signed
case

	datalen < 0
	if (datalen > MAX ..)
		Nope

	memcpy(kernel, mysource, vastly more than intended (unsigned))

