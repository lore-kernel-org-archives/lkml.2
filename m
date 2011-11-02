Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1KBIQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 04:16:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21072 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1KBIQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 04:16:24 -0400
Date: Wed, 2 Nov 2011 11:16:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: re: [SCSI] compat_ioct: fix bsg SG_IO
Message-ID: <20111102081642.GD4751@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2Z2K0IlrPCVsbNpk"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4EB0FC4B.00A6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

84eb8fb42c120 "[SCSI] compat_ioct: fix bsg SG_IO" introduces an
uninitialized variable use.

   278  static int sg_ioctl_trans(unsigned int fd, unsigned int cmd,
   279                          sg_io_hdr32_t __user *sgio32)
   280  {
   281          sg_io_hdr_t __user *sgio;
   282          u16 iovec_count;
   283          u32 data;
   284          void __user *dxferp;
   285          int err;
   286          int interface_id;
   287 =20
   288          if (get_user(interface_id, &sgio32->interface_id))
                                            ^^^^^^
sgio32 is unitialized here.  Unfortunately Gcc doesn't warn about it.

   289                  return -EFAULT;
   290          if (interface_id !=3D 'S')
   291                  return sys_ioctl(fd, cmd, (unsigned long)sgio32);

regards,
dan carpenter

--2Z2K0IlrPCVsbNpk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsPxpAAoJEOnZkXI/YHqRpH4QAJKBnxS4xKj+3yAoMHuqnoLz
m22f4V7BQBecfitjT0yoGtain68Vp880p7goRjTX9jkwkRYzMNl7DyNqvUVYCx2h
vbtakAea+Vk70Q0DgG/MdX0OIVKO3uSehEDRi0oi4ALJOuxH0T/xa5kFOMVrkx4A
6TPgYuONbdw2uueJKmjryRTwUwrhBjRh33Furx8J4p31eAoJskOH6U0cY3ZlUEzS
Fema/3E0TnJ02Q5Kp2YupiZHmkUwCOfHvUSyccR82Hyhza+WzuMqxONpdQSgfErC
Qu5Oqwph4mNg5ik90DVooPbajUiUWzjYM2nO4g+zLhJcsi9lRERe2i/OUvGE4D97
b16awlS/QzWm/Xvt6hx6MvGtNyeDmYkpN9PLz5nR59fwOrcHXsu/VfSmLlnqsqvd
XU4dGtdJIV7tXIz+q8s/bTS2A2g338gEPSg/zkU0GxhKUOLfblhCsLCFOQvdzzbB
QAg2AkVXFxoKTUCGThL1c2xFtEfFx8AbrHcYghRpH8TRu6ftSjNWdFIngjUyjqkX
pGQPRXYb6/iLYPikOho4pAkh018GceYClq7wLLcw7cXrpUYispQk3NpYhNONVZz5
nkISW7JF1OYwsgDCSbCgIHBGD3PaET04TAino+JRO/KOdgc0gzG2cELM4gN7wmVi
iPTeNPRWDw9zZAQN5tPK
=SIw6
-----END PGP SIGNATURE-----

--2Z2K0IlrPCVsbNpk--
