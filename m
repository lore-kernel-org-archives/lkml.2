Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab2CUQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:09:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49842 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755879Ab2CUQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:09:16 -0400
Date: Wed, 21 Mar 2012 16:09:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, lars@metafoo.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v5] sound/soc/lapis: add platform driver for ML7213
Message-ID: <20120321160913.GF3226@opensource.wolfsonmicro.com>
References: <1331275160-31757-1-git-send-email-tomoya.rohm@gmail.com>
 <1332158459-14880-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nYySOmuH/HDX6pKp"
Content-Disposition: inline
In-Reply-To: <1332158459-14880-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nYySOmuH/HDX6pKp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 19, 2012 at 09:00:59PM +0900, Tomoya MORINAGA wrote:
> This driver is for LAPIS Semiconductor ML7213 IOH I2S.

So, I just said to the SPEAr guys that I really want to see support for
non-cyclic dmaengine added to the helper library rather than open
coding.  We're seeing lots of platforms moving to dmaengine (as well as
those that are in already yours is one of three out of tree platforms
I'm aware of that have actively submitted stuff) and with this number of
platforms we really need to get stuff factored out - there's enough
people working on these platforms that it should be possible to add the
support to the dmaengine library code.

A few relatively minor comments below and due to the above I haven't
really reviwed the DMA but overall this looks pretty good.

> +static struct ioh_i2s_data *i2s_data;
> +static struct ioh_i2s_dma *dmadata;

These shouldn't be global, they should be device specific and passed
around.

> +static int ml7213i2s_dai_set_dai_sysclk(struct snd_soc_dai *dai,
> +					int clk_id, unsigned int freq, int dir)
> +{
> +	u32 reg[MAX_I2S_CH];
> +	void *iobase = i2s_data->iobase;
> +	int i;
> +
> +	for (i = 0; i < MAX_I2S_CH; i++) {
> +		reg[i] = ioread32(iobase + I2SCLKCNT0_OFFSET + 0x10 * i);
> +		if (clk_id == IOH_MASTERCLKSEL_MCLK)
> +			reg[i] &= ~ML7213I2S_MASTER_CLK_SEL;
> +		else if (clk_id == IOH_MASTERCLKSEL_MLBCLK)
> +			reg[i] |= ML7213I2S_MASTER_CLK_SEL;
> +		iowrite32(reg[i], iobase + I2SCLKCNT0_OFFSET + 0x10 * i);

This looks like it should be a switch statement on clk_id, this will
also catch bad parameters that might get passed in.

> +		if ((slot < MAX_I2S_CH) &&
> +				(!(tx_mapped & (1 << slot)))) {
> +			dmadata[i].mapped_tx_ch = slot;
> +			tx_mapped |= 1 << slot;
> +		} else
> +			return -EINVAL;

Braces on both sides of the if please.

--nYySOmuH/HDX6pKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaf0jAAoJEBus8iNuMP3dP8sQAJ19/ztENVH2a7eKjUI8CsYR
vsvlXD4iHH72BEzl8doZsfupd2AJsguYi0MdKhgt+SgW5pIBzxK/0Kz6R028iy8i
OctKi9WZi5ohI+ME22ZM2bTnhXgO8OAzgpmHvzzseUt3WzG80NKjwo8625A34EZd
i41o41b42xg16N8PrPfQEaTwH3bcjY6Tj4stuIvFPrSC9lYjPgcH3djvxC9hTT/k
rYD6nz1khYjN6/jD3kJfVnt8kvgpHrYEyUQc/69WqunlQSCRO1fop6tiKlXujHHd
DpwbjBQseJ5T2BFlaVuyQN655aHFfoG9S8xFvldayLg/yQ+2nhW5iSwbh3aZhn0x
mmhAYkWerCfurhCutVqiloVFyluwEfPdORDMWMxRxj8gh0UQiq9GUtx9xrwOhTuR
PjuDXAK2cSkrabeK3gXQ6Vu8HR9Rpsrw9m2rO9uIndp5JywNtnUHZaCRli9ibUHt
1rcvItmn04/UNgQ7EdHI/Or16vAkc2f/4cddx4UQysQzOAYS1wo0ShZpq4wcBfan
PXQnjw3I3CSm1+2qcY608v8GPiRPEXUz/WjIYm6Lr41UazVkFoEEpk3zDiYLe2Vt
3sXcBRvCAO7Ao6BXwWtE1Sj8u/b/VKgkeJM5iPBfj+v5ys6MUsCpgd+Zx+irVQ/t
pSeM1DHey5BABCO0VaER
=PjgL
-----END PGP SIGNATURE-----

--nYySOmuH/HDX6pKp--
