Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab2ECKDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:03:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:45397 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177Ab2ECKDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:03:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="148856402"
Date: Thu, 3 May 2012 13:04:09 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: coretemp: use list instead of fixed
 size array for temp data
Message-ID: <20120503100409.GA6971@otc-wbsnb-06>
References: <20120501212512.GA4340@ericsson.com>
 <1335971436-13903-1-git-send-email-kirill.shutemov@linux.intel.com>
 <4D68720C2E767A4AA6A8796D42C8EB591070BF@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB591070BF@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 03, 2012 at 05:29:43AM +0000, R, Durgadoss wrote:
> > @@ -707,14 +787,12 @@ static void __cpuinit put_core_offline(unsigned i=
nt cpu)
> >=20
> >  	pdata =3D platform_get_drvdata(pdev);
> >=20
> > -	indx =3D TO_ATTR_NO(cpu);
> > -
> > -	/* The core id is too big, just return */
> > -	if (indx > MAX_CORE_DATA - 1)
> > -		return;
> > +	attr_no =3D TO_ATTR_NO(cpu);
> >=20
> > -	if (pdata->core_data[indx] && pdata->core_data[indx]->cpu =3D=3D cpu)
> > -		coretemp_remove_core(pdata, &pdev->dev, indx);
> > +	tdata =3D get_temp_data(pdata, attr_no);
> > +	if (tdata->cpu =3D=3D cpu)
>=20
> The get_temp_data can return a NULL. So, you might want to do,
> if (tdata && tdata->cpu =3D=3D cpu) to avoid a potential NULL ptr crash.

Good catch, thanks.

> In general, why are we using spin_locks instead of mutex_locks,
> for list manipulations .. ?

I don't think it matters here. Contention is low and nobody sleeps, but
okay, I'll change it to mutex.

--=20
 Kirill A. Shutemov

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPolgZAAoJEAd+omnVudOM8YQQAKLcB8KEzd3SFRRKtPCNi3p8
xJq/ZrwE8QhQwYPwvnR+E6VYp3x8boJ11TcGjwZRwmYw6H/zZQZ8FWVCbV4WFUJq
f9kNLlFxHKP5RVH5nV+dWplYnM6AJ9Fv18TQCX2as4kfu6otvIZh+nZ/YB4pyg35
wMmGE3uPDH3qR+tXHORjTxtqT7ney4AXFX3aUmRgzQDYQv5/Rb85+40wVQMGLtwl
E7gwC2gYfgAhp3OVPNUcAwzgRmlrOp2of8NMLvWZCe+KTZjeIamA+iAgbwr1OWi0
M5fuBd34F6UN50/V4DvZO7jC9SOSHNH8Tjh22KP44G6ruS2AauppM6yfwwbw6ym+
BIyxprxSW1aZbsZVRkNrfGlwwDcnREP7laGpzWpX2Ok8X2sKmEpsoVBaIJ7zy2hY
nw+QkAFWoBp2rgqNC5yhQUAxq8Z6lPIW4EiFcrTc1ZGyvw48TtDxUhvbVJPEBCrH
QlTVDgehVvBXy0/WWMNNHCjSBiRg7dIsyEuNfPJAo16OcqB9UZAT/zFv4EJEZngm
SJLcAV/PpfUgEcwBeZmjVSB92lOfRN2g91iLDIx2WYbq2PSL25ycgRv+h239JcTb
PpEEsdpR6hL7ysDxCvefVppiX5TRqgW71Gy85oGIXMz6yjRwazKf/qfRfWl3qM8n
usQ6GVztj/EtkMPX3RxZ
=5AHY
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
