Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2CNOjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:39:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53546 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403Ab2CNOjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:39:44 -0400
Date: Wed, 14 Mar 2012 14:39:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v7] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20120314143941.GS3133@opensource.wolfsonmicro.com>
References: <20120308114704.GH3638@opensource.wolfsonmicro.com>
 <1331275026-31651-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FiqEyLLt06qkB6ow"
Content-Disposition: inline
In-Reply-To: <1331275026-31651-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FiqEyLLt06qkB6ow
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 09, 2012 at 03:37:06PM +0900, Tomoya MORINAGA wrote:

A substantial improvement on previous versions but there's still a few
issues, though they're now fairly small.

> +	/* SAI configuration */
> +	if (priv->channels == 1) {
> +		ml26124_update_bits(codec, ML26124_SAI_TRANS_CTL, mask,
> +				ML26124_SAI_NO_DELAY | ML26124_SAI_FRAME_SYNC);
> +		ml26124_update_bits(codec, ML26124_SAI_RCV_CTL, mask,
> +				ML26124_SAI_NO_DELAY | ML26124_SAI_FRAME_SYNC);
> +	} else {
> +		ml26124_update_bits(codec, ML26124_SAI_TRANS_CTL, mask,
> +				    ML26124_SAI_NO_DELAY);
> +		ml26124_update_bits(codec, ML26124_SAI_RCV_CTL, mask,
> +				    ML26124_SAI_NO_DELAY);
> +	}

What happens if the system switches between 1 channel mode and
multi-channel mode at runtime?  It looks like _SYNC will never be
cleared.

> +static int ml26124_set_dai_sysclk(struct snd_soc_dai *codec_dai,
> +		int clk_id, unsigned int freq, int dir)
> +{
> +	struct snd_soc_codec *codec = codec_dai->codec;
> +	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
> +
> +	switch (clk_id) {
> +	case ML26124_USE_PLL:
> +		ml26124_update_bits(codec, ML26124_CLK_CTL,
> +				    BIT(0) | BIT(1), 0);
> +		break;
> +	case ML26124_USE_MCLKI_256FS:
> +		ml26124_update_bits(codec, ML26124_CLK_CTL,
> +				    BIT(0) | BIT(1), 1);
> +		break;
> +	case ML26124_USE_MCLKI_512FS:
> +		ml26124_update_bits(codec, ML26124_CLK_CTL,
> +				    BIT(0) | BIT(1), 2);
> +		break;
> +	case ML26124_USE_MCLKI_1024FS:
> +		ml26124_update_bits(codec, ML26124_CLK_CTL,
> +				    BIT(0) | BIT(1), 3);
> +		break;

Why not just specify the MCLK rate and then calculate the division based
on the sample rate?

> +	switch (freq) {
> +	case 12288000:
> +		priv->mclk = freq;
> +		break;

This is especially true given that only one MCLK rate is supported.

> +	case SND_SOC_BIAS_STANDBY:
> +		/* VMID ON */
> +		ml26124_update_bits(codec, ML26124_PW_REF_PW_MNG,
> +				    ML26124_VMID, ML26124_VMID);
> +		msleep(500);

This will sleep for 500ms when powering down which probably isn't what's
desired...

--FiqEyLLt06qkB6ow
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYK2gAAoJEBus8iNuMP3dTDgP/RWxIoDMU6EztdH16x/Jo8y3
2+e35xSKCJsAwTPHaRJJBXvs+LxJShJId8bwaZKqrN9F/vidunJFI80w/Qc8SISj
WJPJUHoqyIpxhLDc2onT5XofPtfs6f3870vl1TxKET1qYBxEdxhguoU7krzqngtu
l9UFFfy4LiJ7oaDRoz9DcW51Pfv4oQoFKaNRNFn/oof0e+owXTMPCNk/RAZtT+sB
7r+okH7XM41GRwDrA5vrJTSVOh78Eil0dFXF8UeQELxAKafwxWbhs4HCJR1MyfPx
EJhTcqhFNieA50JkE7rO2jJyJTbc2cAr5x/QC9Z/+JDCYZgQVHadfYb4JDQDt0SX
Cne2lw5gxSqg3iQkJDZTnJnzOh640qXLbyDRITTyZvrYXHXbuKJuVg8BeMpvFrXU
2CuABkFZGNV0WAW3hM6LQKEU8DmMUPUP6SHlchGpBec2/qPzyoCgHbXZK0MrPAxw
Q8zWErKv75crPdMEbAK6e+NN1vFLK8S+31Osa+PBKEEYolPW9lwYUH0p/6xwTDSK
1nPfd6ezPBXDRZ2KJvSRHJOT4Ipw1+JNDhMKBIdq2ZFXLvrxQcPDaPs7tw6TvRq7
tT1NllHiWz5b6EeLOufMxoh0L4+Ka2sg7+W6Fb6ULIF4LVRIWFi15YbYIIxyFvMg
kB39YtgI0QgGxy6Eae9C
=tjfB
-----END PGP SIGNATURE-----

--FiqEyLLt06qkB6ow--
