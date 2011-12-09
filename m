Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103Ab1LIFJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 00:09:07 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:55183 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1LIFJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 00:09:05 -0500
Date: Fri, 9 Dec 2011 16:08:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20111209160856.d1f8de40a6d415cd5d9cafc7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Dec_2011_16_08_56_+1100_O1VXmGpYeQUec7Kz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Dec_2011_16_08_56_+1100_O1VXmGpYeQUec7Kz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from kernel/fork.c:21:0:
include/linux/mempolicy.h: In function 'task_has_mempolicy':
include/linux/mempolicy.h:258:13: error: dereferencing pointer to incomplet=
e type

And several more like that.

Caused by commit 9d15457f147d
("cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodema=
sk-fix-2").

I have reverted that patch for today (and the following trivial patch
"cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemas=
k-fix-2-fix").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Dec_2011_16_08_56_+1100_O1VXmGpYeQUec7Kz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4ZfoAAoJEECxmPOUX5FE48wP/iCzKJ3ssKteiJa2qRwbGkou
iWMly3PMApPlneJkvI2YkJg+CSaU6QNfdHFiaqZPBM/aMVcRy+5wVeLKTrx7fzuz
IqPeg+7T7xeBnX8meCJr7FP3vkk51odLFWCA4rF0SK+oBjVu5IwijBbXPTZIH+LK
4dLoYJu5aL4XVpRaF+OtTAOfLT2AEZXdTvzR9QsRIGxbISjWMGPoMnV1+yK1QURk
jGZuGsyi/fm/rID4XGRX2ti3qjG+b0HGIUcgYSkEePpAVQ9A5UUZEdpaZlS75z5s
qAvSuuXPfpLRydpysfIrrRCRXfdn25nVBscRMvpDWsUWwdrboPg9WRKp5OtNEoae
z9aDk6yw5YD40/cnz7iWXYmR+fZODIotYyaKjceU5p/M8zNzadwsgJmc/NJYxIMR
Xluhy9C+hcivMg4ETUwRTTuijJ2t2pZmzAWaXEEXxo7FcdgXI9kKOh6BjBIr5Wv7
L3TGWPaKPzSq1aV+Jx0H3ciJkdTQgEix0vc5WkLM/jI4xE38aRDu/epRnkSFRqzJ
0biMN4O/4zpvPTSmy48YAVv62HzyyL3K3AQIK/ehIM7l/F9CWPZDhJATp2d+Y/uR
viOjbStcb0hr5fxpS45vUDRMUoySL7QfCYi7aW+dzvUmb329izbshRpni7sxsCyF
eXiKZl16+cou/q1s02a1
=8cRa
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Dec_2011_16_08_56_+1100_O1VXmGpYeQUec7Kz--
