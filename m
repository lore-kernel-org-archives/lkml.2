Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab2JGV02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 17:26:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37329 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab2JGV0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 17:26:25 -0400
Message-ID: <1349645172.16173.152.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 174/262] x86, avx: dont use avx instructions with "noxsave"
 boot param
From: Ben Hutchings <ben@decadent.org.uk>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 07 Oct 2012 22:26:12 +0100
In-Reply-To: <20120928183018.599659336@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
	 <20120928183018.599659336@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5tLgObXjDPBV3Z2FDTwp"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5tLgObXjDPBV3Z2FDTwp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-28 at 11:51 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.5-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Suresh Siddha <suresh.b.siddha@intel.com>
>=20
> commit c6fd893da927c6cefb2ece22402765379921a834 upstream.
>=20
> Clear AVX, AVX2 features along with clearing XSAVE feature bits,
> as part of the parsing "noxsave" parameter.
>=20
> Fixes the kernel boot panic with "noxsave" boot parameter.
>=20
> We could have checked cpu_has_osxsave along with cpu_has_avx etc, but Pet=
er
> mentioned clearing the feature bits will be better for uses like
> static_cpu_has() etc.

This was marked as needed for 3.5 only - presumably because the kernel
wasn't using AVX before this - but don't we also need to clear these
bits even in earlier versions so userland knows not to use it?

Ben.

> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Link: http://lkml.kernel.org/r/1343755754.2041.2.camel@sbsiddha-desk.sc.i=
ntel.com
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  arch/x86/kernel/cpu/common.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -144,6 +144,8 @@ static int __init x86_xsave_setup(char *
>  {
>  	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
>  	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
> +	setup_clear_cpu_cap(X86_FEATURE_AVX);
> +	setup_clear_cpu_cap(X86_FEATURE_AVX2);
>  	return 1;
>  }
>  __setup("noxsave", x86_xsave_setup);


--=20
Ben Hutchings
You can't have everything.  Where would you put it?

--=-5tLgObXjDPBV3Z2FDTwp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHHzdOe/yOyVhhEJAQotMhAAunbmdWFMEohm0cycudbSwx836UUjsKUd
Sj7eaq7QdIUjkHnC18C3WVXDC3D/fShumIbxerpAbkC6M7VU/ss9Stg3RlCsSXkU
NVzkjYtu8pynh67pFAe4QtZnu3PH9+9h04jzitTC6DAS1qSGKZURRdoQPGBPsUk6
RCb0zl14IfdHBjSrTmutlN1hZD2iVSqlZTWNqpXu/P4g1zjjBgnBdHCY4ftkNe/b
fq4L5EfMmm1OXouWwvQt/sNA/oe2b77AsKTQIsnQpKUHpsPLzukSu6NL9MKinzoL
j6HI7BIAJ7U5+Qe4UOnvC7Dnr6x7c4U9V8hcKAptAdN+U3n90aZVboW25pB0fhQb
/9AJk+uLqhf+U/TTkrNJck+XcEqgwuJs6v9nuWg8V/qidECLRjfRwcFEWr1VrWhV
D9+LgHbArtqEvkawV1VkaAuOR5phPsi6oyyJt9lWair6MLWKTd92ohsrvdSG/nny
rkATvibXhIbXcV575a3MGI5bjhijFdXGg0T4unDvn/8wxyACXMC27z4PCKPChd12
ymcCnFxGOvhRSImiOGryCaqLCdeqt6FCj6XoExDMAhf9T/ha9AfDzqnUNkHN/cpA
9dQnytCT69HAsSVy3xPRMWxi6b0eV7XtNUQ4lCIZRxj0oJwQui/Y7i19dheoUbbm
/St1rIg6tOY=
=ErKD
-----END PGP SIGNATURE-----

--=-5tLgObXjDPBV3Z2FDTwp--
