Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1BQDdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 22:33:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47052 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab1BQDdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 22:33:31 -0500
Date: Thu, 17 Feb 2011 14:33:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the workqueues tree
Message-Id: <20110217143321.78f52ec5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Feb_2011_14_33_21_+1100_q_b9UNTnQmuruP5D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Feb_2011_14_33_21_+1100_q_b9UNTnQmuruP5D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the workqueues tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/workqueue.c: In function 'init_workqueues':
kernel/workqueue.c:3780: error: 'WQ_FREEZEABLE' undeclared (first use in th=
is function)

Caused by commit 58a69cb47ec6991bf006a3e5d202e8571b0327a4 ("workqueue,
freezer: unify spelling of 'freeze' + 'able' to 'freezable'") being
mismerged with commit 4149efb22da66e326fc48baf80d628834509f7f0
("workqueue: add system_freezeable_wq") which added another use of
WQ_FREEZEABLE.

Please do at least simple build testing before submitting to
linux-next ...

I have used the version of the workqueues tree from next-20110216 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Feb_2011_14_33_21_+1100_q_b9UNTnQmuruP5D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNXJcBAAoJEDMEi1NhKgbs4T4H/Rj7IYmnhkAtlZWjMkYOB+7J
3rr4lfgKIz8PTKYntZ1V4gvyb0EPNjo46qzGeeAtA3hT4Ec3ZZsR19l41sAwGogC
FIBZ3sw3JrHLMIcygp7gmzgbgjzWRSfugscmaO+VmdBimpC/2yQlwBbMGsmSUBZl
YDpAO7K8/rwzvNA2FF9c7IvOTA7NgC1/O7WvxeQ8jYPtk1+88KJgj7IaQEYEMvdS
2BARuJ1aCjt7T5GSQoTmfHhntEOqo9nNpGLjGf18/aH6JEtbUR2rZH79AklnTuXG
t+GxreCIaAviQYuPkvZrjYY6eGvLWy69TKWpc3XhrDQKXF29WhfP88HScKWqQD8=
=m4Le
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Feb_2011_14_33_21_+1100_q_b9UNTnQmuruP5D--
