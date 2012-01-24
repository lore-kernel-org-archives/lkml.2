Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2AXUWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:22:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60963 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756522Ab2AXUWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:22:07 -0500
Date: Tue, 24 Jan 2012 20:22:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
Message-ID: <20120124202203.GD1135@opensource.wolfsonmicro.com>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr>
 <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 24, 2012 at 06:29:13PM +0100, Julia Lawall wrote:

>  	if (IS_ERR(saif->clk)) {
> -		ret = PTR_ERR(saif->clk);
>  		dev_err(&pdev->dev, "Cannot get the clock: %d\n",
>  			ret);
> -		goto failed_clk;
> +		return PTR_ERR(saif->clk);

Looks like the transformation is overly enthusiastic here - the
assignment to ret is removed but ret is used in the log message.

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPHxLlAAoJEBus8iNuMP3dRcoP/31i6xIi74++d1GCCQJhMXvL
y/Exm6Y/12dxFb+6okcsctWSlbd+thsRQHhYQduHQ2O1v2h8yH0PtVYhHA+tQ+r2
OjBG/yOkQocRLFZvpVJH3I0oLP+oZrLRi7xwt+LLlw2fgQs8FLny595koFklzuoE
tfuQ+B1as7YvByE2CLGbrRIZjDDl9tOaU0Hwjl7hC6Lnlg842IqQBTiYCSTozOjJ
ao0jygFQvaeogVVH3lXb90CLSZsZ2oeI+/VozkqA+LcxQ5qv5Q+T09xD+4YbviQ1
VYMMc/SeQeglxADZejiRYM67Ouy5Rj4PgEYn2BiFcXDad7Rf2xiUW4VNBsC9OL71
X6G55nOhspzLxhqB4JCLX+bb2jNrYLTXUylVMcPdGjTGUkW0MyITK2DCp9MfhY+S
+zYUY8CvF6vBFEVFL2hUF3LTzAiv7SFEbkgIISyPVYUZonQ5oKiKiD4Dvn45RNCM
YrW36zfawWEzXhBGGSg8FPECBJQJG9ELV7EbtcY5pQ88q3jiA30Va8N4EIyqmiyg
3qX42KaCXN1kiSfGw0wDzinx+NULAXU8novUHBC9uxv5EJukyWw9kEC0wglK/oXS
BMJ6QrdQ/J58LyU7dzrLHIw3IkJFPJlF2PfPjauy1/gfABpIpBOkZ7eve3up2+T1
Fb1xUFskg2+dYnINkZKJ
=NUn1
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--
