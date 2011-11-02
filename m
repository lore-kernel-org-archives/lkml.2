Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab1KBQXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:23:17 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51802 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932431Ab1KBQXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:23:15 -0400
Date: Wed, 2 Nov 2011 09:23:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 4/7] drm/i915: Let panel power sequencing
 hardware do its job
Message-ID: <20111102092310.2177a339@jbarnes-desktop>
In-Reply-To: <yunwrbjvv37.fsf@aiko.keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
	<1320214830-12696-5-git-send-email-keithp@keithp.com>
	<yunwrbjvv37.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RFVQw_g4KZhHMOZQpJaYoEZ"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RFVQw_g4KZhHMOZQpJaYoEZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Nov 2011 00:31:40 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Tue,  1 Nov 2011 23:20:27 -0700, Keith Packard <keithp@keithp.com> wro=
te:
>=20
> > -static void ironlake_wait_panel_off(struct intel_dp *intel_dp)
> > +#define IDLE_ON_MASK		(PP_ON | PP_READY | PP_SEQUENCE_MASK | 0        =
             | PP_SEQUENCE_STATE_MASK)
> > +#define IDLE_ON_VALUE   	(PP_ON | PP_READY | PP_SEQUENCE_NONE | 0     =
                | PP_SEQUENCE_STATE_ON_IDLE)
>=20
> A bit more testing -- looks like the MacBook Air doesn't mange to get
> PP_READY set when it's time to turn the panel on. I should look at this
> a bit more closely; there's no reason it shouldn't be set. But, nothing
> bad seems to happen if we simply ignore the PP_READY bit
>=20
> +#define IDLE_ON_MASK		(PP_ON | 0      | PP_SEQUENCE_MASK | 0            =
         | PP_SEQUENCE_STATE_MASK)
> +#define IDLE_ON_VALUE   	(PP_ON | 0      | PP_SEQUENCE_NONE | 0         =
            | PP_SEQUENCE_STATE_ON_IDLE)

Note that PP_READY will incorrectly depend on some other register
values, so in some configs the panel will happily power up even if
PP_READY isn't set yet...

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/RFVQw_g4KZhHMOZQpJaYoEZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsW5uAAoJEIEoDkX4Qk9huhQQAKqj/0dlLXnu2TJG8ocrdA5V
Yw4UOdaQmebYYCSCDfB2g2Ok1L7o5AG+tLvjV1Kubj8SS984d51HGrEdWT1Sd65k
HkxWt0ckGnK427pgMDdTqtv93vmRhnxLuG3L9LKPJ4BxOjrxB+5nrVmdvWLJVs+6
Okc1p4yhizGDyFxOutPAgW/VOX07uY5OY7gNtnmRmGha4TXkVqWqt5km5mnqbto4
djxZT3NFNVBtuKyTbJXUryzJRFrtf7Huk627xegXZxFbkHKCGow8ycQbt5McsmMg
Vboa2HqSBGnpfo/2P9XY+hbb0SNLidSNkt9m3i+uxkyJFjo1j/GOazPDhb/LHlrS
ddIK0uIj2vK8bz7uQfUwFElK1R2CSl+DPo0DrYOlhiqHmQUpaFxPCtNZl67CGBr/
fdZ1ohtAvJQk19Iuxr49g5ztKYs2lgy0NsknSYqstRQQdBcvLlhJzOlhUOXaJGJw
sP5snOpnnV8f3v08DkFHtrAneapWtC/Blv5u4nObCQc63ZPc6PG0uaenZNjuHLVa
WRjbSLfSYmHbZ0rLeI2MtDm8zMY+4AbpmtMx8KVLQPrLk4Wr37lHsGhwFUF2Oh4t
7WYv4jV79MsqnXkUUQ1qjhtwhns6+IyNbFGwy7XIIkGqAS1DTNmkJoRm3+vrzQ3t
y541Lq85FsPEpul/emr5
=zwRE
-----END PGP SIGNATURE-----

--Sig_/RFVQw_g4KZhHMOZQpJaYoEZ--
