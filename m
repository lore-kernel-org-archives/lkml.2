Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2CXLMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 07:12:32 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab2CXLMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 07:12:30 -0400
Message-ID: <4F6DAC0C.4010203@nod.at>
Date: Sat, 24 Mar 2012 12:12:12 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org
Subject: Re: [PATCH 08/10] um: Fix possible race on task->mm
References: <20120324102609.GA28356@lizard> <20120324103050.GH29067@lizard>
In-Reply-To: <20120324103050.GH29067@lizard>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD953513F54FF3AFE747589E6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD953513F54FF3AFE747589E6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 24.03.2012 11:30, schrieb Anton Vorontsov:
> Checking for task->mm is dangerous as ->mm might disappear (exit_mm()
> assigns NULL under task_lock(), so tasklist lock is not enough).
>=20
> We can't use get_task_mm()/mmput() pair as mmput() might sleep,
> so let's take the task lock while we care about its mm.
>=20
> Note that we should also use find_lock_task_mm() to check all process'
> threads for a valid mm, but for uml we'll do it in a separate patch.
>=20
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard


--------------enigD953513F54FF3AFE747589E6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPbawQAAoJEN9758yqZn9et8IIAIjjApdHtjO4jbQojJt9/hMC
a2mKqQUILDnbdr7KTCZu3OGUbHpQhvdWYo1ZssGjz9XHSDFIKF8PdmSwPuh46HcO
GZwGZ6gfPRV23gJr1BnT+WkJzRoC4CG/xBzt2YpPMgjLDFAs4mkGX0w0knd/iEYD
hu185ttLe/u2DmU2rbCsEJ9YfxkwQ0+326WxH7D71HwAMpRCtmg1ciPdXMabeNnq
mU6gHLh7JPKWu8QPYWLwF+NRAzqOAENnHZkBEBX3rvapkQhIYdFWBHLhY2Wh9dgL
8cLyhir504HG+JcT5wegeivcMT2YQ/ODRuPqCwUsUEXxjI5caPzyWfsV3d2Y2nI=
=J9Yc
-----END PGP SIGNATURE-----

--------------enigD953513F54FF3AFE747589E6--
