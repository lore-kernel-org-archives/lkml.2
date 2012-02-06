Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2BFREE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:04:04 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47551 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab2BFREC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:04:02 -0500
Date: Mon, 6 Feb 2012 17:05:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add I2C driver for Summit Microelectronics SMB347
 Battery Charger.
Message-ID: <20120206170528.6c74f206@pyramind.ukuu.org.uk>
In-Reply-To: <20120206163544.GO3070@opensource.wolfsonmicro.com>
References: <20120206155729.9947.22792.stgit@bob.linux.org.uk>
	<20120206160127.GF10173@sirena.org.uk>
	<20120206162409.4f7536cf@pyramind.ukuu.org.uk>
	<20120206163544.GO3070@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012 16:35:45 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Mon, Feb 06, 2012 at 04:24:09PM +0000, Alan Cox wrote:
> > Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > > There's quite a lot of read/modify/write cycles and...
> 
> > True but they are basically all in the setup side of things so I'm not
> > sure the complexity is justified or appropriate ?
> 
> I'm not sure what complexity you mean?  If the interface is too
> difficult to use we should fix that but I didn't notice anything in the
> driver which should be more than a straight substitution (or deletion of
> code in the case of the debugfs file).

The API seems fine to me but you've then got to implement the
writeable/readable/volatile reg callbacks and figure out what is cachable
for the chip and specify it.

Seems like overkill for a chip you poke asynchronously during boot and
then basically let it mind its own business.

Alan
