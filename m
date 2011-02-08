Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1BHNXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:23:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51657 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751519Ab1BHNXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:23:39 -0500
Date: Tue, 8 Feb 2011 13:26:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: martin capitanio <m@capitanio.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: mmap, the language go, problems with the linux kernel
Message-ID: <20110208132657.1cf55782@lxorguk.ukuu.org.uk>
In-Reply-To: <1297168678.2190.21.camel@marvin>
References: <1297168678.2190.21.camel@marvin>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Feb 2011 13:37:58 +0100
martin capitanio <m@capitanio.org> wrote:

> There popped up a serious problem by implementing a fast memory
> management for the language go. Maybe some experienced kernel hacker
> could join the discussion and help to find the best linux solution for
> the "mmap fiasco" problem.
> 
> https://groups.google.com/forum/#!msg/golang-dev/EpUlHQXWykg/LN2o9fV6R3wJ
> 
> Thanks (in behave of all linux go users:),

I don't actually see a problem.

Linux implements virtual address space limits, and enforces them. The go
language stuff wants to allocate huge amounts of virtual space so you
need to tell the OS you want to allow it to do crazy stuff, which you can
do so. But virtual address space is not free - it has to be tracked and
if the application suddenely tries to fill all of it what will happen ?

You'll hit problems if the kernel is running with vm overcommit disabled
(as well configured servers do),

There are of course ways and means - you can provide your own mmap to
override the libc one for example and manage the address space yourself -
within limits by allocating addresses and doing the syscall giving an
address request.

You'll be ok I suspect on Linux on x86 but there are platforms with very
complicated aliasing rules where the OS tries very hard to map certain
things at certain addresses to avoid cache aliasing work and big slow
downs. There are good reasons why mmap works the way it does.

Alan


