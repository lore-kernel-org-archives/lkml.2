Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1LEIxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:53:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab1LEIxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:53:10 -0500
Date: Mon, 5 Dec 2011 19:52:54 +1100
From: NeilBrown <neilb@suse.de>
To: Chen Peter-B29397 <B29397@freescale.com>
Cc: Ming Lei <tom.leiming@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg KH <greg@kroah.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Message-ID: <20111205195254.2d2f21a1@notabene.brown>
In-Reply-To: <35AB98346D25394A9354ED89C4D7658722905B@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
	<201111142327.37524.rjw@sisk.pl>
	<20111115005951.GB26360@kroah.com>
	<201111160016.09174.rjw@sisk.pl>
	<20111205085632.5976fe96@notabene.brown>
	<CACVXFVNkapRDJ8QkgmJCh+n1c2+7cHBiLf1ef22Nfdd8YrPpGg@mail.gmail.com>
	<20111205155338.1bd658b9@notabene.brown>
	<35AB98346D25394A9354ED89C4D76587228F32@039-SN1MPN1-002.039d.mgd.msft.net>
	<20111205190827.68b179f4@notabene.brown>
	<35AB98346D25394A9354ED89C4D7658722905B@039-SN1MPN1-002.039d.mgd.msft.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dHNQ4OJU0=TW5LsxCMTtn9l"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dHNQ4OJU0=TW5LsxCMTtn9l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 08:32:27 +0000 Chen Peter-B29397 <B29397@freescale.com>
wrote:

> =20
> > > > stays
> > > > > > asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happ=
en
> > and
> > > > the
> > > > > > system doesn't get powered off.
> > > > > >
> > > > > > So here is a device that should *not* have pm disabled at
> > shutdown.
> > > > > >
> > > > > > So I feel this fix is a little too heavy-handed.
> > > > >
> > > > > Maybe the device's runtime PM should not be disabled if
> > > > > there is no ->shutdown defined in its driver, how about the blew?
> > > >
> > > > Thanks, but that won't actually help.
> > > >
> > > > dev->bus->shutdown is i2c_device_shutdown so there is a shutdown
> > method.
> > > > However i2c_device_shutdown just finds the driver can calls
> > > > driver->shutdown(), and that is the 'shutdown' that is NULL.
> > > >
> > > Then, i2c should be registered before than twl4030 as a platform devi=
ce,
> > since
> > > twl4030 is an i2c device. Just let i2c shut down later than twl4030's.
> >=20
> > It almost certainly is, but that is totally irrelevant.
> >=20
> > The problem has nothing to do with ordering and nothing much to do with
> > ->shutdown() being called.
> >=20
> > The problem is simply that pm_runtime_disable() is being called on all
> > devices, and that stops devices that are asleep from waking up.
> >=20
> Please correct me if I am wrong
> 1. This change only affects when the user issues "reboot" or "shutdown"

well "halt -p" or "poweroff", but yes.

> 2. The pm_runtime_disable(dev) is only be called before this "dev" is
> coming to shutdown

Yes, but the important point is that is being called before pm_power_off is
called.

> 3. If i2c bus/driver->shutdown is not called, its runtime pm is still ena=
bled.

I think you mean "disabled" ??

Yes, but I don't see how that is relevant.

> 4. You may issue i2c xfer after i2c bus/driver->shutdown is called. =20

Yes, but again I cannot see the relevance.

NeilBrown


>=20
> > I think the intention of putting that call in was to stop devices that
> > are
> > awake from going to sleep, and maybe that is justified.  But stopping
> > devices
> > that are asleep from waking up isn't.
> >=20
> > NeilBrown
> >=20
> >=20
> > >
> > > > Thanks,
> > > > NeilBrown
> > > >
> > > >
> > > >
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/dHNQ4OJU0=TW5LsxCMTtn9l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtyGZjnsnt1WYoG5AQK1dBAAo4Vxguwr8JcuJmVUffEgh31ucESgUipp
feIdblVZyTyf72YVgUxxUwdtVulEcmNcdxS37r5ygq2fQqAkSYlqS4o4vcIb8kYE
2cFWPcPDIKhHHwEks+O7YDSF1l98ZeVLfLaoHe20Mwj7SS2og9+l+pT/rL0RQQYm
EnZlBCsl8ngcd54b2G5uK8fXOBbLDBo3UAYoS1Rzk9YF78qAC+bAr3ihK3rdzHpR
QDpMzy9OyKEwzwUeI8R4LGeJRm9eeByasfndSrwtb+git+zwKbSSFBeFNGx7iD5o
UwYDN5Ks4zCvh1iIUKa3KbjCdlTZitzjOHBt1UJ2xEVFtzwLyVWMkZr5Oxb3iwu+
ZpGz3zHQ3AjdOmjgUksDDZBzS7ZTS7fwbAZD3N8jmSgIBqREc5gQteggBOtWMRob
Jgin6S7aJrcU2zk6rt8jO09l9bzLHz8ULd51RkyjVBDTG1IvxZtbD5ziiqh42EWd
C3NYaxcL+tVZCJEuSgg1FcCODK15owxiKZPEatoQg1vwdCWHyoLB9AfmW0o8IgjB
WijC9MH6UvEfzkkMCmWjeBxE0Bi8lYTgdTnttYdrW4KF82k8RReto7pBAh2CZpMM
znJ4enT+rYg7EJtzGDg/PES8slbMLX9zWhLz+jHlzL5BRkrGdyhcjNk5XlXUaBsp
+LKI0vPmQfw=
=qxCI
-----END PGP SIGNATURE-----

--Sig_/dHNQ4OJU0=TW5LsxCMTtn9l--
