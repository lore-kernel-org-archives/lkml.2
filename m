Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2CNOp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:45:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54753 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab2CNOp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:45:26 -0400
Date: Wed, 14 Mar 2012 14:45:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v6] sound/soc/lapis: add machine driver for ML7213
 Carrier Board
Message-ID: <20120314144524.GT3133@opensource.wolfsonmicro.com>
References: <CANKRQngTNWMGswq3weD1s8O4irVEz+DCr1vzi2gnWaQcoq5SEw@mail.gmail.com>
 <1331275091-31700-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9hshNW4m6zn79FF/"
Content-Disposition: inline
In-Reply-To: <1331275091-31700-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9hshNW4m6zn79FF/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 09, 2012 at 03:38:11PM +0900, Tomoya MORINAGA wrote:

> +	/* set codec DAI configuration */
> +	ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
> +				 SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* set cpu DAI configuration */
> +	ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S |
> +				 SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);

This looks very broken, you're setting the two ends of the link to
different configurations.  If this is needed it should be documented why.

Also, this should be set in the dai_link structure as data rather than
set each time.

--9hshNW4m6zn79FF/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYK6XAAoJEBus8iNuMP3dUegP/3c584uB/C3MMpEFcdB/Oy5g
xl77tzaYuGQTXH5yLVa9MCntKG+pmO1gL1AG1VHb+jiFdhNeuBv8omIyWLFkkCV0
rTW74+EQ2e0+vcGEZUOT4Y8sNxRZHrFFLJQSWNaAZflt9I9ydm6HliZuBpvt6hEW
wJwJbgU0BOLX+7B8MGbAEcGbEdpyr+NIy2zAqdwiIdmZf5RhxFVJCKJimwbCeePC
c17Al0KV2aCqrM35Xs6pz10aLikKGi0W837JY6mpOn3dqR6ssTrxLDJ1wm84E11e
dtYzP5FM6NQVID0WgJY2GZ1Um5T1YmkAHEgTSjLDckPBU+EyNBqLUA7F4OplBcfV
IN2Jn12kE5KtoIBkc2hfdPOI9KQV5cnSg4lt2iUUY8GUKcF9PVlES/0WkAzrBKJO
xHfzidH1Gmgz4rIqAxiqe8Z/e2lvmJVaawfxyOwceEMaU74dkhq5BWTcTk8gFVRv
rZnUJq+HUq/5gooh1IQsVWHxkhtcYVFuVCy3M0pqjRuGbqBPnaD6NT8hR/XASLVp
+3eU+Mb/e8evCk4i0Ap6SEtx2q9F3ir2jA/TbeHzLU4N8ws6QReQyZ0iRSb70uze
wyztsD5ayIf2MZBUdmFAG48kCmfu+W8juQYXiaBRqrY+chz/mfrR0FsIGQ8d21b7
q22nO63zEAnO5x6PSn8R
=z388
-----END PGP SIGNATURE-----

--9hshNW4m6zn79FF/--
