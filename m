Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab2FAOv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:51:27 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40733 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759031Ab2FAOv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:51:26 -0400
Date: Fri, 1 Jun 2012 15:54:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergey Lapin <slapin@ossfans.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-x25@vger.kernel.org
Subject: Re: [PATCH 2/2] lapb-nl: Added driver
Message-ID: <20120601155446.51751e61@pyramind.ukuu.org.uk>
In-Reply-To: <20120601144040.GA24774@build.ihdev.net>
References: <1338478278-24732-1-git-send-email-slapin@ossfans.org>
	<1338478278-24732-2-git-send-email-slapin@ossfans.org>
	<20120601145201.07a35cc3@pyramind.ukuu.org.uk>
	<20120601144040.GA24774@build.ihdev.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the socket family side I was thinking not of a "lapb-nl" socket layer
but a simple pure LAPB socket - that just uses interface name type
addressing and only supported SOCK_RAW for raw data frames over LAPB
encodings.


> > Again the sl->tty locking needs sorting (I think this may well be true of
> > slip and the others too)
> 
> Could you please explain a bit more on this?

In modern kernels the tty object is refcounted and not locked by any big
global locks.

So in your open do

	tty = tty_kref_get(tty);

and in the close
	tty_kref_put(tty);

and you are guaranteed the tty won't vanish under you between those
points.

> > Why flush ?
> Problems occured a long time ago, will remove and check.

That should be handled by the core code now.

> The whole thing is data packat transfer. Application is also notified when
> packet is delivered. That's it, no fancy stuff. There is also UDP code, but it is
> weird mess, and I think if it is to live or be removed. What do you think?

Weird mess removal is always good stuff.

Alan
