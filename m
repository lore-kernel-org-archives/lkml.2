Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab1LQFCu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 00:02:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab1LQFCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 00:02:44 -0500
Date: Sat, 17 Dec 2011 16:02:28 +1100
From: NeilBrown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-ID: <20111217160228.3a946f4b@notabene.brown>
In-Reply-To: <20111217154219.5f3d476c25e648b1b4239857@canb.auug.org.au>
References: <20111217154219.5f3d476c25e648b1b4239857@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JxugTYmFfFTVMjaJjdK45Rb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/JxugTYmFfFTVMjaJjdK45Rb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 17 Dec 2011 15:42:19 +1100 Stephen Rothwell <sfr@canb.auug.org.au>
wrote:

> Hi all,
>=20
> After merging the final tree, today's linux-next build (m68k allmodconfig)
> failed like this:
>=20
> drivers/leds/leds-tca6507.c:158: error: field 'gpio' has incomplete type
> drivers/leds/leds-tca6507.c: In function 'tca6507_gpio_set_value':
> drivers/leds/leds-tca6507.c:534: warning: type defaults to 'int' in decla=
ration of '__mptr'
> drivers/leds/leds-tca6507.c:534: warning: initialization from incompatibl=
e pointer type
> drivers/leds/leds-tca6507.c: In function 'tca6507_probe':
> drivers/leds/leds-tca6507.c:618: error: implicit declaration of function =
'gpiochip_add'
> drivers/leds/leds-tca6507.c: In function 'tca6507_remove':
> drivers/leds/leds-tca6507.c:651: error: implicit declaration of function =
'gpiochip_remove'
>=20
> Caused by commit 7a9244d89523 ("leds: add driver for TCA6507 LED controll=
er").
>=20
> Maybe this driver needs some dependencies ...

Yes... I think it actually needs the 'gpio' aspect of the driver to be
dependant of GPIOLIB being available.

I'll get a patch or two off to Andrew on Monday.

Thanks,
NeilBrown

--Sig_/JxugTYmFfFTVMjaJjdK45Rb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuwiZDnsnt1WYoG5AQIH4BAAtbZ8jDc2NBQ059HCvm11HemZy9WKfcfM
k4905I1oU2mdQ4BqZ0xSG8j+BHDTvHUsJ422CWT5P55NbFhejiRhRk1a71UwX2uU
lrPHa/Ih0IDJxa5t+AC6DK8AgM5uzmQPMmL9OtNGmhSFtQYERy/qBLOSV2t8c+cW
QV5qHmVEbA7I9BTUSn1cTxvUOeW31pWSgmjIvHJ9A04o22xerco7Pf99969jN3Xx
By/Cxr5kBbDhT/371cdDjG/o/7C7Pl866JKkSuT2nIGQ9v9np5IIkTHMcRxGUvBs
VPuvUonKh89gcaLRF1RLFMjv3qq80Bfyty6Gw0junXHeDwe9jsJDVM1bBfdsQNgB
ydJmy2WHs0UDo8mtox++5mJOVIIm2CZgxIGXNfZri5VkljoxzzVD128oTmNnUZQ6
wSzhblRSyXQhAdBKZC/hzJb1LaCqN6x9b+2NOn+6rYOUxoWONdbRjQGQCJgOwbiK
tguM4uah7Ex0e/2vPegFmj6PgpHibMO1UuxaGyj2/BWlZobzVSEPTo6gV9S5ETY7
XQcwq2FSELLCCxFq1Zeqem84eQafGSvLF98u8l/gccPMKHKdCgq59BiwMi87oKqV
oxKKYqL7nbE0t1ykp85ZAJbDI2bK2ANFJLJU1+rWKXhkCFICXNYnQ/67bakDcv1q
sd2/jR1f3D4=
=t4Jc
-----END PGP SIGNATURE-----

--Sig_/JxugTYmFfFTVMjaJjdK45Rb--
