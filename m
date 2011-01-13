Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab1AMXvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 18:51:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57631 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab1AMXva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 18:51:30 -0500
Date: Fri, 14 Jan 2011 10:51:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@secretlab.ca>
Subject: linux-next: build warning in Linus' tree
Message-Id: <20110114105123.b05b4dcc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__14_Jan_2011_10_51_23_+1100_BG2A.hIDlRtb9i/G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Jan_2011_10_51_23_+1100_BG2A.hIDlRtb9i/G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

While building Linus' tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

drivers/gpio/timbgpio.c: In function 'timbgpio_irq':
drivers/gpio/timbgpio.c:202: warning: passing argument 1 of 'irq_get_irq_da=
ta' makes integer from pointer without a cast
include/linux/irq.h:345: note: expected 'unsigned int' but argument is of t=
ype 'struct irq_data *'
drivers/gpio/timbgpio.c:202: warning: passing argument 1 of 'desc-><U be0>.=
irq_data.chip->ack' makes integer from pointer without a cast
drivers/gpio/timbgpio.c:202: note: expected 'unsigned int' but argument is =
of type 'struct irq_data *'
drivers/gpio/timbgpio.c: In function 'timbgpio_probe':
drivers/gpio/timbgpio.c:303: warning: passing argument 2 of 'set_irq_chaine=
d_handler' from incompatible pointer type
include/linux/irq.h:294: note: expected 'irq_flow_handler_t' but argument i=
s of type 'void (*)(struct irq_data *, struct irq_desc *)'

Introduced by commit a1f5f22adc3206c47e70652c12671666c65b579f ("gpio:
timbgpio: irq_data conversion").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Jan_2011_10_51_23_+1100_BG2A.hIDlRtb9i/G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNL4/7AAoJEDMEi1NhKgbsXvUIAIVlc3rvsEUG8P1O1sPMsCdo
S+mafWtUSIB9OtAIKmzjy2wHjSm5HSfV5lYTDrnCj0T29/s0u5ea7qr0fLRJWdKZ
3rh4yBUhQu2VzT7ILecT0QWmvaocrHFwVyIbagJbnjtovOPAaRZCePhuiX0OcIwL
KKWATQ0b5Fb2zmmE++U8z9w+xPtvLO4Wl3tUGHEB35mXQc+wLuPx36QSIK2C+lSu
XEgT8cKNo4goSf+0O6wb8n6W58cXTvnZQ9QNRLIxWSj4WZxn1p2GYi3E8DWNiMj7
SXhdVhotyH+UrkxKBIulB1mxqrPwxa23RgVERWDlmZdNKs7/kb+ueDGeCM3lETA=
=fb1s
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Jan_2011_10_51_23_+1100_BG2A.hIDlRtb9i/G--
