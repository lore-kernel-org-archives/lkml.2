Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1DSP46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:56:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57073 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753143Ab1DSP45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:56:57 -0400
Date: Tue, 19 Apr 2011 16:57:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
Message-ID: <20110419165746.2857c56f@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTi=tzXyozCck9H03-2RErGsvSxrv1Q@mail.gmail.com>
References: <20110419145303.111aead7@endymion.delvare>
	<BANLkTinbO_p=sKtFJtjgpo4yrEVopq9vrw@mail.gmail.com>
	<20110419155406.1da0e7fb@lxorguk.ukuu.org.uk>
	<BANLkTi=tzXyozCck9H03-2RErGsvSxrv1Q@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Doing a platform device is one solution that is pretty simple to
> implement and I don't think adding child devices is at all a problem.
> However, I'm not mandating that approach, and if you or Jean prefer to
> abstract out the gpio accessors from basic_mmio_gpio(), then that is
> fine by me.  The key issue it to avoid merging yet another, probably
> subtly broken, set of GPIO accessor functions if it can at all be
> avoided.

As is adding a set of subtly broken attempts to create device stacks that
then get into funny sysfs and power management tangles. As well as being
about 12K larger due to the need to suck in an extra module.

I can see the point of splitting out the accessors but if thats a module
of its own then thats another 8K we don't need to waste on a few hundred
bytes of utterly trivial code.

