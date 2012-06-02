Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab2FBW71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 18:59:27 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42004 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2FBW70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 18:59:26 -0400
Date: Sun, 3 Jun 2012 00:02:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] tty: add lockdep annotations
Message-ID: <20120603000252.0c5008b9@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFzNQe6WCHKBrs_xNY0MxzF4C9jpfLFjSh8GBFTEzGnxxg@mail.gmail.com>
References: <4FC6189B.9080909@fusionio.com>
	<4FC66D3D.6080509@fusionio.com>
	<1338404902.2760.451.camel@edumazet-glaptop>
	<1338410107.2760.544.camel@edumazet-glaptop>
	<1338456918.2760.1318.camel@edumazet-glaptop>
	<1338574627.2760.1545.camel@edumazet-glaptop>
	<CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
	<1338583498.2760.1648.camel@edumazet-glaptop>
	<20120601215620.305155c0@pyramind.ukuu.org.uk>
	<1338584389.2760.1653.camel@edumazet-glaptop>
	<1338621438.2760.1679.camel@edumazet-glaptop>
	<1338623708.2760.1691.camel@edumazet-glaptop>
	<1338624102.2760.1693.camel@edumazet-glaptop>
	<20120602125723.5b057570@pyramind.ukuu.org.uk>
	<1338640231.2760.1704.camel@edumazet-glaptop>
	<CA+55aFwXrX16ufu1yf_D8rXTPXfpN1D72STuNYOMqT57je+jRA@mail.gmail.com>
	<CA+55aFysA72FVTF6k=HnqYjCTqXQO+jcMLeR6MpM=eJm-H+EBQ@mail.gmail.com>
	<20120602211917.14275f12@pyramind.ukuu.org.uk>
	<CA+55aFzNQe6WCHKBrs_xNY0MxzF4C9jpfLFjSh8GBFTEzGnxxg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan, please double-check my revert. I've done an allmodconfig build
> with it, and I've looked at the patch and grepped that I didn't miss
> any 'tty_[un]lock()' cases, but that's the limit of my
> sanity-checking. I did check that this revert means that the main tty
> files are now back in the same exact state they were before that
> "tty_lock: Localise the lock" commit. I left the per-ldisc waitqueue
> change in there, though, that one seemed independent.

per ldisc waitqueue is indeed independent. The rest I'll try and check
but may be Wednesday for a serious check. You could also I guess narrow
the check by leaving it all passing tty in to the lock function but just
using the global lock. Might keep the noise down for the 3.6 work too.

Alan
