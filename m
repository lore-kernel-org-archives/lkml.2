Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2EUCF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 22:05:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34766 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab2EUCFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 22:05:25 -0400
Date: Mon, 21 May 2012 12:05:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipul Pandya <vipul@chelsio.com>,
        Steve Wise <swise@opengridcomputing.com>
Subject: linux-next: build failure after merge of the infiniband tree
Message-Id: <20120521120512.15f1e9dfc961b05dfee72f79@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_12_05_12_+1000_6OEbz5KAKzLm8Cb7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_12_05_12_+1000_6OEbz5KAKzLm8Cb7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the infiniband tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/infiniband/hw/cxgb4/device.c: In function 'qp_release':
drivers/infiniband/hw/cxgb4/device.c:124:2: error: implicit declaration of =
function 'vfree' [-Werror=3Dimplicit-function-declaration]
drivers/infiniband/hw/cxgb4/device.c: In function 'qp_open':
drivers/infiniband/hw/cxgb4/device.c:148:2: error: implicit declaration of =
function 'vmalloc' [-Werror=3Dimplicit-function-declaration]
drivers/infiniband/hw/cxgb4/device.c:148:11: warning: assignment makes poin=
ter from integer without a cast [enabled by default]

Caused by commit d716a2a014ad ("RDMA/cxgb4: Use vmalloc() for debugfs QP
dump").  See Rule 1 in Documentation/SubmitChecklist.

I have used the infiniband tree from next-20120518 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_May_2012_12_05_12_+1000_6OEbz5KAKzLm8Cb7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuaLYAAoJEECxmPOUX5FErDkP/1n7ldDlC+01Fl3FzRK4eyYM
rE++FDkovHYNa6RJ9fB9AzOkYydaW49Kmq9wN59NK6xQgQzWyr4GB7+uEDbqSeWd
OeRJoeja0XkMWhFo+sxZErSQCkR8L/Wx63abNtPz0EWYlltXucPgs5kFt6Q6cIx5
G2jwC1oZFrnYMZls+a/xEoNxB2jz2QgdE/I+JVw04jr45ApXe0UkvyxrgRthuPL2
6fZKasUARNd6Kzq9fSSecIlTf3H2GvoxLunnHSPNk8IEmUqaVblJF+KV8FgvxVOG
FoSsxcIlEYpwqjAqIYasKSpu0lP2+Ia69RQLsuHQV5pq90mOnxWldhxZOlrCWmjT
OAkS8cg5at27HBNWbRSeO3Nqr/Nx6hFJD/nukPa+EkI09BEgIixazPHovXz9Ppvm
AJXPo7fLpL9J1Axyj1N3ONwFQmuCOEOh+AN5dMVkF04WZSHpcB4CJiRBOhZ/RTO9
4xEQn/L45SDRHpBwU++6jrPN/+DqvNJHZmaBiPhN8hvjR6r+mxnUQEFkXKcqGfVL
iOssFZsGpQ5KLZR+LpV1oGX/0Uba9XOz+cuvhJilnZmUdWwXdKkMK6VG6wdlU0cE
mIhBt8g+WlOyy4PzA9Z2LN0W8UojnIf9xAw0clCuGJztQforpkaAIcJCPir6sj04
zJM18koJVucwR/0Bv/Gr
=9kmo
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_12_05_12_+1000_6OEbz5KAKzLm8Cb7--
