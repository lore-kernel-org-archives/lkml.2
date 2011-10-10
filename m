Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1JJXip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 19:38:45 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:46733 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752071Ab1JJXio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 19:38:44 -0400
Date: Mon, 10 Oct 2011 19:38:42 -0400
From: Eric B Munson <emunson@mgebm.net>
To: eranian@google.com
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Subject: Re: Oprofile Regression Caused by commit
 e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25 on PPC
Message-ID: <20111010233842.GC24583@mgebm.net>
References: <20111007204247.GA5444@mgebm.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <20111007204247.GA5444@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 07 Oct 2011, Eric B Munson wrote:

> This commit seems to have caused a regression with oprofile.  It is fairl=
y easy
> to trigger, simply run oprofile monitoring an event that will fire (somet=
hing
> frequent like CPU cycles) causes oprofile to fail saying that the PMU is =
in use.
> If I disable CONFIG_CGROUP_PERF, everything goes back to working.  I susp=
ect the
> problem is that the PMU is being initialized without being reserved for p=
erf.  I
> am not yet sure of the right fix yet so if you have any suggestions I wou=
ld
> appreciate them.
>=20
> Eric

This isn't the best description of the behavior we see, what happens is at =
some
point in the profiling session the MMCR register is clobbered by
perf_cgroup_switch() which calls perf_pmu_enable() without reserving the PMC
hardware.  When this happens oprofile stops counting.  It doesn't happen ea=
ch
time so some runs show event counts that are reasonable, but it can also le=
ad to
event counts that are smaller than expected, or completely missing.

Eric

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOk4ICAAoJEKhG9nGc1bpJbxoQAJiZLtnVQ5Cs41TtFXRotoWn
qjNGR76jFWDqSw9Bh52DBAp9+uvtlDqn309deQtm79C70TW1Pe73gIZdtrbwqduN
Iyy5+Nnlid8dBTkH4mEXQuJf1fdKifXJ2u4b+4sC061qCmauXJrZQXFBMm4J4ZO0
o+M1GIzH3rO0WAJcvHPSfR20OFn1d1ETZiaWv8nKyUTr/kwEamZ/p8ppES4Ar3JN
eRqpQ2CLhgBj9x+ptW76Y5z8Mgf4MTkNfyQ9mxehy3YCpPf2hBfhhy+DMXxoxl0z
qEv1Fbp3tvJ+JzyRcaivWw72xc4bxvfYAb6iDU4F0nr+s492uVeiR1I5yzX/dtAf
Eu8vXRCciIHSvZPNDoZgMnulppFU1pwEC+F6Gg9BaaOQpHCM8HB6cDEmrXQV6fCF
6PzF5FQi1bR+6WRn58sYLQTwCm6Q7n3kaqwn/qLMUN9H9SzG9EwjcCTHUKI0S/Hz
Fjy+UvbW8O43kSm9AN1/peNRYpGjwlJ13BaKCsQWIETW3acVqBoZbq4ZQxi4i9oL
yXk7kc6vyTG0bJvSPoabT3ySFng76X86e9N8Q1x8npDRvJ5Ib3xtFdHy8ThueIDc
7JhLvG//vWx4DeGY6PZi1dNZIgmksnx1z0vlKTMclxyXIfMJrIddEpjzidbpOK4B
i3kVOxXieEEL613x4W7d
=dAk7
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
