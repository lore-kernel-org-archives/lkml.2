Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2EHAO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 20:14:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55252 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757495Ab2EHAOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 20:14:25 -0400
Message-ID: <1336436053.8274.333.camel@deadeye>
Subject: Re: [ 67/75] ipw2200: Fix race condition in the command completion
 acknowledge
From: Ben Hutchings <ben@decadent.org.uk>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@linuxfoundation.org>
Date: Tue, 08 May 2012 01:14:13 +0100
In-Reply-To: <CA++WF2OhfV4Fv8Jo+o_VMyZ9mdQLMs3iOtiP0_jskUR_8gc9jg@mail.gmail.com>
References: <20120504204230.094388730@linuxfoundation.org>
	 <1336401445.8274.319.camel@deadeye>
	 <CA++WF2OhfV4Fv8Jo+o_VMyZ9mdQLMs3iOtiP0_jskUR_8gc9jg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cML1BABRxWAenwlYlxzV"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cML1BABRxWAenwlYlxzV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-07 at 16:45 -0700, Stanislav Yakovlev wrote:
> On 7 May 2012 07:37, Ben Hutchings <ben@decadent.org.uk> wrote:
> > On Fri, 2012-05-04 at 13:43 -0700, Greg KH wrote:
> >> 3.3-stable review patch.  If anyone has any objections, please let me =
know.
> >>
> >> ------------------
> >>
> >> From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> >>
> >> commit dd447319895d0c0af423e483d9b63f84f3f8869a upstream.
> >>
> >> Driver incorrectly validates command completion: instead of waiting
> >> for a command to be acknowledged it continues execution.  Most of the
> >> time driver gets acknowledge of the command completion in a tasklet
> >> before it executes the next one. But sometimes it sends the next
> >> command before it gets acknowledge for the previous one. In such a
> >> case one of the following error messages appear in the log:
> > [...]
> >> +     now =3D jiffies;
> >> +     end =3D now + HOST_COMPLETE_TIMEOUT;
> >> +again:
> >>       rc =3D wait_event_interruptible_timeout(priv->wait_command_queue=
,
> >>                                             !(priv->
> >>                                               status & STATUS_HCMD_ACT=
IVE),
> >> -                                           HOST_COMPLETE_TIMEOUT);
> >> +                                           end - now);
> >> +     if (rc < 0) {
> >> +             now =3D jiffies;
> >> +             if (time_before(now, end))
> >> +                     goto again;
> >> +             rc =3D 0;
> >> +     }
> > [...]
> >
> > If you don't want the wait to be interrupted, use wait_event_timeout()
> > instead of this ridiculous loop!
>=20
> Usually "modprobe ipw2200" takes less than a second, and after
> switching to wait_event_timeout it will take more than 10 seconds. We
> can not decrease the waiting timeout because we want to keep it big
> enough for the worst case(when the firmware did not reply).
>=20
> There is a relevant discussion on lklm:
> https://lkml.org/lkml/2008/9/25/2
> https://lkml.org/lkml/2008/9/26/194

That's irrelevant: you aren't letting userland handle the signal here,
so you should use wait_event_timeout() and no loop.

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-cML1BABRxWAenwlYlxzV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6hlVee/yOyVhhEJAQoQoA//d1oysADjdcAaZFvKCvR7bdA2xQTV23pb
EdP7EpiTZcXlAPoUxAUTgQk40iqAcfj34T8vnZ0sy1fpx2clm8ZmtF3ntraxjoy/
PzbAWpCUY0ZdrWInpaxtI70R5ty68b27jBXQWFjmok4wLbIXNBWaWDavr3n83JBV
vLqxEQH7jEQoWF6ew3HZUhoz4Aj9nVxK1adDO2j7w+ZIX9GYujapTvOuix6pwksu
9ZZKyFwyo2hG4G4j+V6znl0HQ3QYeb5Mnsb5Yg/8KBueOdLsf/33JnuQs12lU16r
+aoJtaJNR6D7H5Ob/U+eyToMn8EXcG35d23b5QZ2nkUNdu94GBW5MPRo2xJNKEKE
hHPP5cPP9ptIF2/ligYz7pX5T47ylBeBqoOZAiUURv1x7JX30+iFGVxKOOwTV987
azOSHAhzh4Loo0lJ61KXucMSRy7/Qk9khfTBK2LHnsgqpmGDoNeWm1GcGOKcPVum
Olx1GVgfuQ+ndyelPdgiJ+pMu17n/oe2cuFg+ZntjvdQNFo4ePppl3UQyasgTWOF
frq5apC/rj5dZUgoD/9bHBob+kQjcZWhGLWn8KuwNevKGq9aCNwyGtM00V2uc19J
Krm79xv98zTJ2pyDXxz8dUgJkJjpPW2OanIOcB/kiTZ1JPj80I5YdRniPiW8gEqJ
0/O/+IGFLOc=
=Zjjz
-----END PGP SIGNATURE-----

--=-cML1BABRxWAenwlYlxzV--
