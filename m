Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1ETMjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 08:39:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50771 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751725Ab1ETMjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 08:39:03 -0400
Date: Fri, 20 May 2011 13:37:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>,
        David Miller <davem@davemloft.net>, <tsunanet@gmail.com>,
        <kuznet@ms2.inr.ac.ru>, <pekkas@netcore.fi>, <jmorris@namei.org>,
        <yoshfuji@linux-ipv6.org>, <kaber@trash.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
Message-ID: <20110520133747.2b8fb2b0@lxorguk.ukuu.org.uk>
In-Reply-To: <fc49a1b4c32eee9b5cbfbeec4729eef5@localhost>
References: <1305715384-81716-1-git-send-email-tsunanet@gmail.com>
	<20110518.152653.1486764697527722925.davem@davemloft.net>
	<BANLkTik-6wh8=jb6oMEpJvYC8+KTGGsMsw@mail.gmail.com>
	<20110518.155200.801089483916944725.davem@davemloft.net>
	<20110518202025.GC4175@nuttenaction>
	<BANLkTimtA9BB7g5cOm8c9sGChQjf1P0Q-Q@mail.gmail.com>
	<fc49a1b4c32eee9b5cbfbeec4729eef5@localhost>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For our environment it hurts because we _always_ have an initial RTO >1. I
> understand and accept that 98% will benefit of this modification, no doubt
> Jerry! Try to put yourself in our situation: imaging a proposal of an init
> RTO modification to 0.5 seconds. Maybe because 98% of Internet traffic is
> now localized and the RTO is average now 0.2 seconds. Anyway, this will
> penalize your network always and this will be the situation for one of my
> customer. I can live with that, I see the benefits for the rest of the
> world. But I am happy to see a knob where I can restore the old behavior.
> Maybe some other environments will benefit from a even lower or higher
> initial RTO.

AX.25 is definitely happier with a multi-second round trip but it's a
special case. Some X.25 networks are going to have similar behaviour.

It shouldn't be penalising each connection (and it's worse than that of
course because each node on a shared media network gets in the way of the
rest, plus the queueing effect of all the extra blockages) because done
right multiple connections to the same host can use the previous
connections as estimates (and indeed for the initial RTO there's a good
argument for treating estimates as 'host, then x.y.z.* match, then
average of previous except the x.y.z.* match, then unknown')

The latter would fix an awful lot of the weird cases pretty effectively.

Alan
