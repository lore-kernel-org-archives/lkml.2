Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab1EYMmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:42:35 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:39112 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756898Ab1EYMmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:42:33 -0400
Date: Wed, 25 May 2011 15:42:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110525124227.GQ14556@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110525092124.GI14556@legolas.emea.dhcp.ti.com>
 <015801cc1abd$ca534e20$5ef9ea60$@org>
 <20110525092743.GK14556@legolas.emea.dhcp.ti.com>
 <018e01cc1ac0$2b09b040$811d10c0$@org>
 <20110525094902.GM14556@legolas.emea.dhcp.ti.com>
 <01a601cc1ac2$f0041a00$d00c4e00$@org>
 <20110525102945.GN14556@legolas.emea.dhcp.ti.com>
 <01b401cc1ac9$d1c57870$75506950$@org>
 <20110525112350.GP14556@legolas.emea.dhcp.ti.com>
 <01c601cc1acf$8e28e920$aa7abb60$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FNX2SHge3qdlDajY"
Content-Disposition: inline
In-Reply-To: <01c601cc1acf$8e28e920$aa7abb60$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FNX2SHge3qdlDajY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 25, 2011 at 02:33:18PM +0300, Tanya Brokhman wrote:
> Ok so just to make sure I understand you correctly:
> You want me to remove the modification made to usb_composite_probe() and
> instead add:
> static struct usb_gadget_driver composite_driver =3D {
> +#ifdef CONFIG_USB_GADGET_SUPERSPEED
> +       .speed          =3D USB_SPEE_SUPER,
> +#else
> 	  .speed          =3D USB_SPEED_HIGH,
> +#endif
> 	  .unbind         =3D composite_unbind,
>=20
> And then you'll be ok with change? Or is there anything else?
>=20
> If this is it then I'm relieved :) and of course will update the code.

yeah, that's all. Just be sure not to introduce the typo I introduced
(missed D in SPEED) :-)

Then I'll hold on to those patches for 2.6.41 merge window.

--=20
balbi

--FNX2SHge3qdlDajY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3PkzAAoJEAv8Txj19kN1Uy4H+wfASbpXZ3HWBhSycA+FkrCK
95MfnpFR5k5WQD1bX+emD0UkiymH/4lAOIT0raohFAOrzIvOZGbhoigq9jg4vExA
bLjDJGz+OzoAvea+OWYw39gy+UbvOg/i99nY6RE+8LT29wDSMiSBBMPfkryuqlzI
S/dl4+CijoNHE5krgWKWOnU3dOGQm9vFOvxuJIU3G4uRe1dThpCm5knZV25Qk61e
1/Guh0peigFVH7CEhNvVUMVtNrrsP1g+nAGVgHJfLvNdApq9fufnZb+KX/WC4GHG
o9s/EjVP83CoUDq2GfLnjUjonb64DXIY5YoWBfUY8syyiydcs3ordSS77h7IuH8=
=cfiA
-----END PGP SIGNATURE-----

--FNX2SHge3qdlDajY--
