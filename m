Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1GGH2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:28:45 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47349 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155Ab1GGH2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:28:43 -0400
Date: Thu, 7 Jul 2011 10:28:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Partha Basak <p-basak2@ti.com>
Cc: balbi@ti.com, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anand Gadiyar <gadiyar@ti.com>, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com,
        Benoit Cousson <b-cousson@ti.com>, paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
Message-ID: <20110707072834.GB1311@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <Pine.LNX.4.44L0.1107051018580.2060-100000@iolanthe.rowland.org>
 <8762ngtyqj.fsf@ti.com>
 <20110706175412.GH10729@legolas.emea.dhcp.ti.com>
 <87sjqji5br.fsf@ti.com>
 <20110706221738.GA823@legolas.emea.dhcp.ti.com>
 <94f8609ab03603c27ef2cf3850bb92e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
In-Reply-To: <94f8609ab03603c27ef2cf3850bb92e6@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 07, 2011 at 10:23:59AM +0530, Partha Basak wrote:
> >-----Original Message-----
> >From: Felipe Balbi [mailto:balbi@ti.com]
> >Sent: Thursday, July 07, 2011 3:48 AM
> >To: Kevin Hilman
> >Cc: balbi@ti.com; Alan Stern; Partha Basak; Keshava Munegowda; linux-
> >usb@vger.kernel.org; linux-omap@vger.kernel.org; linux-
> >kernel@vger.kernel.org; Anand Gadiyar; sameo@linux.intel.com;
> >parthab@india.ti.com; tony@atomide.com; Benoit Cousson; paul@pwsan.com;
> >johnstul@us.ibm.com; Vishwanath Sripathy
> >Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume
> >support of ehci and ohci
> >
> >Hi,
> >
> >On Wed, Jul 06, 2011 at 12:20:40PM -0700, Kevin Hilman wrote:
> >> >> +	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
> >> >> +	    (od->_state =3D=3D OMAP_DEVICE_STATE_IDLE))
> >> >> +		omap_device_enable(pdev);
> >> >> +
> >> >> +	return pm_generic_resume(dev);
> >> >> +}
> >> >> +
> >> >>  static struct dev_power_domain omap_device_power_domain =3D {
> >> >>  	.ops =3D {
> >> >>  		.runtime_suspend =3D _od_runtime_suspend,
> >> >>  		.runtime_idle =3D _od_runtime_idle,
> >> >>  		.runtime_resume =3D _od_runtime_resume,
> >> >>  		USE_PLATFORM_PM_SLEEP_OPS
> >> >> +		.suspend =3D _od_suspend,
> >> >> +		.resume =3D _od_resume,
> >> >>  	}
> >> >>  };
> >> >
> >> > it all depends on when are you planning to get this patch upstream.
> >> > I'm considering getting some PM working on USB host and remove the
> >> > pm_runtime calls from system suspend/resume either during -rc or
> >> > next merge window.
> >>
> >> Well, IMO it's way too late for this kind of change for -rc, so I'm
> >> considering it for the upcoming merge window.
> >
> >yes, that's true. Who should take the hwmod patches btw ? I'm still
> >wondering if we should patch hwmod data first and push the _correct_ PM
> >part on 3.2.
>=20
> Once Kevin pushes this infrastructure enhancement, all drivers have to
> rework
> the Suspend/Resume anyways. Another way would be to go by the current
> approach
> now and then do the rework in 3.2 along with other drivers.
>=20
> In this way, we can soak the Runtime support of EHCI/OHCI for one merge
> window.

but if it's known to be broken, why add something which is broken
anyway ?

Tony, can you queue the arch/arm/*omap*/ patches ? I'll take care of
the EHCI stuff for the next merge window, will keep them pending in my
queue.

--=20
balbi

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOFWAiAAoJEAv8Txj19kN11rEIAJbsB3ukaTvT7gditpHKKXzL
pTLGGy4MZ+zmxmHg3xqgmRNyx2u+3k264ZzIhNq/6i+66PlnuEUGW5V8e2BAN28R
M7cjj/rdOVTMNfe0EJn2JxfRBNTONMvSf6ZC5LM8yKrfk/Qc19LX7LUALMnKwXAI
cihAzl8TjSlO/NoXbJxMkm/NacZqOM+mnszPqtfKefWyT2VkN3TJuaw0HrxXmzCF
5vUZOWGMHbQWHEGpcpoj64QqGky3IjHULH0JPZO82dFGbvOPxTaVWLYNec4zovH2
a/9sClzNiYVkUHKXiEnAAgeocl9wl++ezeFBXZXf7IeMVvIarBiyj95WAo6kudI=
=wP1L
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
