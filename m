Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1KCFcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 01:32:00 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:53154 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1KCFb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 01:31:59 -0400
Date: Thu, 3 Nov 2011 16:31:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sasha Levin <levinsasha928@gmail.com>, Pekka Enberg <penberg@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, Michal Marek <mmarek@suse.cz>
Subject: linux-next: manual merge of the kvmtool tree with the kbuild tree
Message-Id: <20111103163149.8a2de3ac55098adfe7e13c1d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Nov_2011_16_31_49_+1100_8B855=3TnOrZPj+4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Nov_2011_16_31_49_+1100_8B855=3TnOrZPj+4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvmtool tree got a conflict in
scripts/kconfig/Makefile between commit f597a718296e
("kconfig/streamline_config.pl: directly access LSMOD from the
environment") from the kbuild tree and commit 3b08ed02633d ("config: Add
'make kvmconfig'") from the kvmtool tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/kconfig/Makefile
index ba573fe,65580c2..0000000
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@@ -33,9 -33,21 +33,13 @@@ silentoldconfig: $(obj)/con
  	$(Q)mkdir -p include/generated
  	$< --$@ $(Kconfig)
 =20
+ kvmconfig:
+ 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/config -e KVMTOOL_TEST_ENABLE
+ 	@echo 'Kernel configuration modified to run as KVM guest.'
+=20
 -# if no path is given, then use src directory to find file
 -ifdef LSMOD
 -LSMOD_F :=3D $(LSMOD)
 -ifeq ($(findstring /,$(LSMOD)),)
 -  LSMOD_F :=3D $(objtree)/$(LSMOD)
 -endif
 -endif
 -
 -localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 +localyesconfig localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
  	$(Q)mkdir -p include/generated
 -	$(Q)perl $< $(srctree) $(Kconfig) $(LSMOD_F) > .tmp.config
 +	$(Q)perl $< --$@ $(srctree) $(Kconfig) > .tmp.config
  	$(Q)if [ -f .config ]; then 					\
  			cmp -s .tmp.config .config ||			\
  			(mv -f .config .config.old.1;			\

--Signature=_Thu__3_Nov_2011_16_31_49_+1100_8B855=3TnOrZPj+4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsidFAAoJEECxmPOUX5FEBUcP/3W2IXsjGQG8Z5DekAV3zE7K
jEsm/R1CqWxCpjZq5Cmnm5oETmY1A5FbmREJckQ18xGIIBkCtBf98u+m+jiJ+7Jg
/r9pl1ajqgxAT87vwYX+KeGMVTCvKsfnDSJahTdsRuZaWKM6sF0cVJosiVnbpw6C
ZRgbQsoAFJcN4vOZ9kurtw9+Byx54YBMqI/77vtZim5fu4gn3kZt1VizD8rYxjbi
FZ5mkGOu9RbCSQg/8a+t9oMe5rScsRzEy8FH/CiYpdQ0r2UZpwOG0PGIVqWd/ye4
4H8bQc5eaRvlpwNdzVcLyWAMXOnqrhJRwsPCeEGucoF3G5Jj9DMtKVvxbu2scdYs
AB2DBJTRpFWwpePbEaB496anXrp2k35dX6kDeVlaf0ImKMUIgJU0Ls6UEwM0pDQ4
YIhuG/FmhKdq6bTgeXF4qwmVlEOwfnMX4pyuHu5wemmos7NJ53MzjbexMUBCc+mN
3/sqqPssee3vRPFzvDPUnhNGx9Q7fV330qTAdVMdLKYDXEx9lStfTmLfAcBobidY
wIHMa0ztAV2sNrStUu3L3EsSk9MgzBjPVR9UPwHQg2vKziUlRISC+NNlYIjVgJAS
0pdd7WUlCqkgcLhKYpXPVBegAxkZKGCXH3dv/P6kdmxSgQfFsWtz1s7HMzBoAJLJ
EcICe61cSru8TumX5PXO
=5VTf
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Nov_2011_16_31_49_+1100_8B855=3TnOrZPj+4--
