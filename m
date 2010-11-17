Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187Ab0KQCPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:15:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34770 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933804Ab0KQCO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:14:58 -0500
Date: Wed, 17 Nov 2010 13:14:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: build failure after merge of the usb tree
Message-Id: <20101117131453.5b94f435.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Nov_2010_13_14_53_+1100_PqR6Q.g9KMYTB_9+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Nov_2010_13_14_53_+1100_PqR6Q.g9KMYTB_9+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/media/video/tlg2300/pd-main.c: In function 'poseidon_probe':
drivers/media/video/tlg2300/pd-main.c:455: error: 'struct usb_device' has n=
o member named 'autosuspend_delay'
drivers/net/wimax/i2400m/usb.c: In function 'i2400mu_probe':
drivers/net/wimax/i2400m/usb.c:517: error: 'struct usb_device' has no membe=
r named 'autosuspend_delay'

Caused by commit fcc4a01eb8661226e80632327673f67bf6a5840b ("USB: use the
runtime-PM autosuspend implementation").  More grepping required ...

I have used the usb tree from next-20101116 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__17_Nov_2010_13_14_53_+1100_PqR6Q.g9KMYTB_9+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM4zqdAAoJEDMEi1NhKgbs7XUH/2YWQNc9Fsnwo2kz3uzrcmKU
z+f3SEQLT6HfrnWe59OnaCmTZff35pDBj2fwHnEFTbbKTHDy/i3S5DfKLB4AUxKK
gKpC6UxLSsK27NnmuXBC7lB0GqRTcwC48jw/V0vo3KfOyKoSU0yVcqJBLn7A6aa7
AwMNdE4JqRQuBTPxBp1SeONcFJmTaDWi0nDWou9D+CxOdlODq8xDqD1l66G5KPQH
ftsjPw0MrEuAUOB4V78kUkIAxv/NkE3lmt9FF9cRgJLuXHow75jYhucOVv37uG7A
UwDYbCIo93DBICmVImzWGPy9z1qtWoi6/AYxct9vjrSzJ3uWAmGx5nytFwmWb64=
=VvTm
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Nov_2010_13_14_53_+1100_PqR6Q.g9KMYTB_9+--
