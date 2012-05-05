Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab2EEEgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 00:36:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55062 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2EEEgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 00:36:45 -0400
Date: Sat, 5 May 2012 14:36:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        jbaron@redhat.com
Subject: Re: [PATCH 3/3] dynamic_debug: remove unneeded includes
Message-Id: <20120505143629.57126695eba8787d1033ac7b@canb.auug.org.au>
In-Reply-To: <1336067860-19953-3-git-send-email-jim.cromie@gmail.com>
References: <1336067860-19953-1-git-send-email-jim.cromie@gmail.com>
	<1336067860-19953-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__5_May_2012_14_36_29_+1000_Q=0V8rxAb7MDCmar"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_May_2012_14_36_29_+1000_Q=0V8rxAb7MDCmar
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jim,

On Thu,  3 May 2012 11:57:39 -0600 Jim Cromie <jim.cromie@gmail.com> wrote:
>
> These arent currently needed, so drop them.  Some will probably get
> re-added when static-branches are added, but include loops prevent
> that at present.

How sure are you that these are not needed?  Has this been done by
inspection, or by compile testing?  How widely have you compile tested?

I took a brief look ...

>=20
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  lib/dynamic_debug.c |   10 ----------
>  1 files changed, 0 insertions(+), 10 deletions(-)
>=20
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 7ca29a0..fc5d270 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -14,24 +14,14 @@
> =20
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/moduleparam.h>

There is a use of module_param() in this file ...

> -#include <linux/kallsyms.h>
> -#include <linux/types.h>
>  #include <linux/mutex.h>
> -#include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
> -#include <linux/list.h>

List_for_each_entry is used ...

> -#include <linux/sysctl.h>
>  #include <linux/ctype.h>
> -#include <linux/string.h>

strlen() is used ...

> -#include <linux/uaccess.h>

copy_from_user() is used ...

>  #include <linux/dynamic_debug.h>
>  #include <linux/debugfs.h>
>  #include <linux/slab.h>
> -#include <linux/jump_label.h>
>  #include <linux/hardirq.h>
>  #include <linux/sched.h>
> -#include <linux/device.h>

struct device is referenced ...

I am a bit more paranoid about these things than most.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_May_2012_14_36_29_+1000_Q=0V8rxAb7MDCmar
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPpK5NAAoJEECxmPOUX5FEfGgQAI4BjBVjQ5fblFTOTXLPKW4j
p77teH0vVI9S1kI4DRphMMAgKvPcWkhlGKs6JU+FIkfFsdX986uOsqhgQ2Q+rz0G
nPWG3lDlKmRsZcTZO2bR45qCYgM/e5SvMv3XQ50NCD7okD1yLx0F0FWGa5sk94U1
DRWVu2871dqHmLN8dSa41QcuAEppEJpEF1BTL3QbG56iWPTaAs8K/BvHpfqm32yE
pA2YUuLkjqT34H7umYcQMGMOIGBfIpTYNw33iMmZgQjTacuvNfJySOpluwZhY336
5Enlfof9zoi42JuoMMPry1HbduaVzFeEmwDVVuQHkLMAbbSZ5TTf/B4nFLtmra8j
mG6YTOtgBRPmUMqJChn9a9MrbmujQWYAupdJX8A4Nwk3h4Hp37l8i2OpdwipAYR8
RDfSHtroQIqmbWmLLuL9lsgbMTbGrsFD3GpocPk9SwvXuoo12rBjKS77SOOSD3wl
DahiuqGcZuZBkfN5gHgTrqr5bIDJzn9Vd7kqe9ha9+CLcp2im1YX50HU5CEiSrdH
mEhNT3RGL1HZrLiaPlV2kkJ4t8JsF7NW5BOT/rcgD3Xz+tWTn68OfqzZTwqCxDdY
Z4XVk2WyWwZPp526T9QDC/rV2cnYBWoZkCImOH/Rop+C91Ij4rHok1t0dtJvwBhN
l3/tuZAsALoE/8Gua8SQ
=H22j
-----END PGP SIGNATURE-----

--Signature=_Sat__5_May_2012_14_36_29_+1000_Q=0V8rxAb7MDCmar--
