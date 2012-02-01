Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2BAT5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:57:25 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54010 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab2BAT5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:57:24 -0500
Date: Wed, 1 Feb 2012 19:58:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Torvald Riegel <triegel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
        dsterba@suse.cz, ptesarik@suse.cz, rguenther@suse.de, gcc@gcc.gnu.org
Subject: Re: Memory corruption due to word sharing
Message-ID: <20120201195819.76357d79@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFw=z2SKFGoSE5e_0ZmKcAAjK5q0DBM4PaxBH2D9tuikzA@mail.gmail.com>
References: <20120201151918.GC16714@quack.suse.cz>
	<CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com>
	<1328118174.15992.6206.camel@triegel.csb>
	<CA+55aFw=z2SKFGoSE5e_0ZmKcAAjK5q0DBM4PaxBH2D9tuikzA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So here's basically what the kernel needs:
> 
>  - if we don't touch a field, the compiler doesn't touch it.
> 
>    This is the rule that gcc now violates with bitfields.
> 
>    This is a gcc bug. End of story. The "volatile" example proves it -
> anybody who argues otherwise is simply wrong, and is just trying to
> make excuses.

C historically didn't make this guarantee because a lot of processors
couldn't make it because they didn't have things like byte accessors (In
fact I suspect early ARM cannot make it for example).

Not meeting it for types where you can do is a bit rude however and
really ought to be an option (speed v sanity).

> See above: it's not the "state" that is accessed concurrently. It's
> the code. If you ever try to mark state, you've already lost. The same
> "state" can be atomic or not depending on context. It's not about the
> state or the data structures, and it never will be.

There are optimisation cases - where you can prove access properties are
safe (eg local variables some times) but they should be exactly that -
optimisations.

Alan
