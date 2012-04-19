Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab2DSGfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:35:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40684 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2DSGfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:35:43 -0400
Date: Thu, 19 Apr 2012 16:35:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric B Munson <emunson@mgebm.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: linux-next: build failure after merge of the final tree (kvm-ppc
 tree related)
Message-Id: <20120419163535.52c99a34e2664063d654ac4d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Apr_2012_16_35_35_+1000_/2qZTjoJlpczuqUM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Apr_2012_16_35_35_+1000_/2qZTjoJlpczuqUM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

In file included from kernel/watchdog.c:27:0:
include/linux/kvm_para.h: In function 'kvm_para_has_feature':
include/linux/kvm_para.h:32:2: error: implicit declaration of function 'kvm=
_arch_para_features' [-Werror=3Dimplicit-function-declaration]

Caused by commit 5d1c0f4a80a6 ("watchdog: add check for suspended vm in
softlockup detector").  This build has no KVM related CONFIG options set.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__19_Apr_2012_16_35_35_+1000_/2qZTjoJlpczuqUM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPj7I3AAoJEECxmPOUX5FEjDAQAIrqabJ8YPUifZwuPhNlkB+J
I6DMOiYAg7JI9AZjEPM5NiYmXM+RTixpLDoJUzNKjonuOBH/uUVauNH0voyc98GX
v2zBfA9yud/Y50Umr/VJNSDd/y5DW/OHaCsc+Sx0oTh95iKcSzkJoX3AAjhejwLy
8Vy1NiBQxsvtfGd2yTl/9D2paKtq6Ll6fjhU07szI24fMkJWGmxRke6+NsIT+wFf
s9bHkBlWAxVEeozWX6TL9f5XxmhtDtHgidwst+AEbTmkhq5Oa0BPsF6G7iFOucwD
pKMjB4zP2wbEjzrSSmM/VOF7GFgMNwepw6qvVMypBIi44ZIq+Ml5CBJTgz5lq75H
5ikFe/rEVzb7DHev9NiZ/moJs9t21DkvF1hpMR5GGhn6t1FHvqVz2L9DURno/ozJ
t456HapGHJRCLSSnhtk0jyLAJ9FfZ+7wEg9/bDFVuoqqPANlL3m+bbhgG3eae/cO
ftkhBWueCCy3v8X+PCPaiD6/jOpdDKfaGA6m63VOcYz9pVQYUM3gHLYuf7olg4M/
d3yRST83WeV8Ny0AVHKzC9aHLZ+GmzY0IQJWw7EkgZsYLlDsziQRISvj9RmtPkZN
/Yfndim3vxR1+jWDbEKoiGiyHNSfUoWlrmUJcIHvF8mwNA5iywZFCLXz/0Q1nWvd
F3ShTw/Se0pxu2cgyQZf
=n5vH
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Apr_2012_16_35_35_+1000_/2qZTjoJlpczuqUM--
