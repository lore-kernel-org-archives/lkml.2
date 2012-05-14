Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2ENJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:57:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51575 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841Ab2ENJ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:57:24 -0400
Date: Mon, 14 May 2012 10:57:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] MFD: MAX77693: add IRQ handler
Message-ID: <20120514095719.GK31985@opensource.wolfsonmicro.com>
References: <1336972835-15203-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F55Y67F01HNW3AgB"
Content-Disposition: inline
In-Reply-To: <1336972835-15203-1-git-send-email-cw00.choi@samsung.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F55Y67F01HNW3AgB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 02:20:35PM +0900, Chanwoo Choi wrote:

> +	if (!max77693->irq) {
> +		dev_warn(max77693->dev, "No interrupt specified.\n");
> +		return 0;
> +	}

I'd suggest just setting up the IRQ domain anyway - it makes life
simpler in the other drivers for the chip as they don't need to worry if
interrupts are registered unless it's very important to them that they
go off which is often not the case.  Just skip actually claiming the
IRQ.

> +EXPORT_SYMBOL_GPL(max77693_irq_resume);
> +EXPORT_SYMBOL_GPL(max77693_irq_init);
> +EXPORT_SYMBOL_GPL(max77693_irq_exit);

These shouldn't need to be exported, they're only used by the MFD core.

--F55Y67F01HNW3AgB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsNb5AAoJEBus8iNuMP3dkfAP/3et0R5sZ+7qXtYlkrMXchKH
5jl3sm/Fln9KA9IbMzEY92CPHvV+olZ5q6hpqVLnEb6N6LBEZz8JER2rk7ma/NgF
VZCEfllapU1Z4vTuHkHdz+hLuasndLhhOOytUisJLSI7XlGBLKj+SRgFZk9swope
ROVor7sw140J6ZFl8fdmiNKchpsO9yE38hGagOud9KCklJM+KwX78nw11xVKJ8mY
IIuc0s4gJ1vvUgG1AAmVN0fyKvBavZSHXPuN8WdXTy28cquSTpeEHvEyn0VlC7hx
B5wFbAD1VENF+fQP0QD2PG1hUOs9iVdqIKEiIVkyELarWhaUfNs5ACNA6HVDiDMc
8yQQMnlnv3bQ/kCmfYT7Ryf+EGrn25JKLI561ygZZABUJjjLFzuesCUWI0QUgY27
8gHOFmLnDJHrCDDa5Or0rdpBeUIsn3M0BrT8aYe8PcPsnIZmGOvtjkgKkSrLh7SH
ljcfW7aBf0+Cy+in1Imv1dFRjwL3C/ILE79Uzef6cf9LBWrMlTdVuM36bvm3LUP7
92sCFREVN3/elxkUrti+4IAKNj9R8/8NkbsMAXPgldw0KkCUfKd2JvPcXiclxa4S
vFrl6mozweySJ1vgS+SuL+aDbzLvRjQByRGhCflrG7q+ohz+xE5CniMHJwl3QQen
8ubOrObyY8PFiqR2iCyH
=qJAC
-----END PGP SIGNATURE-----

--F55Y67F01HNW3AgB--
