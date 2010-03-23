Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0CWGzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 02:55:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35849 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab0CWGzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 02:55:06 -0400
Date: Tue, 23 Mar 2010 17:54:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (input tree
 related)
Message-Id: <20100323175456.e01dd822.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Mar_2010_17_54_56_+1100_yUQQqjiTveTHeSIf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Mar_2010_17_54_56_+1100_yUQQqjiTveTHeSIf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

drivers/built-in.o: In function `sysrq_filter':
sysrq.c:(.text+0x224da): undefined reference to `fg_console'
sysrq.c:(.text+0x224e2): undefined reference to `fg_console'
sysrq.c:(.text+0x224f2): undefined reference to `vc_cons'
sysrq.c:(.text+0x224f6): undefined reference to `vc_cons'
drivers/built-in.o: In function `sysrq_disconnect':
sysrq.c:(.text+0x226e4): undefined reference to `input_close_device'
sysrq.c:(.text+0x226ec): undefined reference to `input_unregister_handle'
drivers/built-in.o: In function `sysrq_connect':
sysrq.c:(.text+0x22780): undefined reference to `input_register_handle'
sysrq.c:(.text+0x22790): undefined reference to `input_open_device'
sysrq.c:(.text+0x227f0): undefined reference to `input_unregister_handle'
drivers/built-in.o: In function `sysrq_toggle_support':
(.text+0x22b6c): undefined reference to `input_unregister_handler'
drivers/built-in.o: In function `sysrq_toggle_support':
(.text+0x22bac): undefined reference to `input_register_handler'
drivers/built-in.o: In function `sysrq_init':
sysrq.c:(.init.text+0x18d4): undefined reference to `input_register_handler'

Caused by commit edc6e384f9d96e54a6d03068d3b03fa5b56b6449 ("Input:
implement SysRq as a separate input handler").  This build does not have
CONFIG_HW_CONSOLE or CONFIG_INPUT set, but does have CONFIG_MAGIC_SYSRQ
set to 'y'.

For today, I have reverted that commit, commit
75394b382f16feddac9c523abf0eca8346afcf23 ("Input: keyboard - fix
formatting issues") which conflicted with the revert and the merge fixup
patch for the kgdb tree..

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Mar_2010_17_54_56_+1100_yUQQqjiTveTHeSIf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuoZcAACgkQjjKRsyhoI8ycZACfXFIROf/H8MMEGl8grB89yf3/
BjIAoLbQs9yHtCIm50dR/89WGENyIhvx
=wG8S
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Mar_2010_17_54_56_+1100_yUQQqjiTveTHeSIf--
