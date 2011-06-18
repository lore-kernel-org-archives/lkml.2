Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1FRSba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 14:31:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60410 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752026Ab1FRSb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 14:31:29 -0400
Date: Sat, 18 Jun 2011 19:33:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nemo Publius <nemo@self-evident.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Does Linux select() violate POSIX?
Message-ID: <20110618193340.53811cbe@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTi=Vis=aZ5vn7E0A2LGVPOcmjd+r-g@mail.gmail.com>
References: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
	<1308418985.3539.58.camel@edumazet-laptop>
	<BANLkTi=Vis=aZ5vn7E0A2LGVPOcmjd+r-g@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We dont care, since every sane application using select() should also
> > use socket in non blocking mode.
> 
> This is simply not true for any POSIX-compliant operating system.
> Which in this case happens to include every Unix ever written since
> the beginning of time, apart from Linux.

Actually no - there are lots of device cases where instantaneously it is
true that a read would not block but the condition then changes again.

An obvious simple example beyond that is a socket with two readers.

> Put another way...  The whole point of the POSIX spec is to allow me
> to write portable code.  If every random Unix implementation makes up
> its own mind about what is "sane" and violates the spec in arbitrary
> and unpredictable ways, what is the point of having a spec?

Linux follows Posix generally, but nobody writes portable code that does
blocking reads on a poll/select interface because there are a bazillion
ways it can then block - events read by other tasks, discards due to
memory exhaustion, events that are cleared the other end, etc.

> > Between time select()/poll() says 'OK you can go', and time you enter
> > kernel, conditions might have changed. For example, maybe kernel memory
> > is not available and a send() would _block_, even if socket queue is
> > empty.
> 
> Sounds like a kernel bug.

It's a design decision and a huge performance win. It's one of the areas
where POSIX read in its strictest form cripples your performance.

Alan
