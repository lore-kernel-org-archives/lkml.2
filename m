Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0KRNCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:02:18 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35238 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757246Ab0KRNCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:02:17 -0500
Date: Thu, 18 Nov 2010 13:01:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Valdis.Kletnieks@vt.edu,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101118130105.51063206@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTikRcw9cahHpWadmHMJ1A2jT9vztwfydzjaGp1zh@mail.gmail.com>
References: <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
	<20101116171447.29336514@lxorguk.ukuu.org.uk>
	<AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
	<20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
	<20101116213622.GA17824@tango.0pointer.de>
	<20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
	<20101116231023.GB27594@tango.0pointer.de>
	<25482.1290031268@localhost>
	<AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
	<20101117235647.00766e32@lxorguk.ukuu.org.uk>
	<20101118012734.GA8558@kroah.com>
	<20101118101519.11729a74@lxorguk.ukuu.org.uk>
	<AANLkTikRcw9cahHpWadmHMJ1A2jT9vztwfydzjaGp1zh@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All this is just no real issue for us. This is not about security in

The kernel isn't "for us", it has to cleanly solve the general purpose
cases for all the usage cases. That varies from home type desktops where
security isn't so important to secure installations where you damned well
better get a console switch right.

> the sense of untrusted users being able to do something they couldn't
> do already, it's about passing the currently active user _some_
> additional rights.

Except we've already shown that is false for the more security concious
case, so we need the kernel ability to handle both.

> And if that user goes inactive there will always be a window where
> this user keeps some rights it had while active. There is always some
> kind of overlap, and even if we had revoke() we probably couldn't it
> for many reasons. Soft hand-over is the expected behavior. But the
> poll() will still show us that *something* has changed, and it's all
> we need to know to switch to the new user.

Of course you could fix it, you make the desktop change in that case
synchronous. Most of what is needed is already there.

Now I don't care whether your particularly desktop bothers to or not,
but I do care that the interface in question is general purpose.

> Synchronous interface means we block the VT switch until we have
> handled the event in userspace? We have several in-kernel VT switches

It means you have the option to do so. Clearly at boot time it would get
a bit silly to do that. So for your use case you'd not ask for
synchronous switching.

> during suspend-resume and such. I really don't think this will want to
> wait for userspace to do random crap in /dev? :)

Of course I'd point out every X based VT switch is currently synchronous.
I don't believe X has any hooks for doing stuff mid switch via helpers
but I'd have to check with X hackers on that.

> We also never want single-use interfaces again. It's a pain when we

There are lots of interfaces where single opener makes total sense so
that's not a good generalisation. I would agree the vt interface is one
where you might want multiple users, but that is easy to do.

> So if we have multiple subscribers, we need for all subscribers to
> finish userspace handling and let all other block in the VT switch
> ioctl()?

Depending where you do the VT synchronous handling.

> That all sounds nice to have for some tasks, sure no doubt, but it
> sounds pretty complicated/fragile for what we need to do. We are fine
> so far with the async behavior.

Fine so don't choose to use it. Oh wait you already are as you use the X
server.

> > solve the problem properly, and if we are careful about the message
> > formats cover the fact the KMS folks and others want multiple "live"
> > virtual consoles at a time.
> 
> As far as I know, the future is VT-like stuff in Wayland-like things
> using a pty, and not legacy kernel-based VTs at all. They even think
> to leave all kernel VT stuff behind, because there are too many
> assumptions about, and they don't fit into the modern world of
> internationalization key/font-handling anyway.

No - the problem you have is that the kernel VT layer is two things

1.	It's a VT100 emulator
2.	It's a display surface and set of input bindings.

Plug two keyboards into a PC and right now we fail to support two
keyboard/two mouse/two screens even though all the hardware can do it. In
that situation the VT interface is in many ways a legacy element but it
ought to work, and the blanking and screen switching create a nasty mess
if you try and hack around it and the notion it keeps of the display
surfaces.

> I also see problems with a lot of compat stuff that is based on
> fg_console, and ...

That's relatively easy to transition we add a

struct all_the_crap_i_need_to_round_up {}

and reference off it, then allow multiple instances. Been there done that
several times.

> > If you have a /dev/vtmanager or similar and opening it allocates a kfifo
> > of a page into which we stuff the events we currently post for waitevent
> > then the code is trivial and it does what Kay needs as well as being able
> > to cover the rest of the WAITEVENT interface and future multi-desktop
> > stuff.
> >
> > So its trivial to do the job properly, which makes the existing patches
> > all the wrong thing to do.
> 
> I'm not against this, it might be what others are looking for. We
> could also use that, even when it's 100 times more complicated than
> the simple poll()able text interface.

I don't think it is looking at the code. If I thought otherwise I'd be
less jumping up and down about it. We already have an abstraction which
is an event (ie message) in the code and thanks to kfifo the rest is
noddy too, kfifo even does all the locking needed.

> As long as we can have multiple subscribers doing the same thing, and
> have a way not to block VT switches, but receive all this
> asynchronously.
> 
> I just expect a ton of problems if we now start making VT switches
> block, which they never did before.

An API that forces you to block VT switches when you don't want it is as
broken as an API which only supports async.

I don't for one minute intend to propose an API that forces synchronous
on you, or in fact to propose anyone implements multi-way synchronous vt
switch management first time around the implementation.

Alan
