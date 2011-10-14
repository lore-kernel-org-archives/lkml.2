Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab1JNHHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 03:07:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44144 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1JNHHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 03:07:36 -0400
Date: Fri, 14 Oct 2011 18:07:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: linux-next: build failure after merge of the final tree (security
 tree related)
Message-Id: <20111014180730.193ed2e210b913c5852e9e39@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Oct_2011_18_07_30_+1100_LSfqP91nsO+fhocK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Oct_2011_18_07_30_+1100_LSfqP91nsO+fhocK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

security/smack/smack_lsm.c: In function 'smack_bprm_set_creds':
security/smack/smack_lsm.c:473:21: error: 'PER_CLEAR_ON_SETID' undeclared (=
first use in this function)

Caused by commit 84088ba23929 ("Smack: domain transition protections
(v3)"). PER_CLEAR_ON_SETID is defined in linux/personality.h which is not
directly included by the above file.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Oct_2011_18_07_30_+1100_LSfqP91nsO+fhocK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOl9+yAAoJEECxmPOUX5FEIoQP/1HL3W6djIku187LIs3tI4gK
eAKUZ1o11OP324tRTSnzvzT55SeJB+XOT+lCByffOMPFM+kQTOWvNtTVi65zwpaM
5nyE6SGhoMI9gM74+4u6pswv9ikDI8ShAp3aKT4GvHvSE9gqSRCMeBDTIeBdVamS
ZccDMNc7P41SgeiT5ng7WNCSDZkiAo3vbyNwnLbbpW03jOIQLJp6GDy2ra5Rbz6y
SeEOFmjUS9BARjuKvUDQ/2KARDgrh9boaxkTSGMxurLKtpP16d3UW6MyuUdc/waI
bEk4KQnXD8inKVJrn8ikpVqNOBqNJeDzQVp9rcNDaxPxGcZ6MkyujGLrMCq2GqCt
IpzuuYjymFWDnFPXAV3h1eVVE5xVXNlSXp3mS8EjYD3UcKoIuspgx8s5y4mJlYGG
S8dkrqmJLyt/0PO4CtK6U8DFhp83lRRi4gOP61n7h2qL2dDBjp930S1mGJ+eawM6
2MUPynx2fMER//M4MUM+Qyf90IYX5RArGD1c//7FbMCNXSuyA7P9AOPmFRo4LEdC
OzhCXXBs/JsFhR7aXTpvnKhA5egZRS2WnKkyvsaJqtr/EywwElCf1Eof/QpR4ZUW
fmACEP+u2PemU4ZuIdPXthzsaUKfjOchfW5JxqGgkEPknHiKPL6xcO9wyTjfAe6Q
BOLQGWfzf7K/OpGmjDKY
=cVLk
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Oct_2011_18_07_30_+1100_LSfqP91nsO+fhocK--
