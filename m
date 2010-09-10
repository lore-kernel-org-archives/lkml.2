Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0IJLYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:24:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53774 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751191Ab0IJLYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:24:04 -0400
Date: Fri, 10 Sep 2010 12:44:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Joe Perches <joe@perches.com>, florian@mickler.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100910124408.633afc48@lxorguk.ukuu.org.uk>
In-Reply-To: <20100910101818.GF3068@rakim.wolfsonmicro.main>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100910095259.GC23903@sirena.org.uk>
	<1284113066.1783.69.camel@Joe-Laptop>
	<20100910101818.GF3068@rakim.wolfsonmicro.main>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > One possible improvement that get_maintainers could
> > add is to [optionally] CC the author of the first
> > commit when there's no listed maintainer.
> 
> That might be a nice option (though it will still give false positives).
> Something based on percentage of the driver written rather than log
> entry counts might also be interesting.

Within a time limit yes.

I'd guess a heuristic along the lines of

original committer && has committed in the past 6 months

might work rather well - and you could probably walk up the list of
signed-off-by this way with the same rule and take a fair shot at a
maintainer.

Trouble is for a lot of other stuff beyond that you need to hit the
person whose signoff is on most of the submits to that file/subtree in the
past six months but not count wide cross tree commits

That gets a bit harder to compute.

Seems like there is a social sciences or systems research project here
to do some graph theory and modelling into "who really maintains the Linux
kernel"

Alan
