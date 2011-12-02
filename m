Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1LBXRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:17:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41598 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752065Ab1LBXRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:17:37 -0500
Date: Fri, 2 Dec 2011 23:19:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: HoP <jpetrous@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
In-Reply-To: <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011 15:58:41 +0100
HoP <jpetrous@gmail.com> wrote:

> Hi,
> 
> let me ask you some details of your interesting idea (how to
> achieve the same functionality as with vtunerc driver):
> 
> [...]
> 
> > The driver, as proposed, is not really a driver, as it doesn't support any
> > hardware. The kernel driver would be used to just copy data from one
> > userspace
> 
> Please stop learning me what can be called driver and what nope.
> Your definition is nonsense and I don't want to follow you on it.

You can stick your fingers in your ears and shout all you like but given
Mauro is the maintainer I'd suggest you work with him rather than making
it painful. One of the failures we routinely exclude code from the kernel
for is best described as "user interface of contributor"

It's a loopback that adds a performance hit. The right way to do this is
in userspace with the userspace infrastructure. At that point you can
handle all the corner cases properly, integrate things like service
discovery into your model and so on - stuff you'll never get to work that
well with kernel loopback hackery.

> Can you show me, how then can be reused most important part
> of dvb-core subsystem like tuning and demuxing? Or do you want me
> to invent wheels and to recode everything in the library? Of course

You could certainly build a library from the same code. That might well
be a good thing for all kinds of 'soft' DV applications. At that point
the discussion to have is the best way to make that code sharable between
a userspace library and the kernel and buildable for both.

> I can be wrong, I'm no big kernel hacker. So please show me the
> way for it. BTW, even if you can find the way, then data copying
> from userspace to the kernel and back is also necessery. I really
> don't see any advantage of you solution.

In a properly built media subsystem you shouldn't need any copies beyond
those that naturally occur as part of a processing pass and are therefore
free.

Alan
