Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2BTCj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:39:56 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35460 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2BTCjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:39:55 -0500
Date: Mon, 20 Feb 2012 13:39:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: build failure in Linus' tree with gcc 4.4.3
Message-Id: <20120220133936.936bff0d5817ac609a5211e0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_Feb_2012_13_39_36_+1100_V6kEvBUMPcLdO1/F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Feb_2012_13_39_36_+1100_V6kEvBUMPcLdO1/F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

My x86_64 allmodconfig build fail like this:

  OBJCOPY arch/x86/boot/vmlinux.bin
  AS      arch/x86/boot/header.o
  LD      arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/setup.bin
  BUILD   arch/x86/boot/bzImage
Setup is 14768 bytes (padded to 14848 bytes).
System is 4766 kB
/bin/sh: line 1: 20126 Segmentation fault      arch/x86/boot/tools/build ar=
ch/x86/boot/setup.bin arch/x86/boot/vmlinux.bin > arch/x86/boot/bzImage

I have bisected it down to commit
291f36325f9f252bd76ef5f603995f37e453fc60 ("x86, efi: EFI boot stub
support").  This may well be a compiler bug that this commit just happens
to poke.

The toolchain is PowerPC hosted cross tools:
x86_64-linux-gcc (GCC) 4.4.3
GNU ld (GNU Binutils) 2.20

I tried an allmodconfig build with my native compiler (gcc (Debian
4.6.2-14) 4.6.2, GNU gold (GNU Binutils for Debian 2.22) 1.11) and it
worked fine.

That is a large commit, so I am not sure where to go from here.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__20_Feb_2012_13_39_36_+1100_V6kEvBUMPcLdO1/F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPQbJoAAoJEECxmPOUX5FEaqAP/Atcpvuo7cL02arfOzSpOZay
UMCFxiNRTsfYnnG5IzVpcgzpQamuwnyd87ZCBs6kF5d/ipwk1zdepgZVNQFYY9HF
OUbo6xFNYo9yUGQIwpD/Hf5QA0aUBA6G5B69P7Sp1mNslkG99DXqsJ52Mn9/1iPg
DcBwXOGDW5BAa1mJP/0oenoVrvebxHZbvq3kDHfZ9ylBFlS0p87OjxB6Q8Uyx00W
oJuP2jqHDAjTSe24i5ybEwcPmMhIrpACaZX0PibDFcXI19R4JRape8uREkyIwfc5
gkmYwAq7zNidkgno+D3u/TDt4kczS2/DYe5jKtYFDak1/cMAMWJx4Xh5UrG502Qa
ChAJnNOVv4XaZLKyyAB9jGJnuYRS/gQgyviFLeQXZzJBQXX7YHO3e9hoWbsgMJH7
/PnDcMMU3LYxjNYtcWyT6CA9nimUuED2Pxi4roi7yR955YYowh93m4OUwLNQ4Ny2
XrIc+STSZkkMuH7EEv6WAJbF/COoc0eBpOI6Ix6fvVlz/8Dp/pGhmUhJuGojPdNm
R6j5dXLmmg6KTuPjnf/HnNFmhxHEoMJs2V9RMxH3aFteWDHdr9VPqoWjEvUeWhDl
EISjaD0FHo3PRUVX+UiT2iGYgB9nlKWny8WXVtw2q9OQpsIBeW+vGp+gxo/DKcIu
+SSVSfCYFwrTHP9aqfyw
=9EL6
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Feb_2012_13_39_36_+1100_V6kEvBUMPcLdO1/F--
