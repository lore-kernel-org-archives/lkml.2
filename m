Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab1HHKBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 06:01:12 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:47680 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960Ab1HHKBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 06:01:10 -0400
Date: Mon, 8 Aug 2011 13:01:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] usb: musb: ux500: optimize DMA callback routine
Message-ID: <20110808100105.GA31536@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312792358-2445-1-git-send-email-per.forlin@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <1312792358-2445-1-git-send-email-per.forlin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 08, 2011 at 10:32:38AM +0200, Per Forlin wrote:

[snip]

> -/* Work function invoked from DMA callback to handle rx transfers. */
> -static void ux500_rx_work(struct work_struct *data)
> +void ux500_dma_callback(void *private_data)
>  {
> -	struct ux500_dma_channel *ux500_channel =3D container_of(data,
> -		struct ux500_dma_channel, channel_work);
> +	struct dma_channel *channel =3D (struct dma_channel *)private_data;

you don't need to explicitly cast a void pointer, please remove that.

--=20
balbi

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOP7PhAAoJEAv8Txj19kN1uAUH/1x9dA6y+Q29FYTWkrAOphtL
jQcObORYwTC/O0EXy2NLA3L32AsIGOBdCwKdR2+tyJjSpMcLp4BchPgomxHRsWV4
Kc2XnHQUNWqcYsvKw7bSseSs4vruN+rmj8sDoP6evaxhh4Gb6jOl6e6+rjY4YrBU
HM6JyASXOhbdAWmQX1DqaSHCB2kkqxK/hv51SLXIgWcZ8sct370sm5A89AVfqp6E
2AxdSwQxsIm62aueYQL3yiuoZTofhhdGcRDAucN0XWWBzbqnObPRrsz2D5cM8l7f
6JbPoKf2BjdDVuvoyw7nKrP+zHccbAcsl7lfDVU/M4nwBJfEVLd3C0G9cTKji60=
=xCQN
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
