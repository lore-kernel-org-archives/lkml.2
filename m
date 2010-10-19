Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776Ab0JSD57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:57:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40882 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933700Ab0JSD54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:57:56 -0400
Date: Tue, 19 Oct 2010 14:57:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Paul Moore <paul.moore@hp.com>,
        Patrick McHardy <kaber@trash.net>
Subject: linux-next: build failure after merge of the security-testing tree
Message-Id: <20101019145747.f828be03.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Oct_2010_14_57_47_+1100_6Uhz=fAQDyFY/3p."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Oct_2010_14_57_47_+1100_6Uhz=fAQDyFY/3p.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the security-testing tree, today's linux-next build (powerpc_=
ppc64_defconfig)
failed like this:

net/netfilter/nf_conntrack_netlink.c: In function 'ctnetlink_conntrack_even=
t':
net/netfilter/nf_conntrack_netlink.c:585: error: 'struct nf_conn' has no me=
mber named 'secmark'

Caused by commit fd0194de4cf2e64514aec35f40de458fca766656 ("conntrack:
export lsm context rather than internal secid via netlink").  This build
has CONFIG_NF_CONNTRACK_SECMARK not set ...

If you change a dependency on a CONFIG option, it is always worth build
testing with and without the option set.

I have used the security-testing tree from next-20101018 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Oct_2010_14_57_47_+1100_6Uhz=fAQDyFY/3p.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMvRc7AAoJEDMEi1NhKgbsQD4IAKKIm9eQoQpb6E0j8W0obJlm
4mgqmuVG2jGs2a8eIQxzvRyPpLp659Ko18nu34iE9RNWIp3wrMK4sXA0ml6u+f3z
rqNyJbtp6J+qSET7ZKxNK0ie/uZVOSas0e5O/tnQqUenehbX32jyGERyeXpf8Dl9
55JapLKUfnSH99G7HBY2ZcS8H8+rUB6lONp9nJYZykck1qp07yvmeQGW3Pq3p1lw
0UIrRBOnfCXgTzu8s0k0shdh1qaTCd2vc73/FjScJP+NMIC24DuC0oZQuqI9871l
fv3Pws6d9wPUvB9YvUXNkbGc66V6caf4Yn1iaGqw+SCflwYONl6ftMTXCNhFFtc=
=t+ph
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Oct_2010_14_57_47_+1100_6Uhz=fAQDyFY/3p.--
