Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab0DCRCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 13:02:01 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54133 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab0DCRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 13:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type;
        b=VS6K6FMZHYtxr/rhjiMdx8Cxu8s2xHetoZEQjNtfCFsxjhmEtb3EbfXFHpLQlbc9Zu
         p6T6zsoD2UkfesrMqE871E0mGxK0akp5Crtq+XC0SZAPtDK2nFG9Kd3bI3WEiGbr+krY
         BHWFpaUxDnmMKXv9YL2UF1lDN43Bj+uApPtt4=
Message-ID: <4BB77475.5060202@gmail.com>
Date: Sat, 03 Apr 2010 19:01:41 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       The development of GRUB 2 <grub-devel@gnu.org>
Subject: [RFC] Multiboot2 drafting
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig97EA04DA4280860CFADA8F8F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig97EA04DA4280860CFADA8F8F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello, all. In GRUB2 community we're currently working on a
next-generation multiboot specification. It has goals similar to the
original multiboot specification but with important flaws fixed:
1) Instead of having bunch of pointers to subtables it uses a tagged
structure now. It allows it to be easier expandable, consume less space
if some fields aren't used and is easier to relocate.
2) Now it's portable. It has fields for specification of architecture
and proper field alignment. So now adding a new arcitecture is as easy
as adding a new arcitecture id and a section dealing with
architecture-specific problems like register usage to pass information.
Currently it has only i386 and mips though. Both are implemented in bzr
trunk grub[1]
Short summary:
Multiboot specification is done as an unified protocol between
bootloader and kernel to allow supporting more kernels and bootloaders
with less effort. The easiest way to use it is to create an ELF image
with an additional header which announces multiboot support and specific
kernel requirements. But it's also possible to put loading address in
multiboot header and use a non-ELF format.
When image is loaded one of GPRs contaians a magic number to identify
that kernel was loaded as multiboot and another GPR contains a pointer
to information table. The most needed information is already there, more
is in review progress, and if you feel like we're missing somethin feel
free to contact.
Complete specification is available at
http://bzr.savannah.gnu.org/r/grub/branches/multiboot2/ or at
http://download.savannah.gnu.org/releases-noredirect/grub/phcoder/multibo=
ot.pdf

Some advantages:
1) Removes the need to support a fundamentaly different boot protocol
for every architecture. In future it may even be possible to have just
one image per ISA and rely on information supplied by bootloader to
differentiate between platforms (it doesn't prevent creation of an image
optimised for one platform)
2) Better collaboration between bootloaders and kernels by avoiding to
implement "one protocol per kernel".
3) Possibility to inform bootloader of exact kernel requirements and
supported features.
4) Uniform interface for retrieving e.g. memory map and initial console
info across platforms.
<Anything else you request ;)>

Any comment about multiboot2 spec is welcome.

Would it be possible for Linux in perspective to use multiboot2 instead
or in addition to current protocols?

Thanks for your time.

[1] Available with
bzr co --lightweight http://bzr.savannah.gnu.org/r/grub/trunk/grub/
or as a tarball at
http://download.savannah.gnu.org/releases-noredirect/grub/phcoder/grub-r2=
283.tgz

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



--------------enig97EA04DA4280860CFADA8F8F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iF4EAREKAAYFAku3dHwACgkQNak7dOguQgmgcAEAs+LCRvUFUpNvQDE/UuKusMh4
+0Lla7fT6li+swx/OhIBALRBFpYWEyQxktACNdqFjmR2PS3c+5u0m3RMKQmRPnSB
=aw/f
-----END PGP SIGNATURE-----

--------------enig97EA04DA4280860CFADA8F8F--
