Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1LSBG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 20:06:27 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:38993 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1LSBGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 20:06:24 -0500
Date: Mon, 19 Dec 2011 12:06:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20111219120613.2da854bacb6d6686248bb945@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_12_06_13_+1100_zutKDrF56Pn9od9d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_12_06_13_+1100_zutKDrF56Pn9od9d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/tracehook.h:51:0,
                 from arch/powerpc/kernel/ptrace.c:25:
include/linux/security.h: In function 'securityfs_create_dir':
include/linux/security.h:3003:2: error: implicit declaration of function 'E=
RR_PTR' [-Werror=3Dimplicit-function-declaration]
include/linux/security.h:3003:2: error: return makes pointer from integer w=
ithout a cast [-Werror]
include/linux/security.h: In function 'securityfs_create_file':
include/linux/security.h:3012:2: error: return makes pointer from integer w=
ithout a cast [-Werror]
In file included from include/linux/fs.h:2283:0,
                 from include/linux/trace_seq.h:4,
                 from include/linux/ftrace_event.h:5,
                 from include/trace/syscall.h:6,
                 from arch/powerpc/kernel/ptrace.c:32:
include/linux/err.h: At top level:
include/linux/err.h:22:35: error: conflicting types for 'ERR_PTR'
include/linux/security.h:3003:9: note: previous implicit declaration of 'ER=
R_PTR' was here

And many more similar.

Probably caused by commit 3073cb2e813c ("trim security.h") which
presumably removed an include file that was including err.h :-(

I have used the vfs tree from next-20111216 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Dec_2011_12_06_13_+1100_zutKDrF56Pn9od9d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7o4FAAoJEECxmPOUX5FEgh8P/1BTsmo9XcTH8iOF5BfW9kWo
XyVl+GSiUdzrQBNxr0bNYr+DYlRbsJ8rMO3NnhwfNFnMkvxIyNvuAlU2enqafNDH
xl/WlKoWOm+/yMRqSr+iVHRuiMawxK6/zFptkmibUVXfngPQKHnI18oH7+Sy4Ffm
92nPBvOiBQnGO2vtQNolo0eKuHQrWepBzCytpu8krBfhCgv2mlDiyYuQvtYysBZq
Q/rfGkYXFe1a1YnLCM8vp07gmmToODRERS36C1+1ZmkjV8ajPq0qBw+IDWDCTUaL
BbtVcaqfybVpoek36NNzCuU7ok0rKvL7TTE7H3ZJUeJkw/T9jD4V/gy6FGc6VE5e
N1B7x3rC/hqM4EjF9pmZP5GDj3nKBubUpnb8HjXHXviiwuu2mAL225SWvKtvyG+N
ZdzP0nA3aCuhIH8sgYzt7ZWLA7cknl3zvTQBPpd1sR5wbMki/WxZSgoPdv0LI0Yt
w9kfFu06MnrihJW2iwingc25+vrkbdUdcF/HGBNSoZxAwKIvszo1QyM07UPYJTtr
dAFclAjLfRJ8uSPIkvYBuxZJ/AU3beNl/8Wu2ZTgYhzn4+XLi+/PPC84fxtIemyf
UJD7ivSgrhzDDVlyAs/U4RdhwE50rJ32oLfvix6TTLtQx1WWn85XiV0DXOoaFQk/
CFA4NBRaz/YTxliePaZn
=kCa0
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_12_06_13_+1100_zutKDrF56Pn9od9d--
