Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab1JWIVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:21:36 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:60445 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab1JWIVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:21:33 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Paul Schilling <paul.s.schilling@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "David S. Miller" <davem@davemloft.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Paul Schilling <Paul.S.Schilling@gmail.com>
Subject: Re: [PATCH 02/15] ATA : vortex86 : fix vortex86dx/sx hardware CRC bug.
Date: Sun, 23 Oct 2011 10:20:56 +0200
Message-ID: <1732355.g0uNX7XlKI@donald.sf-tec.de>
User-Agent: KMail/4.6.0 (Linux/2.6.37-12-desktop; KDE/4.6.4; i686; ; )
In-Reply-To: <1319346300-18151-1-git-send-email-paul.s.schilling@gmail.com>
References: <1319346300-18151-1-git-send-email-paul.s.schilling@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7274773.LvsbtmEDeC"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart7274773.LvsbtmEDeC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Paul Schilling wrote:
> This fixes a DMA issue related to a CRC bug on
> the RDC pata peripherial found on the vortex86sx and vortex86dx.
> 
> Signed-off-by: Paul Schilling <paul.s.schilling@gmail.com>
> ---
>  drivers/ata/pata_it821x.c |   22 ++++++++++++++++++----
>  drivers/ata/pata_rdc.c    |   29 ++++++++++++++++++++++++-----
>  drivers/ide/it821x.c      |    9 +++++++--
>  include/linux/pci_ids.h   |    2 ++
>  4 files changed, 51 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
> index c5532b9..5f8a54a 100644
> --- a/drivers/ata/pata_it821x.c
> +++ b/drivers/ata/pata_it821x.c
> @@ -897,7 +897,16 @@ static int it821x_init_one(struct pci_dev *pdev, const
> struct pci_device_id *id) static const struct ata_port_info info_rdc_11 = {
>  		.flags = ATA_FLAG_SLAVE_POSS,
>  		.pio_mask = ATA_PIO4,
> -		.mwdma_mask = ATA_MWDMA2,
> +		.mwdma_mask = 0,
> +		.udma_mask = 0,
> +		/* No UDMA */
> +		.port_ops = &it821x_rdc_port_ops
> +	};
> +	static const struct ata_port_info info_rdc_01 = {
> +		.flags = ATA_FLAG_SLAVE_POSS,
> +		.pio_mask = ATA_PIO4,
> +		.mwdma_mask = 0,
> +		.udma_mask = 0,
>  		/* No UDMA */
>  		.port_ops = &it821x_rdc_port_ops
>  	};

Why do you define this if it is never used?

Eike
--nextPart7274773.LvsbtmEDeC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk6jznMACgkQXKSJPmm5/E4ZjACeMkNvJXjZxXOJKxS5GdPoxZxy
3QMAn0CfPU5+EBaeqggBqbth3yZ3Jmee
=0IKU
-----END PGP SIGNATURE-----

--nextPart7274773.LvsbtmEDeC--

