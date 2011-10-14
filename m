Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab1JNVrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:47:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab1JNVrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:47:47 -0400
Date: Sat, 15 Oct 2011 08:47:32 +1100
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
Message-ID: <20111015084732.5fe55467@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110131111200.2026-100000@iolanthe.rowland.org>
References: <20111013163526.3863be01@notabene.brown>
	<Pine.LNX.4.44L0.1110131111200.2026-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IEIBn21qZz3y6Slr_r+syJq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IEIBn21qZz3y6Slr_r+syJq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Oct 2011 11:16:23 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Thu, 13 Oct 2011, NeilBrown wrote:
>=20
> > Nope, but I'm keen for you to convince me.  Identify a wakeup event that
> > cannot be made visible to poll (or to user-space by some other
> > mechanism) before the wakeup_source needs to be deactivated.  Or if I've
> > misunderstood what sort of notification is problematic, help me underst=
and.
>=20
> Here's an example (just for kicks, not completely relevant to your
> discussion): A USB keyboard key release.  Unlike key presses, key
> releases need not generate input events.  If no processes are
> monitoring the raw keyboard event queue then the release is not visible
> to userspace at all, hence not visible before the wakeup_source needs
> to be deactivated.
>=20
> Alan Stern

As you say, not completely relevant.

If a tree falls in a forest with no one to here, does it make a sound?

similarly if an event happens that no-one is looking for, is it visible?
It doesn't really matter.

So at most this is a case of "is not made visible" rather than "cannot be
made visible".

The key-release just needs to clear the "key is pressed" state so that
auto-repeat stops and if it was a modifier, the modification is discarded.
That is all trivially done in some kernel driver while the wakeup_source is
active.

Thanks,
NeilBrown

--Sig_/IEIBn21qZz3y6Slr_r+syJq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpit9Dnsnt1WYoG5AQKAzg//fU59Ufo0RkVgcfM67ppVLxvXWQCJ/P5i
Gz3S578C9hoYjyezC4UMU+6YP9O53K49wURLpf2znAcFuxa2t9TmXwjSy5DeMlCf
QW+6p6Pn2he59ZkSMgUofVgcEiRqK+MzTYr1/0DvOSjGEaUB8i4w7k7qdsD/ZowF
cS72W826AqSNA2d5BMlocRXvQH5Sq5HlSLD/K+bwKIqMI+YcAblvBkhZd/NmMcvs
LRmHldJA/1KJFVy49OzpPFJYlTwt1G5zyDJYtDxR5Tx6d2Pvd6hkwMtH5PtTHxY+
4hAwfVymIC2qa7+i2gpxTuY4huftbbwJqNK2U9fwS5nipxPKsCSzZeA6psXnbfei
6mjJ0vzOrcGpjgYhRZraesofwx7QoGNryt0XN1pHNFt6DLMmGIOx9iLDabKGV9fR
oQbxJXk8Ll6CyEdsurUbyhraI0mXXz4fifU4El8jUz92rc7SpLuaSAQzYNISKWqi
ucGyDLZXSPqb3YWm+8i1jUtn4oEq1tb4dp45813TLkUPyqaxAwuyDrbiBEGS4QxE
RIjCZt3DAndUOMigSJNYgieLpq1SGJuRjHpPV7ZwHVEaD6f55taAddWSOBku9Smi
+vrZWsnShA9qDzs+qZr/KmnQtoCP0TozyUA0aRAvk0Uv1fbIwMfjBN+spO8WPR28
MBGAgmsN7ds=
=uIW8
-----END PGP SIGNATURE-----

--Sig_/IEIBn21qZz3y6Slr_r+syJq--
