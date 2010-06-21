Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0FUMUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 08:20:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37601 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752995Ab0FUMUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 08:20:10 -0400
Date: Mon, 21 Jun 2010 13:22:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tytso@mit.edu
Cc: markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100621132234.5eb880b0@lxorguk.ukuu.org.uk>
In-Reply-To: <20100621121058.GF6199@thunk.org>
References: <201006202350.27143.rjw@sisk.pl>
	<Pine.LNX.4.44L0.1006202154260.29532-100000@netrider.rowland.org>
	<20100621061345.GF9735@gvim.org>
	<20100621121058.GF6199@thunk.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There's been one proposal that we simply merge in a set of no-op
> inline functions for suspend blockers, just so we can get let the
> drivers go in (assuming that Greg K-H believes this is still a
> problem), but with an automatical removal of N months (N to be
> decided, say 9 or 12 or 18 months).

If you automatically remove the suspend blocker wrappers in 12 months
then you can keep the drivers in tree.

The drivers are generally not a problem (ok some of them like the binder
are interesting little trips) its just those hooks, and we'd all benefit
somewhat even if the only bit google are patching back in are their hooks.

> down the road for N months.  Another approach is to simply merge in
> no-op functions and not leave any kind of deprecation schedule.
> That's sort of an implicit admission of the fact that we may not reach
> consensus on this issue.  Or we could simply ship the patches as-is to

Very bad precedent. What happens when every other vendor does the same ?
Keep the upstream code clean. 

> Linus after he gets back from vacation and ask him for a thumbs up or
> thumbs down vote, which might settle things once and for all.

You seem desperate to just throw it at Linus - you have been all along
before the discussion, during it and now: but I don't understand why ?
It's as if you don't want progress to be made by other means ?

> How do we go forward from here?

PM QoS seems to be evolving nicely.

As for merging stuff - if its new code then it should get submitted with
the hooks left out anyway, just as all the other vendors are doing with
weird little custom hooks of their own. The hooks can still easily be
patched back in as a tiny easy to maintain vendor patch.

This works - the code still gets updated and seen by people, only the
little hook patch has to be maintained and generally it looks after
itself except for the odd .rej when something changes right up by the
merge point.

Alan
