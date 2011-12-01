Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab1LAFWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 00:22:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1LAFWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 00:22:12 -0500
Date: Thu, 1 Dec 2011 16:21:44 +1100
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Lockwood <lockwood@android.com>,
        Arve =?ISO-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111201162144.187ecca3@notabene.brown>
In-Reply-To: <20111130232529.GB3220@core.coreip.homeip.net>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<201111281753.45287.arnd@arndb.de>
	<CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
	<20111130135847.68a6e4c6@notabene.brown>
	<CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com>
	<20111201095633.700e2923@notabene.brown>
	<20111130231740.GA25340@opensource.wolfsonmicro.com>
	<20111130232529.GB3220@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z7zdxw8lB3Ne0j/+gQjX0oX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/z7zdxw8lB3Ne0j/+gQjX0oX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Nov 2011 15:25:29 -0800 Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> On Wed, Nov 30, 2011 at 11:17:41PM +0000, Mark Brown wrote:
> > On Thu, Dec 01, 2011 at 09:56:33AM +1100, NeilBrown wrote:
> > > On Wed, 30 Nov 2011 15:40:48 +0900 MyungJoo Ham <myungjoo.ham@gmail.c=
om>
> > > wrote:
> >=20
> > > > I'm focusing on an external connector or port that each physical po=
rt
> > > > may inhabit multiple cables at a time although it should support a
> > > > port that may inhabit a single cable only at a time. However, the
> > > > class could be used for other general "multistate mux" that connects
> > > > different device drivers.
> >=20
> > >  maybe I'm just slow, but I'm having a lot of trouble imagining a sin=
gle port
> > >  that could have multiple cables plugged in at the same time.  And th=
is
> > >  blockage is stopping me from reflecting usefully on your other point=
s.
> >=20
> > >  Are you able to show me a picture or a diagram or something so I can
> > >  visualise what you are talking about?
> > >  To me: once you plug one cable into a port, it is full and there is =
no room
> > >  for any more cables.
> >=20
> > One obvious example is the sort of big multi-way docking connector that
> > many mobile devices have (iPod and friends being one of the most
> > common).  These are essentially the same as docking station connections
> > on a laptop in terms of what they bring out - a variety of audio, video
> > and communication connections - which may go to a docking station or
> > some kind of breakout or adaptor cable and may have sub-ports hanging
> > off them (eg, it's common for tablets to have docking stations with HDMI
> > and audio sockets on them).
> >=20
> > There are also lower pin count equivalents like the multiplexed "USB"
> > sockets on some phones which can also carry other functions with
> > adaptors, and even something like a headset is really a microphone and
> > headphones on a single jack.
>=20
> Physical jack does not have to map 1:1 on logical jack. So 1 physical
> docking connector can be represented by 1 logical video connector, line
> in, line out, microphone and maybe else.
>=20

That is just what I was thinking :-)


It seems that a "connector" could be modelled as a set of binary switches,
one for each service that is exported (or imported? ... "communicated" mayb=
e)
through the connector.  When a cable (or dock) is plugged in, some number of
these switches are all switched on concurrently.  When it is unplugged they
are all switched off.

How strongly do we need this understanding of a "group" to be?

Mark says:

> We also need some way to group things together so that we can understand
> that we've got a single connector that can detect multiple things (eg,
> understanding that a cable hsa audio and video capability).

It isn't immediately obvious why this is the case.  There is no guarantee
that I want to route audio and video in the same direction.  The best you c=
an
probably get is a heuristic that both should be routed to the most recently
available destination.
But again, maybe I'm missing something important.   I guess the helpful pie=
ce
of information is: How exactly would this knowledge of grouping be used?


As for naming of these switches, I think small numbers are nice as they are
consistent with similar abstractions inside Linux.  Pointers might be equal=
ly
suitable though.

The core idea is that a 'switch' is used to connect the driver which detects
the change to the driver (or drivers) which uses the change.
Some common parent of both drivers allocates the switch and passes it to bo=
th
devices, possibly through platform data.

In some cases the common parent might be the 'board' file.
One case I am thinking of is the twl4030 driver (a multi-function device for
power, usb, audio, battery charge etc).
The battery charger needs to know when the usb device gets a cable plugged =
in
so that it can start charging.
It currently creates a link essentially by using a global variable.

Using a 'switch', the twl-core module could allocate a switch and pass it to
the usb module for sending notification and to the bci module for receiving
them.  Whether it passes down a number which is later turned into a pointer,
or whether it sends down the raw pointer, is just an implementation detail.

Can the same be done for these cable ports that you have in mind?  Presumab=
ly
the common-parent could allocate several switches - maybe even an array of
switches - and pass the collection of switches to the port, and then pass
individual switches to individual component drivers.

If the switch needs to be exported to user-space then someone needs to
provide a name for it.  I suspect the common-parent would be the obvious
choice, or the board file.

Possible a standard naming scheme like the one that LEDs suggests would make
sense.  e.g. platform.port.cable

   MAX8997.MUIC-0.USB-Host
   MAX8997.MUIC-1.MHL

or whatever.
So naming scheme would need to be established for apps to negotiation
effectively with the kernel, but I don't think a naming scheme is needed
inside the kernel.


Just to be clear, the functionality that I see a 'switch' supporting is:


For the owner:
  - int switch_allocate(void)
  - void switch_export(int switchnum, char *name)
     This creates a device which appears in sysfs and has a 'state'
     attribute which responds to 'poll' requests so a process can find
     out about changes.

For the notifier:
  - void switch_set_state(int switchnum, bool value)
          This sets the state and notifies all notifiees (listeners).

For the notifiee (listener)
  - void swtch_add_listener(int switchnum, struct notifier_block *nblock)
  - bool switch_get_state(int switchnum)

If we needed clear grouping then maybe:

   int switch_allocate(int numswitches, int *switch_list)

to allocate a group, which gets a unique identifier and

   int switch_get_group(int switchnum)

to get that unique identifier ... assuming that was a useful thing - probab=
ly
not.



NeilBrown


--Sig_/z7zdxw8lB3Ne0j/+gQjX0oX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtcO8jnsnt1WYoG5AQLyvQ//YrC27g/YJlpuPA/aKLNeCp/ZqMT+4wHu
u/XSjJS+nNJAikfg3isFveNcNVkoU8GOWM1nPSTs838DVgU+wJetcD85CpzvKWR0
mPmTJ302b/zhCn9g5WMpFKz2+4U+wqTTZzGpbHY9pnwKF7uZzXqhsUD7bu87SzHc
K2/3WyQFRLv7P/tZrGHzKh67ZgfXavaYC9H2c6nt15mYr2mL2zCSg4GcJ0HROPoc
hbaIgVCdqspQdBvjbKT2SRlUEDM9LElCRLXDDeB1vBqUVYyNj1JjG+HZB0yX5a6C
bJ4+wYuOxlKwBXd1lCSQnAPtg3mQr/pfZBpqAU0MD8R8mFBpEpQQGvT0D/StJjy/
Cr/713tztZha6JnTr01DDHFZ98vxLaKGpO6oqhEdehiCVYZxwSAoHRhsL7r/T8v6
EvxwhZa5CAN9wKxuIGwpD23amOBT9AEc/lzfYdyyrO6my7oP4NlPNCmX66V4Uk10
fjn5aJZxQeGSe/TEbU85cOXzcXiNvtdPqZ2O2cbGTE1ioOB7dMqBqfYNETrK2d4B
/SUTj1Gv003IAOnUWcrEdeCimovHDygFCFMIF2XKW7y4G31R1tjlBFxE2gYroJUz
k0TUVusEi9wKxj7rawrryNYwsnOoHmBD2f6F/M7+tO+bUnUyqlcOTMxJlGI1gg6p
KwkzrEPOWp4=
=LTQ7
-----END PGP SIGNATURE-----

--Sig_/z7zdxw8lB3Ne0j/+gQjX0oX--
