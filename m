Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2JMBEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 21:04:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42298 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2JMBEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 21:04:52 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Rusty Russell <rusty@rustcorp.com.au>, David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: CONFIG_MODULE_SIG breaks out-of-tree modules in modpost.
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1350090284_2902P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Oct 2012 21:04:45 -0400
Message-ID: <6862.1350090285@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.5078BE2D.007F,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1350090284_2902P
Content-Type: text/plain; charset=us-ascii

For starters, yes, I *do* understand the security issues involved, and
no, I *don't* want to hear about NVidia evilness, because this looks like
a modpost problem not an NVidia problem.

I built next-20121011 with CONFIG_MODULE_SIG=y, and MODULE_SIG_FORCE=n,
so that I could test the feature, and just accept that the nvidia module was going
to hand me 2 taints instead of one.

But then, building the NVidia module a wondrous thing happened, and it threw a
most inexplicable error:

  cp /usr/src/valdis/NVIDIA-Linux-x86_64-304.51/kernel/nvidia.ko.unsigned /usr/src/valdis/NVIDIA-Linux-x86_64-304.51/kernel/nvidia.ko.stripped && strip -x -g /usr/src/valdis/NVIDIA-Linux-x86_64-304.51/kernel/nvidia.ko.stripped && /usr/bin/eu-strip /usr/src/valdis/NVIDIA-Linux-x86_64-304.51/kernel/nvidia.ko.stripped
/bin/sh: -c: line 0: syntax error near unexpected token `;'
/bin/sh: -c: line 0: `set -e;  ; echo 'cmd_/usr/src/valdis/NVIDIA-Linux-x86_64-304.51/kernel/nvidia.ko := ' > /usr/src/valdis/NVIDIA-Linux-x86_64-304.51/kernel/.nvidia.ko.cmd'

Looks like somebody left a $(FOO) unset between the 2 ';' characters.  I wasn't
able to follow the way scripts/Makefile.modpost worked well enough to figure out
where that line gets built, there's way too many 'set -e' in the scripts/ tree.

Building with MODULE_SIG=n made it build just fine.

This *MAY* be related to this RedHat bug: https://bugzilla.redhat.com/show_bug.cgi?id=655231


--==_Exmh_1350090284_2902P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUHi+LAdmEQWDXROgAQIY2xAAhL90PZfDy9l9Kkq9fvBpLtpDyPmA2hmh
PqYT+kHq+omp18//qgZyCBxm0r+Qn0SdzztxG+Sf+5N5qBOzp4OTBq3IRN9xZQw+
NqgsCN48Pd0lfFTADiXdx+f2jSWu4wnB7HHOT3FKVsJz3C9Rt8RdXYIrt0zySOJH
F0iZNQqT1/mn1nj84uUR2hCndllAIJOTdebivmsHZbjEzk5oLOXhwaHznCLZm/Zo
gZPAX4Vo8tPTf7VS+jJ1gNKEzQDQyQT1RqaD/bL9afsVo3s8f24eYxkg4LjaIRSo
oCsZBwrwk+zNrY2vzu8qYZVaKjW36/sAS/AHEFhI+0h3VSgfIaxNDy6BbMNCpMcz
xIH9airL0VSIABlParVbTmVxzknGPFrzUTc1GsIEk3cw0ggg8/kLPxi/4QAg9XDa
sNQS+oxXL48x4te6nhv97YTD+YMormeoaNbKWs3d9e7ZU5bRB8OF2evglNqFSdeK
aA89yWVY5u1zidtTAuY1yNdEKFp4pFR7D2O0ckWiuwUjbJUihdv494rDA3ZCTeWJ
7HClfJaAngJ8HEjyk7u+hEfDHmlD/66Zo00AKOGlAx3dxJDvA3fjR/lrU4HUuCHI
5ZNbPu6QcU9Lg7vzGc78rFmPE474NK2uIgXbIb0C1yEatIB+V38a0KX9V++iji9u
+RtBhg6nC2k=
=R0ul
-----END PGP SIGNATURE-----

--==_Exmh_1350090284_2902P--

