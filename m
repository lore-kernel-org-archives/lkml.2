Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab1LOKcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:32:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60893 "EHLO
	pyramind.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751990Ab1LOKb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:31:59 -0500
Date: Thu, 15 Dec 2011 10:32:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: printk() vs tty_io
Message-ID: <20111215103220.7c08498f@pyramind.ukuu.org.uk>
In-Reply-To: <1323943005.18942.18.camel@twins>
References: <1323804803.9082.40.camel@twins>
	<CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
	<20111214104308.14d0500c@pyramind.ukuu.org.uk>
	<1323860206.28489.35.camel@twins>
	<20111214140527.GA18080@thunk.org>
	<1323872631.28489.37.camel@twins>
	<CA+55aFwu+oSPtqfN+bS3_fHXWU+VMd5BGhNd=J4MjuAJZT+fTQ@mail.gmail.com>
	<1323943005.18942.18.camel@twins>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We probably could, I can have a closer look, but the main question is,
> are we going to commit to no wakeups from console implementations? That
> would mean removing the USB serial console support and other such stuff.

That's a non starter.

> [ Personally I think USB serial console is insane, if you really need
> something like that use the ehci-dbgp thing, that at least has a chance
> of working. ]

Sometimes USB serial console is the best you've got.

> If we're not going to commit to that (which would be valid choice given
> where we are), my printk efforts are pointless and I'll reconsider.

For lockdep spews do they need to be spewed synchronously - clearly it's
good if they can be but its possible that they could be buffered ?

Alan
