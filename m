Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1AJDNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 22:13:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55888 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab1AJDNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 22:13:01 -0500
Date: Mon, 10 Jan 2011 14:12:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philippe De Muyter <phdm@macqel.be>
Subject: linux-next: build failure after merge of the watchdog tree
Message-Id: <20110110141250.78947d61.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Jan_2011_14_12_50_+1100_yl4GBABhPkETLAWj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Jan_2011_14_12_50_+1100_yl4GBABhPkETLAWj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

After merging the watchdog tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/watchdog/m548x_wdt.c:31:26: error: asm/coldfire.h: No such file or =
directory
drivers/watchdog/m548x_wdt.c:32:26: error: asm/m548xsim.h: No such file or =
directory
drivers/watchdog/m548x_wdt.c:33:26: error: asm/m548xgpt.h: No such file or =
directory
drivers/watchdog/m548x_wdt.c: In function 'wdt_enable':
drivers/watchdog/m548x_wdt.c:47: error: implicit declaration of function '_=
_raw_readl'
drivers/watchdog/m548x_wdt.c:47: error: 'MCF_MBAR' undeclared (first use in=
 this function)
drivers/watchdog/m548x_wdt.c:47: error: (Each undeclared identifier is repo=
rted only once
drivers/watchdog/m548x_wdt.c:47: error: for each function it appears in.)
drivers/watchdog/m548x_wdt.c:47: error: 'MCF_GPT_GMS0' undeclared (first us=
e in this function)
drivers/watchdog/m548x_wdt.c:48: error: 'MCF_GPT_GMS_TMS_GPIO' undeclared (=
first use in this function)
drivers/watchdog/m548x_wdt.c:49: error: 'MCF_GPT_GMS_GPIO_MASK' undeclared =
(first use in this function)
drivers/watchdog/m548x_wdt.c:50: error: 'MCF_GPT_GMS_OD' undeclared (first =
use in this function)
drivers/watchdog/m548x_wdt.c:53: error: implicit declaration of function '_=
_raw_writel'
drivers/watchdog/m548x_wdt.c:54: error: implicit declaration of function 'M=
CF_GPT_GCIR_PRE'
drivers/watchdog/m548x_wdt.c:54: error: 'MCF_BUSCLK' undeclared (first use =
in this function)
drivers/watchdog/m548x_wdt.c:55: error: implicit declaration of function 'M=
CF_GPT_GCIR_CNT'
drivers/watchdog/m548x_wdt.c:55: error: 'MCF_GPT_GCIR0' undeclared (first u=
se in this function)
drivers/watchdog/m548x_wdt.c:56: error: implicit declaration of function 'M=
CF_GPT_GMS_OCPW'
drivers/watchdog/m548x_wdt.c:56: error: 'MCF_GPT_GMS_WDEN' undeclared (firs=
t use in this function)
drivers/watchdog/m548x_wdt.c:56: error: 'MCF_GPT_GMS_CE' undeclared (first =
use in this function)
drivers/watchdog/m548x_wdt.c: In function 'wdt_disable':
drivers/watchdog/m548x_wdt.c:65: error: 'MCF_MBAR' undeclared (first use in=
 this function)
drivers/watchdog/m548x_wdt.c:65: error: 'MCF_GPT_GMS0' undeclared (first us=
e in this function)
drivers/watchdog/m548x_wdt.c:66: error: 'MCF_GPT_GMS_WDEN' undeclared (firs=
t use in this function)
drivers/watchdog/m548x_wdt.c:66: error: 'MCF_GPT_GMS_CE' undeclared (first =
use in this function)
drivers/watchdog/m548x_wdt.c: In function 'wdt_keepalive':
drivers/watchdog/m548x_wdt.c:74: error: 'MCF_MBAR' undeclared (first use in=
 this function)
drivers/watchdog/m548x_wdt.c:74: error: 'MCF_GPT_GMS0' undeclared (first us=
e in this function)
drivers/watchdog/m548x_wdt.c: In function 'm548x_wdt_init':
drivers/watchdog/m548x_wdt.c:197: error: 'MCF_MBAR' undeclared (first use i=
n this function)
drivers/watchdog/m548x_wdt.c:197: error: 'MCF_GPT_GCIR0' undeclared (first =
use in this function)
drivers/watchdog/m548x_wdt.c: In function 'm548x_wdt_exit':
drivers/watchdog/m548x_wdt.c:211: error: 'MCF_MBAR' undeclared (first use i=
n this function)
drivers/watchdog/m548x_wdt.c:211: error: 'MCF_GPT_GCIR0' undeclared (first =
use in this function)

Caused by commit 91bb5dc5d42f400e18766f32a84ae585f61553a9 ("watchdog: Add
MCF548x watchdog driver").

I have used the watchdog tree from next-20110107 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Jan_2011_14_12_50_+1100_yl4GBABhPkETLAWj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNKnkyAAoJEDMEi1NhKgbs768IAJj60MIL8/vRNLafhFaJ0wKO
fbDbwoqbnVycIXHg+9fCO+siDfbftSRZbqzKH2AxFHGxDOO/D+GP7ThVDNxJ6mVN
g7/weZjcaNP5xjMYjuKkVm+XVUhIKnhjdkh1lb6TvPHFxdwWZKlwBDbmyV4xpLNE
z7gS1hwPkXSNQFBmEI1VtBaGXOqH8qoUUpCy20bHtJ6wHTO9Zqp5Z3+XDbOXwtsM
TvPYEj1vCO7rZ90JS+IqyUYIFDK08WifWWwueZuYzoKjC86Vs/zSy2HQGummIT9f
X3wyir4gQTs/vv8lSkmcnSyA6o+n3g4Cn8Q0Cy3A0TpO0LTlV+DfZ5I0E6d7/JM=
=XgKf
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Jan_2011_14_12_50_+1100_yl4GBABhPkETLAWj--
