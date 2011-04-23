Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab1DWGoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 02:44:15 -0400
Received: from csamuel.org ([74.50.50.137]:52960 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab1DWGoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 02:44:11 -0400
From: Chris Samuel <chris@csamuel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sat, 23 Apr 2011 16:43:54 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Yuhong Bao <yuhongbao_386@hotmail.com>, alan@lxorguk.ukuu.org.uk,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <201104222333.25546.chris@csamuel.org> <SNT125-W638277FA9F3B49B316DC9FC3940@phx.gbl> <4DB2338B.5030803@zytor.com>
In-Reply-To: <4DB2338B.5030803@zytor.com>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@^SdaXtmdYGRq
	[>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<{n8m;X_
	g\Y9LQ=v/b5`)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)F!1M3=w:i9MsWp&v;%usOXL;w
	6kF?wAZjss.+y(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4547147.4u6aIfrnPL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104231643.55372.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4547147.4u6aIfrnPL
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Apr 2011 12:03:55 PM H. Peter Anvin wrote:

> I suspect this broke during the rewrite of the setup code to
> C in 2007.

Looking at arch/x86/boot/memory.c I see the snipped:

        } else {
                /*
                 * This ignores memory above 16MB if we have a memory
                 * hole there.  If someone actually finds a machine
                 * with a memory hole at 16MB and no support for
                 * 0E820h they should probably generate a fake e820
                 * map.
                 */
                boot_params.alt_mem_k =3D oreg.ax;
        }

Could this be what's going on ?  Or am I just grasping at straws ? :-)

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart4547147.4u6aIfrnPL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbJ1K41yjaOTJg85AQJ0iQf8CrtCpTG8/1P3EfDvZ1RV3G5nmnCH+kSE
5VSaJGQO1vvWGUN5MpRveX7QcBWyQd2GK+xxld/5X/Cgw3ZLUH2ljFprIhiLdCBH
mAgIVgkluriPJ/TkLtwDw2ZAcuWL5e74duGmjTaMXxJAuY4P+n6Db0P2TicX2/FG
hy5TMPz19jlKhsnfovu0mj8IiauXPsHVuhs/TEN7OQ0l6JMZF9rcgidGMBqairWZ
Awf/mNzWhDue6zHjYYVngOuHJU4e+9y16V7/sXaiNdU72md3wG9GEI1wvJesJp0p
p1vKyDjQSJuvEKGHnHKvoDc1H3aOArBcG7Fvsz0QkO7rgEei+zCQIA==
=pliA
-----END PGP SIGNATURE-----

--nextPart4547147.4u6aIfrnPL--
