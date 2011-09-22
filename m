Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab1IVWtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:49:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40128 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753901Ab1IVWty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:49:54 -0400
Date: Thu, 22 Sep 2011 23:47:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Daney <david.daney@cavium.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-ID: <20110922234737.05dff9f8@lxorguk.ukuu.org.uk>
In-Reply-To: <4E7BA661.7070903@cavium.com>
References: <20110922184614.25419.84606.stgit@ponder>
	<20110922212909.49966cf4@lxorguk.ukuu.org.uk>
	<4E7BA661.7070903@cavium.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How would a given driver know that something else is waiting for it?  Or 
> would we add the explicit kick to each and every driver in the tree?

I think there are very very few drivers that have this property and don't
already implicitly cause a probe by creating a new bus or device.

Those drivers that set something up for another device really should
know what is going on because they are making a guarantee that they are
ready for the other device to call into them or whatever is going on at
some point, either explicitly in the kick or implicitly in returning from
their probe method.

I know which I think is clearer and easier for a 3rd party to see and not
miss completely when updating code.

Alan
