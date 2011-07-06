Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1GFWRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:17:49 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:36225 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752188Ab1GFWRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:17:46 -0400
Date: Thu, 7 Jul 2011 01:17:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: balbi@ti.com, Alan Stern <stern@rowland.harvard.edu>,
        Partha Basak <p-basak2@ti.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anand Gadiyar <gadiyar@ti.com>, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com,
        Benoit Cousson <b-cousson@ti.com>, paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
Message-ID: <20110706221738.GA823@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <Pine.LNX.4.44L0.1107051018580.2060-100000@iolanthe.rowland.org>
 <8762ngtyqj.fsf@ti.com>
 <20110706175412.GH10729@legolas.emea.dhcp.ti.com>
 <87sjqji5br.fsf@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <87sjqji5br.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 06, 2011 at 12:20:40PM -0700, Kevin Hilman wrote:
> >> +	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
> >> +	    (od->_state =3D=3D OMAP_DEVICE_STATE_IDLE))
> >> +		omap_device_enable(pdev);
> >> +=09
> >> +	return pm_generic_resume(dev);
> >> +}
> >> +
> >>  static struct dev_power_domain omap_device_power_domain =3D {
> >>  	.ops =3D {
> >>  		.runtime_suspend =3D _od_runtime_suspend,
> >>  		.runtime_idle =3D _od_runtime_idle,
> >>  		.runtime_resume =3D _od_runtime_resume,
> >>  		USE_PLATFORM_PM_SLEEP_OPS
> >> +		.suspend =3D _od_suspend,
> >> +		.resume =3D _od_resume,
> >>  	}
> >>  };
> >
> > it all depends on when are you planning to get this patch upstream. I'm
> > considering getting some PM working on USB host and remove the
> > pm_runtime calls from system suspend/resume either during -rc or next
> > merge window.
>=20
> Well, IMO it's way too late for this kind of change for -rc, so I'm
> considering it for the upcoming merge window.

yes, that's true. Who should take the hwmod patches btw ? I'm still
wondering if we should patch hwmod data first and push the _correct_ PM
part on 3.2.

--=20
balbi

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOFN8CAAoJEAv8Txj19kN1wwgH/0vaLqA0qVNToQbiiM/57xF0
BdGFNqvlJJjsoKBE7n7OcJFFrB1A0NteUldEHiyhS8hds1JR2U68Q6Cs516xWaf1
eTfVKKMIwUmeQkvclsLCYux7DW5tvHw9zUc8AigJx/sl5+2Fb0Ed1JIlXdkcSYh4
M/5bW2Y7W8oIhhCM2kX3NBYeRkeVNYT8LF4VGd1Yg6zc7WZPPZe7XRKQRkHO00yE
30g3d4YWFYia9eqvtnkIjV7nrZKLE2LSvdo+GQiPK5xy3chHIVeh9fG8BbyJhTbT
PpeEg2CJiYCQTS/5sHKOIVZKASybfAjXJvZ5aE5wue0aZ8QeD2RfbTGrgfBpe6Q=
=HIM2
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
