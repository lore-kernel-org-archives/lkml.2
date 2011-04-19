Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1DSVTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:19:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50591 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755534Ab1DSVTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:19:53 -0400
Date: Tue, 19 Apr 2011 22:20:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, arnd@arndb.de
Subject: Re: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
Message-ID: <20110419222032.6529bd31@lxorguk.ukuu.org.uk>
In-Reply-To: <20110419221653.585a132e@lxorguk.ukuu.org.uk>
References: <20110419145303.111aead7@endymion.delvare>
	<BANLkTinbO_p=sKtFJtjgpo4yrEVopq9vrw@mail.gmail.com>
	<20110419155406.1da0e7fb@lxorguk.ukuu.org.uk>
	<BANLkTi=tzXyozCck9H03-2RErGsvSxrv1Q@mail.gmail.com>
	<20110419165746.2857c56f@lxorguk.ukuu.org.uk>
	<20110419164048.GA30346@oksana.dev.rtsoft.ru>
	<20110419180829.56daccd0@lxorguk.ukuu.org.uk>
	<20110419203031.GA6494@oksana.dev.rtsoft.ru>
	<20110419221653.585a132e@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I.e. PCI driver can now map the whole area with a single ioremap(),
> > and then call bgpio_probe(), which will provide accessors and
> > common MMIO GPIO registration stuff.
> 
> Looks sane and providing its all using iomap/ioread/iowrite it covers all
> cases nicely.

Actually not using iomap makes more sense on second thoughts, not all
platforms have a generic iomap implementation.

So yes this all looks good.
