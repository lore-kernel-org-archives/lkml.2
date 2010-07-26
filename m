Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0GZF3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 01:29:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35448 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab0GZF3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 01:29:18 -0400
Date: Mon, 26 Jul 2010 15:29:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sheng Yang <sheng@linux.intel.com>
Subject: linux-next: build failure after merge of the final tree (xen tree
 related)
Message-Id: <20100726152908.951a95b7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__26_Jul_2010_15_29_08_+1000_faYTzoTLvToPiG0m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Jul_2010_15_29_08_+1000_faYTzoTLvToPiG0m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

arch/x86/built-in.o: In function `init_hypervisor_platform':
(.init.text+0x3ca4): undefined reference to `x86_hyper_xen_hvm'
arch/x86/built-in.o: In function `init_hypervisor_platform':
(.init.text+0x3cad): undefined reference to `x86_hyper_xen_hvm'

Caused by commit bee6ab53e652a414af20392899879b58cd80d033 ("x86: early PV
on HVM features initialization").

I reverted commit 4b9100d12d15c0eaf23d9edc86228e1bdf452dc2 ("Merge branch
'upstream/pvhvm' into upstream/xen") for today (since there were
dependencies on the above commit).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Jul_2010_15_29_08_+1000_faYTzoTLvToPiG0m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMTR0kAAoJEDMEi1NhKgbsgKUH/0guGh1ynWmgFpcXqz/4vhJO
QvWgeG4+2Jrztq8Le20yZgoGQQM8wb8VpnI5t4iowMtbVUTc3tnEJiQM2KuGRD67
q5zj9o//lZz6AHJOvS35M+Myy5NCuCsI/d85mT2lmhZxKScG1Jpmd8C2tBDCIYk2
rn52t6eO0EP4How3RmPNj7DyhmjyQFVDyHtB68C2ZqecOF8yfyFsviy6ha/hKaoZ
c9vIiyMdHZ/cdulTgxUTpSm3OOATqJlj2hWQDAVpAxgfLg1CMiSU30XR5UI2Uzd4
350rVMiTBA0XZATPmuiw1vMoTAZP/I0iR5f2UtouDvCb55IOg66QtoZ6YIBbhmQ=
=boJ1
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Jul_2010_15_29_08_+1000_faYTzoTLvToPiG0m--
