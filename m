Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab1LEIIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:08:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab1LEIIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:08:49 -0500
Date: Mon, 5 Dec 2011 19:08:27 +1100
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
Message-ID: <20111205190827.68b179f4@notabene.brown>
In-Reply-To: <35AB98346D25394A9354ED89C4D76587228F32@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
	<201111142327.37524.rjw@sisk.pl>
	<20111115005951.GB26360@kroah.com>
	<201111160016.09174.rjw@sisk.pl>
	<20111205085632.5976fe96@notabene.brown>
	<CACVXFVNkapRDJ8QkgmJCh+n1c2+7cHBiLf1ef22Nfdd8YrPpGg@mail.gmail.com>
	<20111205155338.1bd658b9@notabene.brown>
	<35AB98346D25394A9354ED89C4D76587228F32@039-SN1MPN1-002.039d.mgd.msft.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/toPXK9FzAclaK6CkpF5LrVq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/toPXK9FzAclaK6CkpF5LrVq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 05:53:27 +0000 Chen Peter-B29397 <B29397@freescale.com>
wrote:

>=20
> =20
> > > > So it is asleep when the new pm_runtime_disable() call is made, so =
it
> > stays
> > > > asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happen a=
nd
> > the
> > > > system doesn't get powered off.
> > > >
> > > > So here is a device that should *not* have pm disabled at shutdown.
> > > >
> > > > So I feel this fix is a little too heavy-handed.
> > >
> > > Maybe the device's runtime PM should not be disabled if
> > > there is no ->shutdown defined in its driver, how about the blew?
> >=20
> > Thanks, but that won't actually help.
> >=20
> > dev->bus->shutdown is i2c_device_shutdown so there is a shutdown method.
> > However i2c_device_shutdown just finds the driver can calls
> > driver->shutdown(), and that is the 'shutdown' that is NULL.
> >=20
> Then, i2c should be registered before than twl4030 as a platform device, =
since
> twl4030 is an i2c device. Just let i2c shut down later than twl4030's.=20

It almost certainly is, but that is totally irrelevant.

The problem has nothing to do with ordering and nothing much to do with
->shutdown() being called.

The problem is simply that pm_runtime_disable() is being called on all
devices, and that stops devices that are asleep from waking up.

I think the intention of putting that call in was to stop devices that are
awake from going to sleep, and maybe that is justified.  But stopping devic=
es
that are asleep from waking up isn't.

NeilBrown


>=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> >=20


--Sig_/toPXK9FzAclaK6CkpF5LrVq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtx8ADnsnt1WYoG5AQIAxw//ZU1X1om6HaF6zy/D2mwrCbdH2ozECKh/
XC8ytgaxWqMrxFMjbhyVOuQkwosq28ySN7BXlHnMXXvrQ/iEm9MQ8gVIjrjUdOt7
S2nxKEglafobBNR7sXCi7JPyCu5D48Uq4lInvLzZ8U3N0W94ByK66GqGpGf5GwAY
RBo7S/U3vz79r6QsGDC9h+7H/nmk8gHm9wsmxpavVfReSsYZYxoF+Be74wY6cOub
RnYsaSt1O6KGjK4BxH9oKd4sHXXajsTO64zmgOIPNs3yqY3HvEHhi/G30BjKdc+5
VS7LZuGjIRsYmJRNZvSSQs2MV5NdSyDL482A6jecstVUi91RRP9rNkygj2xO+b2R
nRsHTMvW/BEacHOqWD2vr/RMG8pT4KxDmCd5poW6Wb3IQ5lA4xAASFx8e5D6vGV+
HjVtaSaBQQtZF3TxZtclAtC5ZpEloBWOqPmx7vx9NqFZjD4RC+paau4Ugp2e3FgM
59Ue/4yEEBSBrV0yvK8hhr/w0tNosSlLUyicuVlqo1kQSsrjS5g3nQJBN+QrhyoG
fL/jM8kIXEc0Luh8xJQvnPTK6/5NedD0vtqzflv3C7H3ct+WbGXRiEvIlElgrnwD
gECscqjD0FEi4lywQdcjWMW7Uesx+/7yn689CLbenC30ydjEC4y3H4b3brG6oPa4
kZ9/Th2QCHU=
=WAIQ
-----END PGP SIGNATURE-----

--Sig_/toPXK9FzAclaK6CkpF5LrVq--
