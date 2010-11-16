Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab0KPW5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:57:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52798 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755444Ab0KPW5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:57:31 -0500
Date: Tue, 16 Nov 2010 22:56:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
In-Reply-To: <20101116213622.GA17824@tango.0pointer.de>
References: <1289922400.1253.3.camel@yio.site>
	<20101116155717.6671e484@lxorguk.ukuu.org.uk>
	<AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
	<20101116171447.29336514@lxorguk.ukuu.org.uk>
	<AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
	<20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
	<20101116213622.GA17824@tango.0pointer.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > So we fix the ioctl interface, it's not exactly hard to do now is it.
> 
> Sorry, the WAITEVENT stuff interface you created is unusably broken:
> 
>   a) it's a sleeping ioctl which makes it unusable in anything but the
>   most trivial applications, because most programs need to respond to
>   more than once wakeup event. Of course, you can then introduce threads
>   but that's horrible.
> 
>   b) It loses events, because events that happen after you woke up and
>   before you go back into WAITEVENT are completely lost. And those
>   events might actually be relevant, since they might be the most recent events
>   that happened. And those tend to be ones that matter.

So those are both trivial enough to fix as far as I can see but by the
sound of it neither actually solve what you want to do.

> Kay's interface also drops events, but only historic events that happened
> but aren't current anymore. And that's a good thing, because when you
> track which VT is in the foreground for presentation, or for permission
> management purposes then you care little of who else should have had
> access in the past but didn't get it. You are only interested in the most
> recent update, which is what Kay's interface gives you.

No Kay's interface gives you some random reasonably recent answer that
could well be wrong.
 
> Kay's interface is not intended to be useful for logging purposes. It is
> useful to track VT changes for service activation, for permission
> management.

You wish to do permission management based upon stale unlocked data,
yeah that sounds about the standard of some of the current shipping
desktops.

> Well, the suff it provides is purely informational. You cannot actually
> influence the TTY in anyway, you can just watch which VT is currently
> active.

Try that with "keystrokes" for example. its a bogus argument.

> I am sorry, but WAITEVENT doesn't work for *any* case. It is completely
> broken. Have you actually ever tried to use it yourself? Do it. Write me
> a race-free program with it that tracks VT switches and i'd be amazed!

You have to hold the vt switch locks, but that is unavoidable.

> events. And voila, you'll have created Kay's interface.

Which also doesn't work reliably and you want to use it for permissions
management !

Describe this permission management you are doing please.

Alan
