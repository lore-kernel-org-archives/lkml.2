Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2EGLJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:09:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:6236 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab2EGLJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:09:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="97167083"
Date: Mon, 7 May 2012 14:10:00 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Andi Kleen <ak@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v3] hwmon: coretemp: use list instead of fixed size
 array for temp data
Message-ID: <20120507110959.GA7339@otc-wbsnb-06>
References: <1336386848-31041-1-git-send-email-kirill.shutemov@linux.intel.com>
 <4D68720C2E767A4AA6A8796D42C8EB591184C1@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB591184C1@BGSMSX102.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 07, 2012 at 10:59:48AM +0000, R, Durgadoss wrote:
> Hi,
>=20
>=20
> > -----Original Message-----
> > From: Kirill A. Shutemov [mailto:kirill.shutemov@linux.intel.com]
> > Sent: Monday, May 07, 2012 4:04 PM
> > To: Yu, Fenghua; Guenter Roeck; R, Durgadoss
> > Cc: Andi Kleen; Jean Delvare; lm-sensors@lm-sensors.org; linux-
> > kernel@vger.kernel.org; Kirill A. Shutemov
> > Subject: [PATCH, v3] hwmon: coretemp: use list instead of fixed size ar=
ray for
> > temp data
> >=20
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >=20
> > Let's rework code to allow arbitrary number of cores on a CPU, not
> > limited by hardcoded array size.
> >=20
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  v3:
> >    - drop redundant refcounting and checks;
> >  v2:
> >    - fix NULL pointer dereference. Thanks to R, Durgadoss;
> >    - use mutex instead of spinlock for list locking.
> > ---
> >  drivers/hwmon/coretemp.c |  120 ++++++++++++++++++++++++++++-----------
> > ------
> >  1 files changed, 75 insertions(+), 45 deletions(-)
> >=20
> > diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> > index b9d5123..fa082d5 100644
> > --- a/drivers/hwmon/coretemp.c
> > +++ b/drivers/hwmon/coretemp.c
> > @@ -36,6 +36,8 @@
> >  #include <linux/cpu.h>
> >  #include <linux/pci.h>
> >  #include <linux/smp.h>
> > +#include <linux/list.h>
> > +#include <linux/kref.h>
>=20
> I think we don't need to include kref.h now :-)

Right. :(
Guenter, should I resend the patch or you can fix this on apply?

>=20
> BTW, at some places, looks like we are using 'tdata' obtained from get_te=
mp_data,
> without checking for NULL values. Other than that, looks Ok for me.

Do you mean sysfs show methods? It should never be NULL there. If it's
NULL, we have bug (race?) somewhere.

> Acked-by: Durgadoss R <durgadoss.r@intel.com>

Thanks.

--=20
 Kirill A. Shutemov

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp62HAAoJEAd+omnVudOMI+oP/0TiZ/j0N7TeF3reo3J/XL9P
1X5zcxy3TAw+qufVYgegfVv+KbfRk1j5I/AR3F0w5ZN2Eapa84UpeaPvUWiy+gJ3
5xqGSFQ/TVomYS4L0qyOzoG4rrNBhuiS2qdugGFE27VOG1U+AfE1apR7qsRwjJVw
KSAYons6HL6tfgo24IreOUt7C/xoZu/LqGMbnPTlZ0GNVzPKqrne7OM/dNOfjatw
BpwUQpndQYI4pWqgCARP5bYEATzyOoOiMJW62gyaIO4wk/YHUYmyOc7OSv6r1jXi
hMSfYyUYDA2mf5d0yvf+4uVns/eq/UkRlut1dN9rySWp7AB8hW6c+M3KQpUtYMHV
JQTOl+XBsTK8BIYXSW1xlRhe9PtG9RiyoCLom7BjUw4R66I5f5VIlM85EJzTueKJ
uOFPZ2ZZWDUP6D5hiMqftxVqclNRdHLwymCs+S/VdSdWroeIB0zALebCAcD0t1WT
vlgY/N0C1uNIk4rVkgKCHP0s4RbI/ghrCEFGLrC9XivNwsd/8IQAifVYUWQj/8wp
iwkvDx+soKLEVpwpEvKTWRpOocA1cFUTKGVI3wp/wo3cpOrOIU6JWPyxAnupBWP8
AN784ftHbmzZNSu4gThmT7CM/iCBt155CHWUOheViTmut7XXA9ntgPfydlRm/Kga
bZ5k6hk7Pkuqjo5iUFVZ
=re3c
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
