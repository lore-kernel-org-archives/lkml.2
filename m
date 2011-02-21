Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1BUG5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 01:57:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58511 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1BUG5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 01:57:09 -0500
Date: Mon, 21 Feb 2011 17:56:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the final tree (kvm tree
 related)
Message-Id: <20110221175658.2dc4d1ac.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Feb_2011_17_56_58_+1100_BLsajjsXe9AkcHzK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Feb_2011_17_56_58_+1100_BLsajjsXe9AkcHzK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

mm/memory.c: In function '__get_user_pages':
mm/memory.c:1584: error: 'EHWPOISON' undeclared (first use in this function)

Caused by commit b1c4f2836370f5c8207d4c61e91c93bd6a4ce27a ("mm: make
__get_user_pages return -EHWPOISON for HWPOISON page optionally") from
the kvm tree.

Not all architectures use include/asm-generic/errno.h ...

I have reverted that commit (and commits
d47b742c5661385b927c03188549b2d2004b80f4 "KVM: Replace
is_hwpoison_address with __get_user_pages" and
eef8839430b72deac59e9ec51eb56c44512fcc66 "mm: remove is_hwpoison_address"
which depend on it) for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Feb_2011_17_56_58_+1100_BLsajjsXe9AkcHzK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNYgy6AAoJEDMEi1NhKgbsWlkH/2Pr+Gnbj/qhm01l4zLG0loZ
QOT3e8kYUT8RUPijLJ+SOpO63R5SX6rvYkO7HsxQUlT5ln4OPJkXeeh+6SLM+0rx
S4ySmDCBQaBZRRDxZpMsWyT0gOZ8rcCinmjo9z7GJwWJVtKT3VN233z+/wd3G+1C
mwbFOVBSZzqL0vhYrOmFwv+9vVb4QVip0jMawwN50MbQYNYT0DNh+kx/B/taxZTE
6s3q1DukMbURnAdKi4nEw+CnudVoSdkA0gYZWl0nqRQTk3sJ9A95/FB86+W8kRVk
V5aUaq9tArZh2YumPFBvxCspOI5qQxWlxFn/mBx8XvbvATrWXIK8iGsAUo2w52M=
=+Eyi
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Feb_2011_17_56_58_+1100_BLsajjsXe9AkcHzK--
