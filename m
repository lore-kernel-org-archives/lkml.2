Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1JPVhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 17:37:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab1JPVha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 17:37:30 -0400
Date: Mon, 17 Oct 2011 08:37:17 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: markgross@thegnar.org, <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <arve@android.com>,
        <amit.kucheria@linaro.org>, <farrowg@sg.ibm.com>,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        <linux-pm@lists.linux-foundation.org>, <khilman@ti.com>,
        Magnus Damm <damm@opensource.se>, <mjg@redhat.com>,
        <peterz@infradead.org>
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111017083717.0bd5626c@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110152136460.19724-100000@netrider.rowland.org>
References: <20111016092556.07d6e415@notabene.brown>
	<Pine.LNX.4.44L0.1110152136460.19724-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oBS81yzUtISLIIZVZC0D4nC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/oBS81yzUtISLIIZVZC0D4nC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 15 Oct 2011 21:49:44 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:


> All right, let's make things a little more complicated.

Let's call it "realistic".   It is good to have some realism to make sure o=
ur
abstract discussions actually mean something.

>=20
> Here's what actually happens when a USB keyboard generates a wakeup=20
> request.  The system wakes up, of course, but there's no particular=20
> indication of the cause.  In particular, the usbhid driver has no way=20
> to know directly that the keyboard was the reason for the wakeup.
>=20
> In addition, usbhid can't poll keyboards to see if they have an event
> to report.  (In theory it could -- the HID protocol allows for this --
> but many keyboards don't support that part of the protocol properly.) =20
> It has to wait until the keyboard gets around to reporting the event,=20
> which can take 10 ms or more.
>=20
> Taken together, this means usbhid must activate a wakeup_source every
> time it wakes up.  If a keyboard event report is received reasonably
> quickly then good, it can deactivate the wakeup_source at the right
> time.  But if not, all the driver can do is time out the wakeup_source
> after some delay.  I don't see any way to avoid it.

I have to agree with you there.
This is similar to Rafael's example of a Wake-on-LAN packet arriving.  At
that point there is nothing you can do except wait a little while expecting
more information.

You could see this as a case where the wake-up event isn't even visible to
the kernel, so there is obviously no way to make it visible to user-space.

Or you could see it as a wake-up event that is expected to be delivered over
a long period of time (many msecs).  The kernel gathers the wake-up event,
makes it visible to user-space (once it actually arrives), and then releases
the wakeup_source.

So it is a good example and highlights the difficulty of defining exactly
what a wake-up event it, and of what it means to be "visible".

I think it still fits in your rephrasing of my question which - if I rephra=
se
it as a requirement - is roughly,

  A wakeup-event that needs to be handled by user-space must be visible to
  user-space before the driver deactivates the wakeup_source.

A requirement which, in this case, means the driver needs to hold  the
wakeup_source for an extended time using a timeout, just as you say.

Thanks,
NeilBrown

--Sig_/oBS81yzUtISLIIZVZC0D4nC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTptOjTnsnt1WYoG5AQKbBA/9HGKlSUa8aE+GaB+sD4/I7eKvmrANwi51
k72VwJkHH8pzal9qfi2/8Cs3El7TNAG2PFWtGzyudDZIoLSHH1URS/duQaKqX6X5
SRgFNjBnAQzNknna4AItrR3lJP/CYmd+4XeVwLutk1BapNK0T0NUICz/3cAJ7+Cz
8mqgmhCBNAnkkVhKlSUXS+PHT4XNFJg0K4aTOx1QRzNABnQkiXcgEC2K4vZDbTIV
BpwqZP9lNnCafLLlbJ4JoMSOrKvnJxoYAj3/cLEnTemR0r3qdgyZ1UgGL98kfMM+
kYwN1QA9vEPFPdu+sr0acMCpRLP2+/+oC3ky58GlogsARqNKEMrumAYdeyC4xWSA
pFZQGrpoWUzdnM7XEr6Zp2TmJ7TzOP1dKkBQ7Bq0lkm6TH6r+GN9VgCN4HB4IjLS
wD/Cpig+XXj6jaM0mhlg8YiqCQF89Z0j09VINFquISxZAkfP+dBHnDrdj7DiHovU
304+0IuKUQjbib+zSyvT7M5zQF5hvTzDSiJ8LA0gSpg+n9wWUkQBDNNevR7s+h0r
H10+1/ba5V/WJvXk9fhMMtjRPMB9m/g9eI5eUY7cMyrRkUKotqxYiTkSwDF9eN2/
x8phOHilz4kIFPwQFLd9qfopEoROk9scMq8bspTj9r1BRm9rg6+DX/9adT4eUQ9O
doeMJEOPz40=
=S7E5
-----END PGP SIGNATURE-----

--Sig_/oBS81yzUtISLIIZVZC0D4nC--
