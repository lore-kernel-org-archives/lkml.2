Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab2IKOsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:48:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56639 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab2IKOsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:48:19 -0400
Date: Tue, 11 Sep 2012 16:48:14 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: Re: [PATCH v2] pwm: Fix compilation error when CONFIG_PWM is not
 defined
Message-ID: <20120911144814.GB3824@avionic-0098.mockup.avionic-design.de>
References: <1347356655-17191-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline
In-Reply-To: <1347356655-17191-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:/MztECl+dd6IH+mHPPx1DTRM6R/6Bc4cFBXp5TMpqzn
 z6T0WTw6DyEPj9zM57Q19B+EeKRPqKuimiwegTWjR8nCW87X7m
 zavrPMpSe31i70nXveHU3C3rkGJkPoWu2X06Wh0J6Jni/J/zHW
 DAZ4Sshz2Ohj+uUmEoY1AybFLMauVekmUPLYpGWesAfF/XZoDV
 vXvuEqkSgojT9DkM2zW8h+LS4cV9wIy8TGbDsd4XVPsWknRbrt
 IH3K+YXeNIppN9MMtutq+IySmheEDgax0qeOxv3PiCQuup2lN5
 cJjx65kekqPehhE6MnnXvLn5qf9KZ9t1bwtMpEYJep3pnz/OvX
 KqDdWCAW7hfUYy8qFgGpwaZQBkmX4VNun5nYMDhQrhui64VDCH
 7mH8oVS+fxaCcqxKpE+2b+CLbgWrgP4bnM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2012 at 03:14:15PM +0530, Tushar Behera wrote:
> Add dummy implemention of public symbols for compilation-safe inclusion
> of include/linux/pwm.h file when CONFIG_PWM is not defined.
>=20
> While at it, also reorganize the file.
>=20
> Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
> Changes since v1:
> * Incorporated Thierry's suggestions regarding adding dummy function
> implemention for all global functions
> * Reorganized header file to have structure definitions first and then the
> function definitions.
>=20
>  include/linux/pwm.h |  135 ++++++++++++++++++++++++++++++++++++---------=
-----
>  1 files changed, 97 insertions(+), 38 deletions(-)
>=20
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 21d076c..f1e685b 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -6,32 +6,6 @@
>  struct pwm_device;
>  struct seq_file;
> =20
> -/*
> - * pwm_request - request a PWM device
> - */
> -struct pwm_device *pwm_request(int pwm_id, const char *label);
> -
> -/*
> - * pwm_free - free a PWM device
> - */
> -void pwm_free(struct pwm_device *pwm);
> -
> -/*
> - * pwm_config - change a PWM device configuration
> - */
> -int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
> -
> -/*
> - * pwm_enable - start a PWM output toggling
> - */
> -int pwm_enable(struct pwm_device *pwm);
> -
> -/*
> - * pwm_disable - stop a PWM output toggling
> - */
> -void pwm_disable(struct pwm_device *pwm);
> -
> -#ifdef CONFIG_PWM
>  struct pwm_chip;
> =20
>  enum {
> @@ -113,18 +87,6 @@ struct pwm_chip {
>  	unsigned int		of_pwm_n_cells;
>  };
> =20
> -int pwm_set_chip_data(struct pwm_device *pwm, void *data);
> -void *pwm_get_chip_data(struct pwm_device *pwm);
> -
> -int pwmchip_add(struct pwm_chip *chip);
> -int pwmchip_remove(struct pwm_chip *chip);
> -struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
> -					 unsigned int index,
> -					 const char *label);
> -
> -struct pwm_device *pwm_get(struct device *dev, const char *consumer);
> -void pwm_put(struct pwm_device *pwm);
> -
>  struct pwm_lookup {
>  	struct list_head list;
>  	const char *provider;
> @@ -141,8 +103,105 @@ struct pwm_lookup {
>  		.con_id =3D _con_id,			\
>  	}
> =20
> +#ifdef CONFIG_PWM
> +/*
> + * pwm_request - request a PWM device
> + */
> +struct pwm_device *pwm_request(int pwm_id, const char *label);
> +
> +/*
> + * pwm_free - free a PWM device
> + */
> +void pwm_free(struct pwm_device *pwm);
> +
> +/*
> + * pwm_config - change a PWM device configuration
> + */
> +int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
> +
> +/*
> + * pwm_enable - start a PWM output toggling
> + */
> +int pwm_enable(struct pwm_device *pwm);
> +
> +/*
> + * pwm_disable - stop a PWM output toggling
> + */
> +void pwm_disable(struct pwm_device *pwm);

The legacy functions probably need to be declared unconditionally
because they are also available if HAVE_PWM is defined. Or rather than
unconditionally they should probably be protected by something like:

#if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
  ...
#else
  dummies go here
#endif

In that case it may be worth splitting this into two #if blocks, one for
the legacy API and one for the new stuff, maybe even keeping the file
layout to reduce the patch size.

Alternatively we could postpone this patch a bit until HAVE_PWM can be
removed. I've posted patches that convert all remaining legacy
implementations and except for Unicore32 it looks like we may be able to
get all of them into 3.7.

In the meantime you could solve the problem on your end, as I mentioned,
by selecting PWM from the board's Kconfig. If enough people think this
needs to be done now I may just be persuaded to accept a patch like this
and remove the extra check for HAVE_PWM along with HAVE_PWM when that
happens.

Thierry

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQT08uAAoJEN0jrNd/PrOh26AP/3pWcD9iaHL/L1vzAI46Jjwj
ervwyM94oKXDsKXo0igLl2JvhfykxHIBSoM+hGBDlWGjGj6HsLPq7ot04VQEO/Xs
GYorEr+uZHcwhWYWa2i21nysBRl6VZ/o0YchI3Ukq3XkspUxrP+6oHARVPzFY7xB
swrHxgvriB0jWWmj3TdI/zcR7rtHj1D4Jw4AppHzAYBv+TdTN2//AYe1RJJwQoSz
EQTonl0Ku3+YrkN9tDvDCUE8t1c9zI2npyC5BDgdQMv2giO86f7lByd9ge0DTR9v
hbhk1o8H82sXb6qeXXVuTrvRa+RZ2oMunyWzVWW8m9pm2lNmo50SGIZ+5hqa6znm
ov6pO/U0hFus7qbR09a96CK5CDfns/g2tezmpz1sM24dQTUbeV0XtMQnKPU35GqI
YK9uQNofgrXiSAkwhCU8ahzRBLfQG075bQB+vzS4WUiR9CQLOPqlSdYoPwx/kTPd
PSUbLD3y8zIRZtbRj+LPKxJ5BbUc+fH387FZZg0mLd/i/X7kzOaFwpukw+wkYMOb
NBbmAbtOew99XBAEwV40695VnHJqY8xqy0LfWdAbyGuJ2+l+flA6CauSmHO3j+cU
pvVUUZw6y6JaQJqRDC+i4DI6eJhBqHKo86YU20cfpE6GuEa4+frw+MfHrt7v38fx
/JdgDOx0F7B0elVzOJdT
=VuWo
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
