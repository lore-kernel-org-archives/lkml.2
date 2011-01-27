Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab1A0Knv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:43:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56466 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753741Ab1A0Knt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:43:49 -0500
Date: Thu, 27 Jan 2011 10:43:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org,
        San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
Message-ID: <20110127104343.5931161e@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
	<20110125002449.12637.35623.stgit@mike.mtv.corp.google.com>
	<20110125031752.GA9846@kroah.com>
	<AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com>
	<20110126024608.GB28283@kroah.com>
	<AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I understand that type widths change in a compat setting.  So what?
> Code in each environment is written to it's own namespace anyhow.

So you ned up with a pile of extra crap in the kernel to handle 32bit
userspace on 64bit and the like. If instead the structs are carefully
laid out this doesn't occur.

> Here's what *I* think *you* think about __u32 vs u32 vs uint32_t.
> Correct me if I'm totally off-base here:

And the __aligned_ ones for things like u64 in ioctls and structs...

It's also a style and consistency thing, its trivialto use the same style
as the rest of the kernel, it's trivial to tweak and it helps keep
coherency of style, even if you are sitting at the keyboard mumbling
"bunch of morons if you ask me" while doing it ;)

> I believe the above is non-sense because there is no concerted effort
> to ever let userland include kernel headers in any meaningful way.

Where do you think the library headers are distilled from ?

> Well, personally I like ioctls and system calls.  They don't bloat the
> system with unneeded crud and abstractions that aren't very useful.
> So what if you can't easily interface with them from a bare shell.
> That's what userland utilities are for anyhow.

ioctl has its place and I would agree with you on this one the interface
is essentially structure based so there isn't really that much you can do
about it anyway beyond getting the structures right.

(and the less the rest of the world has to know about EFI SMI internals
the better)

> I'm not sure if you are trying to suggest that there is a better way
> to solve these problems without actually saying so.  We could probably
> use a different interface, sure.

sysfs stuff only really helps for unsynchronized queries, ioctl is
read-modify-write which is a property sysfs lacks.

Alan
