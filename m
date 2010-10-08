Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0JHAtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:49:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34143 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab0JHAtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:49:51 -0400
Date: Fri, 8 Oct 2010 11:49:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the v4l-dvb tree
Message-Id: <20101008114945.636093c9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Oct_2010_11_49_45_+1100_EQVUAfD6T9Vx6qFI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Oct_2010_11_49_45_+1100_EQVUAfD6T9Vx6qFI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/media/video/videobuf-dma-sg.c: In function 'videobuf_pages_to_sg':
drivers/media/video/videobuf-dma-sg.c:119: warning: comparison of distinct =
pointer types lacks a cast
drivers/media/video/videobuf-dma-sg.c:120: warning: comparison of distinct =
pointer types lacks a cast

Commit ecc736735ecf922d7f31d34417f7c42f8ec9eb67 ("V4L/DVB:
videobuf-dma-sg: Fix a warning due to the usage of min(PAGE_SIZE, arg)")
tried to fix it (presumably on a 32 bit build), but is not correct for 64
bits .

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Oct_2010_11_49_45_+1100_EQVUAfD6T9Vx6qFI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMrmqpAAoJEDMEi1NhKgbsC48H+wdRJkpbnT9gmBTHN4nAgEXf
o4EAh882DNNsNa8/Zh4sQr3XJiOPC7kmrmOZNU6992qmSiDBx2DRvghvEsiM1Mye
judhFJlQpzqXsJPejrPa7Xst5gKp4N7gEPGSUxn5HwB12YrEUhkBtIqRK1MYyPYU
f4M9H3uPAjS8BR8KUE8CQ06Acf9LkG6OS5/BtZxo6wpotTdhR6+mdx+T/Nn2wTCc
l3UAr4iDmAZi+vAjPc1Pe0lWqSAtaODM10xysZZgYkeqBpfBxfvxvu1225hHF4KK
EN1ONEewxgG1fk/nSBbR3fYcCzLlBOlqW3H+oRmH2IWcPIitTseLApAHRdUyTNc=
=hanX
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Oct_2010_11_49_45_+1100_EQVUAfD6T9Vx6qFI--
