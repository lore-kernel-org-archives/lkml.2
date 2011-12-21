Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab1LUSux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:50:53 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56774 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1LUSuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:50:51 -0500
Date: Wed, 21 Dec 2011 18:51:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 7/7] serial, 8250: Mostly avoid wakeups from under
 port->lock
Message-ID: <20111221185112.47a4c1ad@pyramind.ukuu.org.uk>
In-Reply-To: <1324484554.10752.16.camel@twins>
References: <20111221105739.798864333@chello.nl>
	<20111221111143.678537446@chello.nl>
	<20111221160323.1084e954@pyramind.ukuu.org.uk>
	<1324484554.10752.16.camel@twins>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also I think it's probably buggy - sending the x_char is forward progress
> > so probably needs to cause a wakeup.
> 
> Could you explain that more, its not actually connecting with any
> neurons..

The tty output queue is the ring buffer + one byte (x_char). It's
effectively two priority queues one of which is 1 byte long and high
priority, the other of which is low priority.

> > So for the moment NAK, but worthy of figuring out how to do it right
> 
> OK, will try and see if I can poke at it a level upwards.. 

I think that is the right magic - and also means all the embedded
consoles might be poked the right way.
