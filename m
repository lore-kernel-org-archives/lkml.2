Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab1I3RkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:40:09 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:33235 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475Ab1I3RkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:40:07 -0400
Date: Fri, 30 Sep 2011 20:40:02 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@suse.de>
Cc: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] drivers_base: platform: use always ->name for
 uevent
Message-ID: <20110930174000.GB4163@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de>
 <1313419901-13492-2-git-send-email-bigeasy@linutronix.de>
 <20110930132914.GA877@legolas.emea.dhcp.ti.com>
 <20110930170914.GA15341@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <20110930170914.GA15341@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 30, 2011 at 10:09:14AM -0700, Greg KH wrote:
> On Fri, Sep 30, 2011 at 04:29:16PM +0300, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Aug 15, 2011 at 04:51:22PM +0200, Sebastian Andrzej Siewior wro=
te:
> > > If id_entry is available then it is used. However if we remove first =
the
> > > driver followed by the device, then the id_entry is pointing to drive=
r's
> > > memory which is long gone.
> > > Since id->name and plat->name are equal there is no point in
> > > distinguishing them.
> > >=20
> > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > > Cc: Grant Likely <grant.likely@secretlab.ca>
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > > ---
> > >  drivers/base/platform.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > >=20
> > > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > > index 0cad9c7..cd71575 100644
> > > --- a/drivers/base/platform.c
> > > +++ b/drivers/base/platform.c
> > > @@ -614,7 +614,7 @@ static int platform_uevent(struct device *dev, st=
ruct kobj_uevent_env *env)
> > >  		return rc;
> > > =20
> > >  	add_uevent_var(env, "MODALIAS=3D%s%s", PLATFORM_MODULE_PREFIX,
> > > -		(pdev->id_entry) ? pdev->id_entry->name : pdev->name);
> > > +			pdev->name);
> > >  	return 0;
> > >  }
> > > =20
> >=20
> > Just a gentle reminder on this patch. Greg, has this one been queued to
> > your drivers-core tree ? Should it go on -rc or now it's already too
> > late and going on merge window ?
>=20
> It's been in my drivers-core tree for a while, and I didn't think it was
> needed for 3.1, as it didn't solve an existing bug, did it?
>=20
> It's queued for 3.2, does it need to get into 3.1-stable?  If so, I can
> do that.

I don't think it's needed. Just make sure drivers-core is merged before
your USB tree :-)

thanks

--=20
balbi

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhf7wAAoJEAv8Txj19kN1rMoH+wQg5U/JRR0FtnlXAKW2L4nH
YZGrlszu0lRHDAfRte7x19tYvoCsfJYIB6nO71UBZz6A88feQUq/f2y/YEJdg/9U
dyHUrGaa1m0MuxfxpGxQVKFdXRZtImVQHUCBSZag2rWMcALTHZd4dVfKf8CrM/Hg
Pt7DhYJcFi7ZkKsuQiIfovmHKiC4jlZX7KOFWISh+mnTLwrblBTznpYwuwhrSDrd
nZxWZFXvO45ZkjLxhIam9tIPSSSEAEcqDrLswDA9g5NPQRz2ubds9IXakgujhsFl
u/ZrviF2JKsGnU6fe9Gqgqc15vh3uUPHsbxt2kLO57iyvvzyYwxQOp8ZVHBp7Qw=
=v1aK
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
