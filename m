Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1GUMxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:53:13 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:53537 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab1GUMxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:53:09 -0400
Date: Thu, 21 Jul 2011 14:50:08 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
        Willy Tarreau <w@1wt.eu>, MINOURA Makoto <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es, Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110721125008.GF11246@pcnci.linuxbox.cz>
References: <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com> <20110705231515.95bc758f.akpm@linux-foundation.org> <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp> <1310434819.30337.21.camel@work-vm> <20110712041938.GO27254@1wt.eu> <1310690138.3367.61.camel@work-vm> <1310724097.2586.296.camel@twins> <1310752795.2945.4.camel@work-vm> <20110721072256.GE9216@elte.hu> <1311251098.29152.130.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ulDeV4rPMk/y39in"
Content-Disposition: inline
In-Reply-To: <1311251098.29152.130.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5391814 records (last update: 20110721)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ulDeV4rPMk/y39in
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
thanks for the patch! I'll put this on our testing boxes...
Are You going to push this upstream so we can ask Greg to push this to -sta=
ble?
or do You plan to wait for more complex patch?
n.


On Thu, Jul 21, 2011 at 02:24:58PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-07-21 at 09:22 +0200, Ingo Molnar wrote:
> >=20
> > Ping, what's going on with this bug? Systems are crashing so we need=20
> > a quick fix ASAP ...=20
>=20
> Something as simple as the below ought to cure things for now. Once we
> get __cycles_2_ns() fixed up we can enable it again.
>=20
> (patch against -tip, .32 code is different but equally simple to fix)
>=20
> ---
> Subject: x86, intel: Don't mark sched_clock() as stable
>=20
> Because the x86 sched_clock() implementation wraps at 54 bits and the
> scheduler code assumes it wraps at the full 64bits we can get into
> trouble after 208 days (~7 months) of uptime.=20
>=20
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/cpu/intel.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index ed6086e..c8dc48b 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -91,8 +91,15 @@ static void __cpuinit early_init_intel(struct cpuinfo_=
x86 *c)
>  	if (c->x86_power & (1 << 8)) {
>  		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
>  		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
> +		/*
> +		 * Unfortunately our __cycles_2_ns() implementation makes
> +		 * the raw sched_clock() interface wrap at 54-bits, which
> +		 * makes it unsuitable for direct use, so disable this
> +		 * for now.
> +		 *
>  		if (!check_tsc_unstable())
>  			sched_clock_stable =3D 1;
> +		 */
>  	}
> =20
>  	/*
>=20
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--ulDeV4rPMk/y39in
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4oIIAACgkQ3xdJJrLygV7OkACdGNRSvKMvyUR4CyZwyaGr+tMc
yOsAniKGKWQ3n9XP4hkpfuSlXjvxXyZj
=u3Ds
-----END PGP SIGNATURE-----

--ulDeV4rPMk/y39in--
