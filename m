Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0GTFKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 01:10:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52175 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab0GTFKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 01:10:38 -0400
Date: Tue, 20 Jul 2010 15:10:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (workqueues
 tree related)
Message-Id: <20100720151030.f874832e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__20_Jul_2010_15_10_30_+1000_78lNxlb598Y3vl+C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Jul_2010_15_10_30_+1000_78lNxlb598Y3vl+C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

kernel/workqueue.c: In function 'alloc_cwqs':
kernel/workqueue.c:2634: error: 'CONFIG_SMP' undeclared (first use in this =
function)
kernel/workqueue.c: In function 'free_cwqs':
kernel/workqueue.c:2659: error: 'CONFIG_SMP' undeclared (first use in this =
function)

Caused by commit f34217977d717385a3e9fd7018ac39fade3964c0 ("workqueue:
implement unbound workqueue").  Config symbols need to be checked for
being defined ...

I have used the workqueues tree from next-20100719 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Jul_2010_15_10_30_+1000_78lNxlb598Y3vl+C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMRS/GAAoJEDMEi1NhKgbs0rwIAJBQZ30cnsq6ImvXOWMMQS5R
UlV0ofIoazW32eeko8Nb+Xmbcf8e4l/krO7bmOe/32xohrw59+tC/6zaTlPFpQDf
ejKvhIl94IpbV5e+OUt20ue3ger40YyzzPFeGZ2hnuX4oKL9Mr9vRoBjboc6pnqk
ZrXe+aJfb0NJK9gnSu263s9NrLiD0fs6xnTr/k6o2m7sRshLwaDv28Xd0x+/lvyl
DtpSjO53Xttt5/nPIQDSu0cRHnj4fSAxABWsRvf7kpa7qAC7QSH3EuTTq1sDD1/M
Nmf+rd3fBQcNs7ZXVaO2jxlEtm4j3GGsb1plOu03slRFlNNM1xW/9nGgKrXJvrk=
=L0BF
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Jul_2010_15_10_30_+1000_78lNxlb598Y3vl+C--
