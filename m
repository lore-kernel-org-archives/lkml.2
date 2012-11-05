Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2KEGsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:48:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49293 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2KEGsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:48:21 -0500
Date: Mon, 5 Nov 2012 07:48:16 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] pwm: export of_pwm_request
Message-ID: <20121105064815.GA31066@avionic-0098.mockup.avionic-design.de>
References: <1351699030-4401-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1351699030-4401-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:55NtH0nzdGUE3m6whLp9gKxJvtMY0iNjOcEXwVL41Xe
 ug6UuH6Msivn1uxrT+rprXnsDvCRcLuG9SmLK6SbuYZGVz3E2j
 NcvH40tKTNSmvl8GKINUwvEP0jSdAVtFMlVmLRGu8LIMJ5yzF/
 2IgPe2pKnETFq9w0PHu3O6XuFLR60SFJ8Nw5aDSXrm41VoPP30
 uLgmtGrXq41QJBfqkrzbJKKlpwlQuhnJjVaguc6XdQFbmvkHtl
 /YT4Ad0mbB3bPz2fP1EPuKzt079XIKjnpKM1wy7SIVSSGo05k/
 EqqB3vDjiqeL1QDt4x11Q3WLF549AP7J47hHXbsPiYxPKZ5b3v
 KqBCatWwwRG3OoNyiWE3eer6b8PhEn263XN3/3CvqomfLAf65L
 bO0clEOlt42i9b0T+dPq6RaDEGbnFkiU1Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 31, 2012 at 05:57:10PM +0200, Pantelis Antoniou wrote:
> No need to hide of_pwm_request, it's useful to other in-kernel users.

Can you specify which users that might be? I'm reluctant to export
symbols which aren't used by any drivers.

> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
[...]
> @@ -457,7 +457,7 @@ static struct pwm_chip *of_node_to_pwmchip(struct dev=
ice_node *np)
>   * becomes mandatory for devices that look up the PWM device via the con=
_id
>   * parameter.
>   */
> -static struct pwm_device *of_pwm_request(struct device_node *np,
> +struct pwm_device *of_pwm_request(struct device_node *np,
>  					 const char *con_id)

Can you please make sure that this remains properly aligned?

> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
[...]
> @@ -171,6 +171,7 @@ struct pwm_device *pwm_request_from_chip(struct pwm_c=
hip *chip,
>  					 unsigned int index,
>  					 const char *label);
> =20
> +struct pwm_device *of_pwm_request(struct device_node *np, const char *co=
nsumer);

The second argument is called con_id, so please fix this up to keep it
consistent.

>  struct pwm_device *pwm_get(struct device *dev, const char *consumer);
>  void pwm_put(struct pwm_device *pwm);
> =20
> @@ -204,6 +205,12 @@ static inline struct pwm_device *pwm_request_from_ch=
ip(struct pwm_chip *chip,
>  	return ERR_PTR(-ENODEV);
>  }
> =20
> +static inline struct pwm_device *of_pwm_request(struct device_node *np,
> +					 const char *consumer)

Here as well. Also make sure the arguments are properly aligned.

Thierry

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQl2EvAAoJEN0jrNd/PrOhpowQAIaz+Sjp7sZQ0IPs94HxRZiu
Ig79mR7joqP6u0K3BYhV2pA1a8fYnkh3cAPSciVLhX6cSGOTRT1WVAAfonx1n9Og
8Z2JcuXke/NnKSjlAmPgL95rJ1Qex75YL6MXuXyVzZ8uVgK47jVGM+7CdTHS0A4m
6bktg7IULo5uOx9N5yvpkYL15XT91d5lDiCbrU81hMZJE8Awo9sDWaUoBNELuYVl
KfRFcxyos7t5GR/Y4/GP2ndngY7HAYhYpWu9t7+pdF6rAmM7kksYCVJeKgMttl2R
6uRqnq2qyRJmGJFKlaHPlVgbYLn4uZaZ0ALvsNwiyGWW2gk/jnGqPS49ThKm8nsy
hDr86g0byfOi+3xl9n3npLJK3GMEjtF98lImSv4PwRM5zbwheiB9VzRLC8swIfdc
Zew2xItnm9DwwUTvbk9egpL0PIBD3l9ijgcfg1zXDFTZB5wvNjbd0Lk9Sovz6MUL
JzM+IbWe/NLvtAaqC+42Tp+iZ727a8hxxodT9M+H+XTW25+ehHaUWcYciOa5RaP7
bJ6EMGPamj/FK07G1gCn7xhhgaW4jtMMNk2e0u/68WgEPbW2JjdvkUzjr89ClXzI
RzW+gSt+icvswGQPbvfR1lc1bsQ/qC/MfAqwQUcGgobXxDKoY8OqQM3DtVpsByjn
HE264ashOaqsaL+IgW8C
=EVPS
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
