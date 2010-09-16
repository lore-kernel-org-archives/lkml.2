Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0IPHXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:23:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33637 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab0IPHX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:23:29 -0400
Date: Thu, 16 Sep 2010 17:23:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: linux-next: build failure after merge of the final tree (mfd
 tree related)
Message-Id: <20100916172322.4f37e912.sfr@canb.auug.org.au>
In-Reply-To: <F45880696056844FA6A73F415B568C69532D96AC51@EXDCVYMBSTM006.EQ1STM.local>
References: <20100914134321.5eee798a.sfr@canb.auug.org.au>
	<F45880696056844FA6A73F415B568C69532D96AC51@EXDCVYMBSTM006.EQ1STM.local>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_17_23_22_+1000_F0Ih/9eYtQrJmb7z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_17_23_22_+1000_F0Ih/9eYtQrJmb7z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arun,

On Thu, 16 Sep 2010 09:15:22 +0200 Arun MURTHY <arun.murthy@stericsson.com>=
 wrote:
>
> > > After merging the final tree, today's linux-next build (powerpc
> > > allyesconfig) failed like this:
> > >
> > > drivers/mfd/built-in.o: In function `__crc_pwm_free':
> > > (*ABS*+0x24ba6d1e): multiple definition of `__crc_pwm_free'
> > > drivers/mfd/built-in.o: In function `.pwm_free':
> > > (.text+0x1ab3c): multiple definition of `.pwm_free'
> > > drivers/misc/built-in.o:(.text+0x2620c): first defined here
> > > drivers/mfd/built-in.o: In function `__crc_pwm_request':
> > > (*ABS*+0xc1f4ec93): multiple definition of `__crc_pwm_request'
> > > drivers/mfd/built-in.o: In function `__crc_pwm_enable':
> > > (*ABS*+0x9d09808d): multiple definition of `__crc_pwm_enable'
> > > drivers/mfd/built-in.o: In function `.pwm_enable':
> > > (.text+0x1abc8): multiple definition of `.pwm_enable'
> > > drivers/misc/built-in.o:(.text+0x26278): first defined here
> > > drivers/mfd/built-in.o: In function `.pwm_request':
> > > (.text+0x1a774): multiple definition of `.pwm_request'
> > > drivers/misc/built-in.o:(.text+0x2604c): first defined here
> > > drivers/mfd/built-in.o: In function `pwm_config':
> > > (.opd+0x1ce0): multiple definition of `pwm_config'
> > > drivers/misc/built-in.o:(.opd+0x3000): first defined here
> > > drivers/mfd/built-in.o: In function `pwm_free':
> > > (.opd+0x1d28): multiple definition of `pwm_free'
> > > drivers/misc/built-in.o:(.opd+0x2fd0): first defined here
> > > drivers/mfd/built-in.o: In function `pwm_request':
> > > (.opd+0x1cf8): multiple definition of `pwm_request'
> > > drivers/misc/built-in.o:(.opd+0x2f58): first defined here
> > > drivers/mfd/built-in.o: In function `__crc_pwm_disable':
> > > (*ABS*+0xb0493b18): multiple definition of `__crc_pwm_disable'
> > > drivers/mfd/built-in.o: In function `.pwm_disable':
> > > (.text+0x1aa24): multiple definition of `.pwm_disable'
> > > drivers/misc/built-in.o:(.text+0x2613c): first defined here
> > > drivers/mfd/built-in.o: In function `pwm_enable':
> > > (.opd+0x1d40): multiple definition of `pwm_enable'
> > > drivers/misc/built-in.o:(.opd+0x2fe8): first defined here
> > > drivers/mfd/built-in.o: In function `.pwm_config':
> > > (.text+0x1a648): multiple definition of `.pwm_config'
> > > drivers/misc/built-in.o:(.text+0x26358): first defined here
> > > drivers/mfd/built-in.o: In function `pwm_disable':
> > > (.opd+0x1d10): multiple definition of `pwm_disable'
> > > drivers/misc/built-in.o:(.opd+0x2fb8): first defined here
> > > drivers/mfd/built-in.o: In function `__crc_pwm_config':
> > > (*ABS*+0xc23f5b9): multiple definition of `__crc_pwm_config'
> > >
> > > Caused by commit 03f582a93ecca6e9584b622570022abf08ed03ec ("misc: Add
> > > ab8500 pwm driver").  I have reverted that commit for today.
> > >
> Please find the patch that fixes this build issue @=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/sameo/mfd-2.6.git;a=3Dcommit;=
h=3Df33bd494862cdc519db1f5d9b3f8214a1dd4c1ff

That patch was in the tree that produced the error above.  The patch you
quote is a fix for a different build problem.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_17_23_22_+1000_F0Ih/9eYtQrJmb7z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkcXqAAoJEDMEi1NhKgbslYYH/A2VQJoI4JV0Z5HF5ABydAzz
6yA7pwqkqv4yKmZyUFfl9dkyd9THwgoeWoUf/yQdLUXqjh5w6w3SCyKA7rqpyWOq
5CK977JWo2qTZnKxFWjKnCDPula2RZJvAzHvruMUE9rmTQnNpvV+FeLXhT6bTThY
1BZWiMcExZ0IbdHXMQ1kmfWeiIkbXJYBrxtfA00cnUoFTrXGF/sPrwLYFGcX4d6C
GPJuV1sPXaoo3BNCodFpnxw3ycDo1Ko+AOetquQLxocMMsqw6+UAWekPd61q798N
swtygHFIrTOvTnPxKI3rF4VWzApVai+HwvzSdNWibJevWjxcPSJeKhvytPUyikE=
=G4vX
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_17_23_22_+1000_F0Ih/9eYtQrJmb7z--
