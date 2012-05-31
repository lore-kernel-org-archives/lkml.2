Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab2EaXQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 19:16:41 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:38183 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2EaXQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 19:16:40 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: linux-kernel@vger.kernel.org
Subject: Tracking down a compiler bug - any hints?
From: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1338505784_2076P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 31 May 2012 19:09:44 -0400
Message-ID: <19719.1338505784@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.213.180 mail-yx0-f180.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4FC7FBD7.00A5,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1338505784_2076P
Content-Type: text/plain; charset=us-ascii

So I had a nicely working kernel at 3.3.0-rc6-next-20120305.

I got distracted for a while, so the next kernel I built was
3.4.0-next-20120523. This locked up on me good and solid when it tried to
launch X. No panic, no dmesg, nothing on netconsole, just a fast and deadly
freeze that required holding down the power button to clear.  Been there, done
that, time to break out the bisect.  'git bisect bad next-20120523', 'git
bisect good 3.3-rc6' and go to it. And I got like 8 bisects in a row that locked
up.  Even worse, all 95 or so commits that were left were included in
next-20120305.

Then I tried rebuilding next-20120305 using the exact same config I
had working (zcat /proc/config.gz > .config) - *THAT* kernel locked up.

This is when I noticed that my working kernel was compiled with gcc 4.6.2,
and all the busted ones were compiled with 4.7.0.  Backleveled to 4.6.2,
and both next-20120305 and next-20120523 build and boot just fine.

So obviously something is skunky with 4.7.0.  But where do I go from here?

(Side note - I'd love to get this resolved, as currently my laptop is in a semi-screwed
state due to RPM hell - backleveling gcc required backleveling glibc, and several
other packages, and some stuff is still busted because I didn't backlevel *them*.
It's amazing how many packages link against 'gmp' for no obvious reason :)


--==_Exmh_1338505784_2076P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT8f6NwdmEQWDXROgAQLg4w/9F1faOULNdDokQr8enhej7MXyiKxrK4+G
fMXDZq2nA3SURXd2Um2tcH1VUpRGON0gT3Y/AG26oVdu9jb0JGb0Y9CtM4AouA9E
ib/HPBeL+OYRtwiCEq4xz4EtXJ8TEqtPf7v/AIikuhPSjr2EkGBTA3Q1kQXrcXqV
MLbYp+GlEjItjVYQHldFGkVH4YN+1GULBatwjIL/WcQIL8YbXl0835DG326WgzCM
+5w2m40FnfFt2I6DL29WiN1yz4ks3+xiZTD/POPFUbIPl5BoxBeM+dLvNpG+RBMI
NYuHO8wY9GGFTMgTe7FYIdHq9vTzf5KCvHGDxtLwkgasog/iKWlp8YMjUROHau/E
eOtPjJya3UVvDFar8Q04OngPdvb+/Wyojrb/4UwyCuGyu5HfzdgaOafzLDAg27aR
1Kkbc74QlnnMhJ+XAK06v98A+O2wu26aBY+eI2bVsDZSm1Z3Hr3UQE3AMQ2Rhji8
OfThsm/TniKINzvrnaJEadzCCqhtKaZjES6ZawoGoLGZZ2gcc678jGljIJrHvod3
u77c99k/BDlEXJ4y+D27vqMjrKeksR09BF4B8HFI/e7mqbzTpuyxIytgyOUxRAV2
i8U+znTIoUplgezru1sZeV1tM8FIcecxxMpEi+0ON9kuE6SETJLNVgJksCGYjyUR
u6xR7JZF0I8=
=Dy+V
-----END PGP SIGNATURE-----

--==_Exmh_1338505784_2076P--

