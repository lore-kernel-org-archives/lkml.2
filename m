Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab2EAA2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:28:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab2EAA2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:28:02 -0400
Date: Tue, 1 May 2012 10:27:58 +1000
From: NeilBrown <neilb@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        linux-pm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Question:  How to power-manage UART-attached devices.
Message-ID: <20120501102758.03aa9cb2@notabene.brown>
In-Reply-To: <4F9F2538.4080407@zytor.com>
References: <20120501082209.0b560708@notabene.brown>
	<4F9F178F.3030408@zytor.com>
	<20120501094752.2ea16f23@notabene.brown>
	<4F9F2538.4080407@zytor.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3v+ngJgKTGN3DjeU/V=7_Y2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3v+ngJgKTGN3DjeU/V=7_Y2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Apr 2012 16:50:16 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 04/30/2012 04:47 PM, NeilBrown wrote:
> >=20
> > I imagine this proposal as being like a virtual DTR line.  It may
> > not always be appropriate to connect DTR to the power switch, but
> > sometimes it is.
> >=20
>=20
> Yeah, that's pretty much what I'm suggesting.
>=20
> 	-hpa

Yes, so you are :-)

I was distracted by the TIOCPOWER suggestion, and I really didn't want any
new action by user-space, I would much prefer it all "just works".
But you also mentioned "termios flags" but by that I suspect you are
referring to HUPCL which is documented as:

       HUPCL  Lower modem control lines after last process closes  the  dev=
ice
              (hang up).

without really saying which modem control lines.  Looking at the code it
seems to be talking about DTR and RTS.  It only says "lower on last close"
but doesn't say "raise on first open" but maybe that is assumed.
So as long as HUPCL is the default, defining a virtual DTR line might be ju=
st
what I want, and HUPCL could be disabled of someone want to keep the device
powered on while it is closed.

So I think I want to:
 1/ teach omap-serial to drive a given GPIO as a DTR line
 2/ write a 'gpio-regulator' driver which provides a single GPIO and
    turns a given regulator 'on' or 'off' depending on the state of the GPIO
 3/ write a special-purpose GPIO driver which provides a single GPIO
    and toggles another GPIO whenever the state of the first changes, and a=
lso
    monitors the serial RX pin when the device should be 'off', and toggles
    again if it sees RX activity.
 4/ Keeping using rfkill to power the GPS antenna.

Sounds like a plan.

Thanks,
NeilBrown

--Sig_/3v+ngJgKTGN3DjeU/V=7_Y2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT58uDjnsnt1WYoG5AQIY3g/9E6xuWnL+7EjFmNLVRnP9gauOACrOBzLF
xfdAvV2V0m+/ZxbkA4VsS2bmPCfyTA1113cLyNMTNBYXv01bBs7Xw8jnLpkt4XL7
BEGqXkrWqGAv99p7usqur8DiNO2/9SiMUcpZd6cTU2UEq0g68hvk0zbpfiW2LaTk
ltwY9xZ+nMgNs7G5n/rH0uBgIO/hfqT3ygmNRG1FEfmxp1TwDEjTw6x52tcSDvwx
Zb0PkG9JW8GKFSPFQFKQ2bXDxmUAPRpFvCALvPmfszv8pftGTBzNS4a87DEBxy+M
j+WE5Y8Mwf3TlaRNUfFfuW0W5swoUAZ1IIuaIEHKNS2v7DKr3gGM8vURVXwyIk7S
9YiPVuqFuk0iXTes/mXuBD3dvM+AJNX1qlc46caVsHypRQIfLVcP5ZMBBTOssdfo
sdbB1WMfHGEGdcWrJTyl0QS6UAWImq67aQEJZ/FfT2xh59snhDAemwoSJDYm36cn
eV3idZtJMOHcsL8YNx5F5JPsjagkYk/y16z1+g/ARa6HBH6fNwmr2Vgekt7Usk6x
ZsFpw8Eih3TMOfkFCw1ADBdUQI/0hJ/nLBpZ1I0csw107Fl7G9GabRP4K+MnVYPN
/abFtNI0SFM8z71EMJC0zPLhKXb+4I6h5CGTrrx8aOsieliTP0PgrbKg9PwSI4c0
n4f7dQ/Esjc=
=GUkV
-----END PGP SIGNATURE-----

--Sig_/3v+ngJgKTGN3DjeU/V=7_Y2--
