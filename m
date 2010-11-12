Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0KLB6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 20:58:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41769 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab0KLB6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 20:58:00 -0500
Date: Fri, 12 Nov 2010 12:57:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russ Gorby <richardx.r.gorby@intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the final tree (tty tree
 related)
Message-Id: <20101112125751.7f364d58.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Nov_2010_12_57_51_+1100_8xoS=YtTgE86SAiz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Nov_2010_12_57_51_+1100_8xoS=YtTgE86SAiz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/serial/ifx6x60.c: In function 'ifx_spi_reset':
drivers/serial/ifx6x60.c:928: error: implicit declaration of function 'msle=
ep'

Caused by commit af3b8881f4c9852eefe9c7f1a997b3ecf580561b ("ifx6x60: SPI
protocol driver for Infineon 6x60 modem").  An include is missing
(linux/delay.h).  See Rule 1 in Documentation/SubmitChecklist.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Nov_2010_12_57_51_+1100_8xoS=YtTgE86SAiz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM3J8fAAoJEDMEi1NhKgbs/9wH/j7bihjQ6fMdQI5Jar8z9eny
AudVgRiGqVx5SIhnRS02VUIySuZpcPCwjPewY1LTqLcH68xfE1gJYyKtnbLRcc7q
ZZsZ4jvJai7dsuqqu/hzdZe5HLWvlJJsVqVFHbRRZglFiBsC8BEppaeOmu/8JiFH
Optzsuvdu/SIxNWwYWiWTaxb2D6Hd7VJrfE7Mc5GPl0dqnAFnjAVtwD+d4TEwgr0
7Wqfh9C/pzRzIQ+3iA9opqmg50iF5jzHEl9LZ66yXjhjCPM8LHyRhKrUoBNzKUwU
ikEwbVVQgBZ7JQZoqmN+uL+Qe0eBDvWTldfvj+9dm5krDyVW9ddtxxx+0Yh16j4=
=N5F7
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Nov_2010_12_57_51_+1100_8xoS=YtTgE86SAiz--
