Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab2BNEou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 23:44:50 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:51807 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401Ab2BNEo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 23:44:29 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: ranjith kumar <ranjithproxy@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: how to know list of files accessed
In-Reply-To: Your message of "Mon, 13 Feb 2012 13:32:56 +0100."
             <4F3902F8.3090905@free-electrons.com>
From: Valdis.Kletnieks@vt.edu
References: <CAG9fbzb=B66ku7bPWjJOZ7_EcShYqORypP8-hsvD-g7z9t4oHA@mail.gmail.com>
            <4F3902F8.3090905@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1329194664_3060P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Feb 2012 23:44:24 -0500
Message-ID: <8249.1329194664@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4F39E6AA.0039,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1329194664_3060P
Content-Type: text/plain; charset=us-ascii

On Mon, 13 Feb 2012 13:32:56 +0100, Michael Opdenacker said:

> An easy way is to run your command with 'strace' to trap all the calls
> to 'open':
>
> strace make 2>&1 | grep open

You really want 'strace -f make' - the -f flag makes it follow forks, which you
want to do because it's gcc that's doing most of the actual file I/O, not make.

Oh.  and you want to redirect that grep into a temporary file and be
prepared to post-process it with perl or something, there's going to be
*zillions* of open() syscalls.

--==_Exmh_1329194664_3060P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBTznmqAdmEQWDXROgAQLiQxAAmnOUy5jOeaieqUQ5XR/U32m0jmvEcgDu
qCVgMjqXXunubsKys0WDa3QXlJ1QQ2nFIeOzlYY3uaPFV669laKGNaXQKnQ6UHYH
+kmrW0x3DDZXkYPkyXFmvjRfCVhfl4SKuAj2HNAXPO69PE08gOz9Qm97vUbNyxOL
skkhdTSKfTiGCVwiGlnWpYw9Yf5bTEMERoDUODTXMXu5zL4RK8Ph8PXowjL6Qrv8
hBG0FZAR+lnoxi4bLJyJlO5yllLYsF07ItznIWCuCsS0MDIOxNrBqoQCc6bZVKdJ
rfFgmIzEz2MH9I1ov18UaBN0uJEdIM5SMXKWCjM1GLc0a74sPL73CIlDA7CoyFWT
sKRb1ioVopiePZBFdW43lCAYJEggUk9VU4dIBjt7ZKnlzxdfX+PXH8HmaMDdpCD8
KZr2bx5CyMK4XKTvxmjlQwZLC4CR0GLws0dHgB7T2zgNjr2QnM7J12yJEI9XOgCF
YISFDz7cxoGAC6clO/Bh7C/vkdCUzLWOXN6E/hhhKLcUQ/dcOMdWp+sHt5jp+EZL
aSyuRy89nYcQkgIQHJg43asb2va7OMwMaiTw/VANLpgQAQ+Rmdiv3Ju6FP1T7W7Z
4hT1m9isbkh6huYS3GWayFEds/W/h4Dz4U64z1kh/F0xFsi5VKfMOeVXoTiu5rYQ
tA/Zt/qSqYU=
=ai3u
-----END PGP SIGNATURE-----

--==_Exmh_1329194664_3060P--

