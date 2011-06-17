Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab1FQKyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 06:54:52 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54296 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603Ab1FQKyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 06:54:49 -0400
Date: Fri, 17 Jun 2011 13:54:44 +0300
From: Felipe Balbi <balbi@ti.com>
To: David Howells <dhowells@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, grant@secretlab.ca, ralf@linux-mips.org
Subject: Re: [PATCH] FRV: Hook up gpiolib support
Message-ID: <20110617105443.GP12230@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110616102209.GC5262@opensource.wolfsonmicro.com>
 <20110615144823.GA2806@opensource.wolfsonmicro.com>
 <1306921767-31115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <5194.1308074912@redhat.com>
 <19624.1308206191@redhat.com>
 <28714.1308307859@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5tiY7shzwSGI9p6W"
Content-Disposition: inline
In-Reply-To: <28714.1308307859@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5tiY7shzwSGI9p6W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 17, 2011 at 11:50:59AM +0100, David Howells wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
>=20
> > And to repeat what I said: the generic header prototypes everything it
> > needs before it uses it so there should be no problem here, it's not
> > been a problem on the other architectures using this code verbatim.
> > Please be more specific.
>=20
> Okay:
>=20
>   CC      drivers/mtd/maps/gpio-addr-flash.o
> In file included from /data/frv/linux-2.6-frv/arch/frv/include/asm/gpio.h=
:21,
>                  from include/linux/gpio.h:8,
>                  from drivers/mtd/maps/gpio-addr-flash.c:17:
> include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
> include/asm-generic/gpio.h:233: error: implicit declaration of function '=
gpio_get_value'
> include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
> include/asm-generic/gpio.h:239: error: implicit declaration of function '=
gpio_set_value'
> drivers/mtd/maps/gpio-addr-flash.c: In function 'gpio_flash_probe':
> drivers/mtd/maps/gpio-addr-flash.c:234: error: implicit declaration of fu=
nction 'gpio_request'
> drivers/mtd/maps/gpio-addr-flash.c:238: error: implicit declaration of fu=
nction 'gpio_free'
> drivers/mtd/maps/gpio-addr-flash.c:242: error: implicit declaration of fu=
nction 'gpio_direction_output'
>=20
>=20
> Let me expand on my explanation earlier:
>=20
>  (1) asm-generic/gpio.h has an _inline_ function:
>=20
> 	static inline int gpio_get_value_cansleep(unsigned gpio)
> 	{
> 		might_sleep();
> 		return gpio_get_value(gpio);
> 	}
>=20
>  (2) gpio_get_value() is implemented in asm/gpio.h.  It is not declared in
>      asm-generic/gpio.h.
>=20
>  (3) Therefore, the #inclusion of asm-generic/gpio.h must come _after_ the
>      implementation of gpio_get_value() in asm/gpio.h.
>=20
>  (4) asm/gpio.h implements the aforementioned inline function:
>=20
> 	static inline int gpio_get_value(unsigned int gpio)
> 	{
> 		return __gpio_get_value(gpio);
> 	}
>=20
>  (5) __gpio_get_value() is declared in asm-generic/gpio.h.  It is not dec=
lared
>      in asm/gpio.h.
>=20
>  (6) Therefore, the #inclusion of asm/gpio.h must come _before_ the
>      implementation of gpio_get_value() in asm/gpio.h.
>=20
> Thus (3) and (6) contradict.

sounds like it's time to move all that mess to one header alone ?!?
<linux/gpio.h> should be self-sufficient ?

--=20
balbi

--5tiY7shzwSGI9p6W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+zJzAAoJEAv8Txj19kN1R+8H/Rd+RJYXoUR9vjO/2u3a2AXo
xWnfhahEJFLERaMzVCDy8P5QcdCZPHs9Ds1KA35sSvX6HEDcQQ+Ob/tetY7EqAL2
aVz0PKI5wdNA+ntvNleFZU0Gv4uHZtXUsvpdQE6rFeivl9kq1ZRMzvcvujAob6fa
b2fag/7CbE9LIe/Rz6nEwsXuc5KvtqKb3otRckQWsBfTri6U1pYgqAzOiIVwM0l5
A06V+WEWeB2T4i4ExCIc7FESVh1gWyFGGxca//Pc0XTj+gGkB8vYAAgv06IJs9Mq
t5C8WiIJ65CwJqGlg2Rgs633A84Qp1Q5ADIBFQ/fEX7JCv69f/IeY+tgzO7HYNI=
=q5FD
-----END PGP SIGNATURE-----

--5tiY7shzwSGI9p6W--
