Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0IJCp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 22:45:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41067 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0IJCpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:45:55 -0400
Date: Fri, 10 Sep 2010 12:45:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Gerst <brgerst@gmail.com>
Subject: linux-next: build failure after merge of the percpu tree
Message-Id: <20100910124543.3e8604fd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__10_Sep_2010_12_45_43_+1000_FcSJPfi709VqS__O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Sep_2010_12_45_43_+1000_FcSJPfi709VqS__O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the percpu tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/vhost/net.c:26:
include/linux/if_macvlan.h: In function 'macvlan_count_rx':
include/linux/if_macvlan.h:69: error: read-only variable 'tcp_ptr__' used a=
s 'asm' output
In file included from drivers/net/macvlan.c:30:
include/linux/if_macvlan.h: In function 'macvlan_count_rx':
include/linux/if_macvlan.h:69: error: read-only variable 'tcp_ptr__' used a=
s 'asm' output
In file included from drivers/net/macvtap.c:2:
include/linux/if_macvlan.h: In function 'macvlan_count_rx':
include/linux/if_macvlan.h:69: error: read-only variable 'tcp_ptr__' used a=
s 'asm' output

Caused by commit 7f56c13698abfb1bdf6cf2b5cfcd80626d44c12e ("x86, percpu:
Optimize this_cpu_ptr").

That line in if_macvlan.h is:

	rx_stats =3D this_cpu_ptr(vlan->rx_stats);

Where vlan is a "const struct macvlan_dev *".

I have used the percpu tree from next-20100909 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Sep_2010_12_45_43_+1000_FcSJPfi709VqS__O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMiZvXAAoJEDMEi1NhKgbsu5AH/2toM5MGQZ31QanJ6zKqJ8CN
Zfty1Q9JoitPFNOLALIChMF458DVbPXxWO1hqpmqDGuEk7UT5omD96heB75D5sWk
KpjFEaEHTEmIbN9JVIMinZ0nSRCWIvUtN4ZzIWKBY6rPMtH15w+uFkPRA5S0dIQC
/ulBrpuKv3WcTAyR0mftofrt6yzha3GYP4MvnPPEeqJy9NStLGHd2ykQrWh/Etz6
uCsYTnBOGRcwQH1tMeHWvZeAOSmsvmKcsaBe0CDCUgpB7ncpCMFrTgD+3vV0W7Tg
gdAuKmwfv2SqNe4tJME9IRUL28QJho5Nh8mAHLpbkCGaDOSIXIEn8LmYxp6r0Ow=
=AAsN
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Sep_2010_12_45_43_+1000_FcSJPfi709VqS__O--
