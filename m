Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab2LBVMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 16:12:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2LBVMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 16:12:34 -0500
Date: Sun, 2 Dec 2012 22:12:14 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: airlied@linux.ie, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] drm: tegra: fix missing unlock on error
Message-ID: <20121202211214.GA22265@avionic-0098.adnet.avionic-design.de>
References: <CAPgLHd-UekVrvc8gwNUFaoNtcFcZCNC559GW1wfrmUVHidsiOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <CAPgLHd-UekVrvc8gwNUFaoNtcFcZCNC559GW1wfrmUVHidsiOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:W+9lnwy3YEmoV5IDctpJ9xS0aBzbevDeG0Bxj+aCvXZ
 e74KK5zCYriE0uperdLlZjT+O28UYrHCkDicnI0nZiHJNc1l1Z
 w2waXLP2xri6YuMKTPVHiSX7tceZNQcrq8Lthj2KyXKH1j8lKN
 xQt4kOTPzSeBGrLxJVme/dF11RZSyFmK5YFkzAsbYQLogRbcMK
 lKQ7nAMaO3tYNSb/e2FE3epjVPhI6K8fuj3J5VKIZlmfYU1QSk
 COFWJ+0ewDsUmA3okEewJCbG9MXqkiGhQHddCvQPOBLwiy8qaZ
 O0R0stN3HEblNgZaYdFkdwVuV7cNM7yaM/Xo4wVoK+TT+2ioP5
 8XtzDIE12F0zJWJmUrLFOJZsohVfeVdb8jExXvBPR1FuwJFEkh
 +1zqnBnsZE/Ns8eGMcpcBITnnyNZqEmAhWZuJgESAgEJ80HMte
 9XEzL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 02, 2012 at 05:25:05AM -0500, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Add the missing unlock before return from function host1x_drm_init()
> and host1x_drm_exit() in the error handling case.
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/gpu/drm/tegra/host1x.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/drm/tegra/host1=
x.c
> index bdb97a5..39629e6 100644
> --- a/drivers/gpu/drm/tegra/host1x.c
> +++ b/drivers/gpu/drm/tegra/host1x.c
> @@ -176,6 +176,7 @@ int host1x_drm_init(struct host1x *host1x, struct drm=
_device *drm)
>  				dev_err(host1x->dev,
>  					"DRM setup failed for %s: %d\n",
>  					dev_name(client->dev), err);
> +				mutex_unlock(&host1x->clients_lock);
>  				return err;
>  			}
>  		}
> @@ -203,6 +204,7 @@ int host1x_drm_exit(struct host1x *host1x)
>  				dev_err(host1x->dev,
>  					"DRM cleanup failed for %s: %d\n",
>  					dev_name(client->dev), err);
> +				mutex_unlock(&host1x->clients_lock);
>  				return err;
>  			}
>  		}

Acked-by: Thierry Reding <thierry.reding@avionic-design.de>

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQu8QuAAoJEN0jrNd/PrOhABMQAMKm1sXd34ABe3h4U7ON3q0o
onRSzvTFjjoFdJD3vV/ZNEOiHyCtuNzKVo2P2/HfzohEkUpE4UiCvg6luuuo0Tc1
RA58dfotVXo9oqn841sLEt9GGb550vRNkSoCHL4A6NhI3MmjiDELaH0mjGVMW9DK
EJPP9WvvPJWkpEmWccAN8XvNlb9d85hVyqlJ1ycCWZ3ku+olsqqk3Dqke5N9KO+1
w5NhujuwZM55vl9NYHn2njX92mzFtBPedZuTL6Utcv+2XXOYfxbZryDAdBt3KAfe
BpGM91KVhbuT7oYFJrinfKbwjFRWt0WWiheTTk2duSRQULig8TKQEYz7tMwNYsXT
NXcPrCLUlm2c7v81ElJQXXlYx1snWerCX1n+FKaqX+siojAPafM8mE0SjZPrmTbp
DsQVEv9aLPRzc84sxEf+iys7PE7lY9cH85S9bmsOGG6I9ceKTbKZ5iORdjNCbsO7
gUJCho3D2whq8MLV4WgyFPLmI8SUzq8+A2ZuGIoQKaB2j540wa5vDvSw1XyEu7Eo
boDlDRKUw73dZX7m3ATCbJzc3o1MMKHSQ5zLy6j19VrSlE9ZIByF8Tj+4towsOXr
V34/r2Kl8ZJWUsbUbFm8cLiWEcchEl8+eYMiX8V4xtM+Sxy74CrmtWByszkwlANy
1TrYnBvSlMt0hJAGTZS0
=BMKg
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
