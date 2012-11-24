Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab2KXRz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 12:55:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34323 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864Ab2KXRz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 12:55:57 -0500
Date: Sat, 24 Nov 2012 18:55:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Qing Xu <qingx@marvell.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: max8925: fix compiler warnings
Message-ID: <20121124175554.GF4719@opensource.wolfsonmicro.com>
References: <1353550266-21330-1-git-send-email-qingx@marvell.com>
 <20121123014135.GC4385@opensource.wolfsonmicro.com>
 <50AEDF00.7060709@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eDB11BtaWSyaBkpc"
Content-Disposition: inline
In-Reply-To: <50AEDF00.7060709@marvell.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eDB11BtaWSyaBkpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 23, 2012 at 10:27:12AM +0800, Qing Xu wrote:

> But, in fact, it is not necessary to initialize regulator_idx.

>         for (i = 0; i < ARRAY_SIZE(max8925_regulator_info); i++) {
>                 ri = &max8925_regulator_info[i];
>                 if (ri->vol_reg == res->start) {

> ****** if regulator_idx can not get a match "i" here, it will return
> -EINVAL in below code

>                         regulator_idx = i;
>                         break;
>                 }
>         }

>         if (i == ARRAY_SIZE(max8925_regulator_info)) {
>                 dev_err(&pdev->dev, "Failed to find regulator %llu\n",
>                         (unsigned long long)res->start);
>                 return -EINVAL;
>         }

> How to solve such compiler warning?

Typically by reporting a compiler bug, though sometimes in the process
of doing that one finds out that there's some non-obvious way in which
the code can break.

--eDB11BtaWSyaBkpc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQsQokAAoJELSic+t+oim9j0gP/A76CAu0nv1vHLiMJ7QCu1Rj
Rx48koFd0jMjH13oHkvfmDc6xIqECAaFM0bd/9yt0j5oiqAO1C+x/Z4J+45rectT
I4FDhD5m12rgzmBJQM09ietdTtC0ZgK2PvhurtGueOq2lj6tf3U0bBueihpkUQto
mB4lN5OKTMXi2l4Ez/Cu+cLJXBfluqX4l5k4BJbjz42EYbo8zLCskFpqJTn0wqDO
IRg85hZHw6EFrDRNgZYazKgk/e5/G7uZbpfHuunZhxGo5lbVJdi1OIcpflUtTpAf
dcfiJi+J1ik57zmtbhbHTn8L2oDMsEWNNzjPhlYzL7p5iW5xa09HaBu6ggCUByoH
9V1ypxlxDWG3k9MMxgrk6iCjIoit9Jju1WRMYHpwRkDiMvvSn7zFAHv4ISUbmi/b
VCrKet6ZvBPJ+1eHvn05+P7IF95E5lk53/Sd9g4MKK0RfWrjKfpRLbVh6VoKoi79
tyWJMjdN6iFZVo5wBXYeDB7krLfxVo5dJJdXOR8evYS3yeZ1y7YHBEp57a4cq2U+
7cQtKFadCeLh3KwwWWve/g9cXcF33MrKUDhaITHCFwDBVovCkzxKb/xF5NYvkw4+
WjloMYJP9YFVjDB0sllqVnlvuJvJSf27nJ6MXfPyHET+5JyhLI8ZbcAwjFqJbqYA
XYPrtUGjojXIHXQ6ce5J
=KCen
-----END PGP SIGNATURE-----

--eDB11BtaWSyaBkpc--
