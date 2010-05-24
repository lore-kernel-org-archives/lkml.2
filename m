Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0EXDlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 23:41:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49876 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953Ab0EXDlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 23:41:11 -0400
Date: Mon, 24 May 2010 13:41:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <len.brown@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (acpi tree
 related)
Message-Id: <20100524134105.6bd4e82e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_May_2010_13_41_05_+1000_uIDiXSQk+GQ2NOvO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_May_2010_13_41_05_+1000_uIDiXSQk+GQ2NOvO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

processor_driver.c:(.init.text+0x290b): undefined reference to `intel_idle_=
load_first'

Caused by commit 08ce7f9d5851216a4726ba9bc54a12a7d9bad392 ("intel_idle:
create a native cpuidle driver for select intel processors") from the acpi
tree.

I reverted that commit for today. (which revealed a typo in the commit
before that one (2828bdc92eeea6e9c79ffcb430f4b67e4ebd1559 "ACPI: allow a
native cpuidle driver to displace ACPI") so I reverted that as well.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_May_2010_13_41_05_+1000_uIDiXSQk+GQ2NOvO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv59VEACgkQjjKRsyhoI8yXswCgg5M5z4rsy9C/oBGmbIEBLfmr
c5gAnAoY2mWpSKik5BPHksD4WBaljy8U
=ZwN9
-----END PGP SIGNATURE-----

--Signature=_Mon__24_May_2010_13_41_05_+1000_uIDiXSQk+GQ2NOvO--
