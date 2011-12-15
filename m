Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab1LOVVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 16:21:40 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35933 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759349Ab1LOVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 16:21:39 -0500
Date: Thu, 15 Dec 2011 21:22:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: printk() vs tty_io
Message-ID: <20111215212201.3b1ab204@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFwhFoU5Fp_VTMtVU7XFMZiNvy1J7n7YJsVBu+-k-EH0Nw@mail.gmail.com>
References: <1323804803.9082.40.camel@twins>
	<CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
	<20111214104308.14d0500c@pyramind.ukuu.org.uk>
	<1323860206.28489.35.camel@twins>
	<20111214140527.GA18080@thunk.org>
	<1323872631.28489.37.camel@twins>
	<CA+55aFwu+oSPtqfN+bS3_fHXWU+VMd5BGhNd=J4MjuAJZT+fTQ@mail.gmail.com>
	<1323943005.18942.18.camel@twins>
	<CA+55aFwhFoU5Fp_VTMtVU7XFMZiNvy1J7n7YJsVBu+-k-EH0Nw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - Make a special "debug printk" that is not synchronous. Just make it
> buffer things, and have it actually print out from a worker thread or
> whatever. This one *only* takes the lock for that buffer itself, and
> works everywhere. We could probably even do tricks to make it
> NMI-safe.

No buffer lock needed within limits - our kfifo implementation doesn't
need them on sensible hardware.

Alan
