Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab2HPTtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:49:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2HPTtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:49:18 -0400
Date: Thu, 16 Aug 2012 21:49:02 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Message-ID: <20120816194902.GA31405@avionic-0098.mockup.avionic-design.de>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
 <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
 <502D3E29.1010501@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <502D3E29.1010501@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:0nWena3cDsJY7iXLB3u8zhMSZPqamqqocsyqG8eXF47
 YP8NWvJQXTfn+vfw8IKVkU8bgqwfiBvtKew9RS4c0g0+4FsV+J
 GicaeTl7MMcvqbGosCzbGB2S46CKUa+NrSkXu+hm/HUNk5A+ZU
 aAMdWz3mgvqbssw8jURRkx5MksMZHYGyxbEFojl9P/+FLDLUJS
 K7rp05LK6qZTGKgj6yzf1ZY2nuRrwOmBdoIoqi6daHdgIllK09
 w5lUnyxBPQbyAVN4zcROlRFwtLMmxIqmC/dXhS8+AibXmXhBdc
 ymygC3snWgtE2+FULqADLQKsmoMTv0MHyt9z0KOCIojA/OoTIT
 rXzzNy6Ie8MgJ7pJ1MKv/7fd4/UKbPRCUuHN8fzzjqatxQGlHp
 IZdA7s3+PhW3atHLVYoN4rLOl1D87rH71o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 16, 2012 at 12:38:33PM -0600, Stephen Warren wrote:
> On 08/16/2012 12:08 AM, Alexandre Courbot wrote:
> > diff --git a/Documentation/power/power_seq.txt b/Documentation/power/po=
wer_seq.txt
>=20
> > +Usage by Drivers and Resources Management
> > +-----------------------------------------
> > +Power sequences make use of resources that must be properly allocated =
and
> > +managed. The power_seq_build() function builds a power sequence from t=
he
> > +platform data. It also takes care of resolving and allocating the reso=
urces
> > +referenced by the sequence if needed:
> > +
> > +  struct power_seq *power_seq_build(struct device *dev, struct list_he=
ad *ress,
> > +                                    struct platform_power_seq *pseq);
> > +
> > +The 'dev' argument is the device in the name of which the resources ar=
e to be
> > +allocated.
> > +
> > +The 'ress' argument is a list to which the resolved resources are appe=
nded. This
> > +avoids allocating a resource referenced in several power sequences mul=
tiple
> > +times.
>=20
> I see in other parts of the thread, there has been discussion re:
> needing the separate ress parameter, and requiring the driver to pass
> this in to multiple power_seq_build calls.
>=20
> The way the pinctrl subsystem solved this was to have a single function
> that parsed all pinctrl setting (c.f. all power sequences) at once, and
> return a single handle. Later, the driver passes this handle
> pinctrl_lookup_state(), along with the requested state (c.f. sequence
> name) to search for, and finally passes that handle to
> pinctrl_select_state(). Doing something similar here would result in:
>=20
> struct power_seqs *power_seq_get(struct device *dev);
> void power_seq_put(struct power_seqs *seqs);
> struct power_seq *power_seq_lookup(struct power_seqs *seqs,
> 				const char *name);
> int power_seq_executestruct power_seq *seq);
>=20
> struct power_seqs *devm_power_seq_get(struct device *dev);
> void devm_power_seq_put(struct power_seqs *seqs);

Hehe, this looks very much like what I had in mind when I proposed this
during the last version of this series. The nice thing about this is
that the API is very much in line with how other subsystems work.

Thierry

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQLU6uAAoJEN0jrNd/PrOhr4MP/2snONmcOXVvuStqUEV0YL4Q
Abm+sqY73pBbdmGxsjlli16xSPNbK4FGgsjBGjEBTgMReTDuei6n8cdG56u4ysUz
CgklhRlpFdOnInSg11Z4deLIvOTjgT60YowNmgK4+j6HlnbHbwhYGjGTHowkdSNF
kLANXTWC9moH9+yWR9msm9gBQBprUGQEsF+VypDq2PihXCsr7IS60Eo6I0O/KAFR
GKPSQgzHwlxG0U5OXYNi7u3qrCiiGoqoNWyYR2KFiqPvHRvgbpgHq+Y8zYDa8wx5
JNimX62A/Ah2EkyRIVGyBd6bxpvkySRbF3Da5QmhwFjJ4YYyQSHBJakLhvdKWUyx
mqxDudFxsMmrI+p81fg0mla3J8p8dq3NsTa4GpzrUIB5k5cNYaejd2l0CxTXwtnw
cGFZxb8lZo/pXm13YW2egPwtW5OOhRdGEA7+Eoea0Rpc/Sm5k0vLAlQRqWGHC3dE
03Luon2eSb4uW9xrZNLaV1nMac/4Quv471mYX06aXELxUw75eQu6eW14kxvm6uXT
3AiYkQaHrVyNW5b5NJgQivcfqz70eFtEGa3Ds3wQbU1e+Pj1wxszD67mpzsaUd37
0iVSM+R04Qr08YYhsM5eK4H/6AqG5H2isYh1zehvwVcjwxC2OQvhEG7E7sjUs6J6
dxlTH6I1wzhXi4qz7hzQ
=uCv9
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
