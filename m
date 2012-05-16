Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab2EPGNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:13:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55801 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2EPGNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:13:02 -0400
Date: Wed, 16 May 2012 16:12:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (battery tree related)
Message-Id: <20120516161256.b046bcb06148ac6417fd51b5@canb.auug.org.au>
In-Reply-To: <20120507082637.GH31494@intel.com>
References: <20120507171458.5ce17d20c40856e9440b3e5f@canb.auug.org.au>
	<20120507082637.GH31494@intel.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_16_12_56_+1000_Uss9wR0o=nfJLXvk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_16_12_56_+1000_Uss9wR0o=nfJLXvk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 7 May 2012 11:26:37 +0300 Mika Westerberg <mika.westerberg@linux.in=
tel.com> wrote:
>
> On Mon, May 07, 2012 at 05:14:58PM +1000, Stephen Rothwell wrote:
> >=20
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >=20
> > drivers/power/smb347-charger.c: In function 'smb347_probe':
> > drivers/power/smb347-charger.c:1039:2: error: implicit declaration of f=
unction 'IS_ERR' [-Werror=3Dimplicit-function-declaration]
> > drivers/power/smb347-charger.c:1040:3: error: implicit declaration of f=
unction 'PTR_ERR' [-Werror=3Dimplicit-function-declaration]
> >=20
> > Caused by commit 34298d40e585 ("smb347-charger: Convert to regmap API").
>=20
> I'm unable to reproduce this on x86 build. I guess <linux/err.h> gets
> included implicitly there.
>=20
> Patch below should fix this. Anton, care to pick this one as well (or fold
> it into the 34298d40e585 ("smb347-charger: Convert to regmap API") commit=
)?
>=20
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> Subject: [PATCH] smb347-charger: include missing <linux/err.h>
>=20
> Without the include we get build errors like:
>=20
> drivers/power/smb347-charger.c: In function 'smb347_probe':
> drivers/power/smb347-charger.c:1039:2: error: implicit declaration of fun=
ction 'IS_ERR' [-Werror=3Dimplicit-function-declaration]
> drivers/power/smb347-charger.c:1040:3: error: implicit declaration of fun=
ction 'PTR_ERR' [-Werror=3Dimplicit-function-declaration]
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/power/smb347-charger.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charge=
r.c
> index 09d19d2..f8eedd8 100644
> --- a/drivers/power/smb347-charger.c
> +++ b/drivers/power/smb347-charger.c
> @@ -11,6 +11,7 @@
>   * published by the Free Software Foundation.
>   */
> =20
> +#include <linux/err.h>
>  #include <linux/gpio.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__16_May_2012_16_12_56_+1000_Uss9wR0o=nfJLXvk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs0VoAAoJEECxmPOUX5FEL4cQAIR61s7ZJDLZp4y3YOAwaq4g
lCIY4MVrT/Wc904BZYaFP3mM9NO5Xoc3WHLLhNbKDj0SoLLbQr3+xVpswyWmogkv
oH20r1jpRN+H2Id+ye0cnJShEITpy/qS7JP8+u3Ar2vzc6XJoOlb4ZWaDOvSs9wl
v7EvP3J7nR/uteFrtEzwQK84+VluMFlSz14nhvSp/EykK5xoRt3wMZ3HtgDsbJpf
s/4G/cXDGcCAZ/UR8sWdsCrkL4n9gDzT/9ystj/2xgpet/ZjfUYaAgMrXc7eDSwR
WAR0snHkkqRYwcZoYd03Iq8SdaUp4zZU8RebwRCmwMQuB1eR4BWcwoUsrx8w7XyN
ES7OW5r8WTKV8kvt86gbnR8S8fWu2VLsz6t2ggOpUGNYgl9ED0w0XFHFb9TMq9m+
PtpMNkMYOTG/INIGDKbdwU+8fnq2TwAoVAiJS5oqDL22hZN8SE6G4IwkfLF5NkTW
34/r981N0BbYhpNhBP54y0haR3l1iMCvu18FOWF/Sj71bs4UU2Z2W2ZsgyJ1+5Pm
8V88xhaHmtPIBi2k/q8RubCXmVwLTQgB7VOt0EQdN5mRtuXGCW1xUKLRD0Hzfs35
V0E0cn+vLzWA4bL0Ys5n2xYtv+Luxn/tSZxAMlHAX19mnhV8tolylNxWPJoLZ5uZ
lUGe9o6qbivw436wNu3A
=7pA6
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_16_12_56_+1000_Uss9wR0o=nfJLXvk--
