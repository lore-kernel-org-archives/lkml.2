Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2GaK4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:56:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51752 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab2GaK4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:56:51 -0400
Date: Tue, 31 Jul 2012 12:56:40 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120731105640.GD16155@avionic-0098.adnet.avionic-design.de>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <50170EA0.1010408@wwwdotorg.org>
 <5017B434.2010706@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
Content-Disposition: inline
In-Reply-To: <5017B434.2010706@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:l77RIrasSgeuaKYZBbAoJd3RkCFcxAuqKHz7OXEmin/
 MT40DGfeF7b+n0adbDnHb8WHV5i8jU+3XVWQRCRP80ilScoVJi
 51RZltrhvZ6ua4HSb2ww7W4fMx+rLyxg+s2E1MpGvw0zq97IRk
 E9XdEaaXiwZwOcl1vtyGNwrxolqK0U/WIIUWpzA5iRDFdC/WjB
 Ke1RFizu42DLddq1sNG6dGsP2Qs4nh5Khv9XfcEDnzMjRJ1ZLd
 LN9nx0ODNH22ey5u9epomBYHhM4gvNDYXrrHIzm4pNvxjcSqrc
 GEk4LN/I/L3SA5g0os2VPaJVtiQnKm152YOTm6/GyFDiyN9Di/
 OYmrZ36ng4KraDgafAjIK81nNM2t5wIxmYTUnq2krkGe8mQxhA
 rmK8ijLdV3mFmfOQTNv0PE1sIowzwxttxM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 31, 2012 at 07:32:20PM +0900, Alex Courbot wrote:
> On 07/31/2012 07:45 AM, Stephen Warren wrote:
> >I wonder if using the same structure/array as input and output would
> >simplify the API; the platform data would fill in the fields mentioned
> >above, and power_seq_build() would parse those, then set other fields in
> >the same structs to the looked-up handle values?
>=20
> The thing is that I am not sure what happens to the platform data
> once probe() is done. Isn't it customary to mark it with __devinit
> and have it freed after probing is successful?

No, platform data should stay around forever. Otherwise, consider what
would happen if your driver is built as a module and you unload and load
it again.

> More generally, I think it is a good practice to have data
> structures tailored right for what they need to do - code with
> members that are meaningful only at given points of an instance's
> life tends to be more confusing.

I agree. Furthermore the driver unload/reload would be another reason
not to reuse platform data as the output of the build() function.

But maybe what Stephen meant was more like filling a structure with data
taken from the platform data and pass that to a resolve() function which
would fill in the missing pieces like pointers to actual resources. I
imagine a managed interface would become a little trickier to do using
such an approach.

> >If the nodes have a unit address (i.e. end in "@n"), which they will
> >have to if all named "step" and there's more than one of them, then they
> >will need a matching reg property. Equally, the parent node will need
> >#address-cells and #size-cells too. So, the last couple lines would be:
> >
> >		power-on-sequence {
> >			#address-cells =3D <1>;
> >			#size-cells =3D <0>;
> >			step@0 {
> >				reg =3D <0>;
>=20
> That's precisely what I would like to avoid - I don't need the steps
> to be numbered and I certainly have no use for a reg property. Isn't
> there a way to make it simpler?

It's not technically valid to not have the reg property. Or
#address-cells and #size-cells properties for that matter.

Thierry

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQF7noAAoJEN0jrNd/PrOhQrIP/1aKVnCe0ismm9KHjsPrV5YR
LEki71luehGkF0xbg6thde0y/r+Zi3QcA4oXRpvEznazgT+qqZBgK9LojCv36Q4+
aTgI+VVi+H+WcbRZg3hS+jqP1r17EjQ9WP6S+FuWqYgSfPWao6K8NM/FuuEtC5az
CHoZc0WabwI13D+zNlhjA7N1gx6vsYdMSf33Gf6aS+MUnuHuIduQWxC8AuCUvTT9
72bYhDyRGG73a5ooIHqVxCj3MRnGQAu8FYVaSDVlhmT6nzgd6Gh0ms6n9qRC/2wH
k96OenFkDgkVpFgPqg22sKR+0fJOniCNxrKhMQ8Tr9Hzb0T4OfFFtHI/FXL6z1gG
fVwdVkkd9ViG580/21xA+i0TLSFtqNuNHUclaKNMwBJAC9VFs+JwaeHQ48fFe37n
+LNhyAFti+Lf6mc8h3/9/l455Ix7xnXYy8zPov5JwFCMyD4FFo0By4k7UGSmOEY/
WRs0ODwDv0Md6OvDipRFbKLw+L1coYmsgEnndLDrrQcbEWo854lUEClcNmDl8yk8
pmdXKc0pdGhDZF/hZDfp/e8NyGiH1VgmIupDF/JFJ6NTeWF/OprElSPJRwchEW8N
/MkE2me+ruLrzNWqmUYqdJWurM9PZW0OwDwvq8TZr4hsCMmYjLAd+ANUkBod0xU6
eQJZzZ4tJ6+KzprosuDC
=Y3Sh
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
