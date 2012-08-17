Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab2HQKmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:42:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55822 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab2HQKmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:42:11 -0400
Date: Fri, 17 Aug 2012 12:41:50 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bill Huang <bilhuang@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, broonie@opensource.wolfsonmicro.com,
        ldewangan@nvidia.com, swarren@wwwdotorg.org, xxie@nvidia.com,
        lrg@slimlogic.co.uk, jhovold@gmail.com, kyle.manna@fuel7.com,
        rklein@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: dt: tps6586x: Add power off control
Message-ID: <20120817104150.GA27633@avionic-0098.mockup.avionic-design.de>
References: <1345194989-11614-1-git-send-email-bilhuang@nvidia.com>
 <1345194989-11614-2-git-send-email-bilhuang@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <1345194989-11614-2-git-send-email-bilhuang@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:DmHFOq+ocO7ktrlQd+dBKtob1nI4zyHuTSqMYqNC4oj
 28BlXv8Y0PGhNkB7fWDDgf8DiDlf5QQ4fgR5RQAyKxwPXcN+nb
 e0pWsEsAbNCQQX8IQQNV4F2dtH5o8upUo2J1hF6QSdrHnFTFBe
 UTkh6lxpOE0kHNIj3gz10hiC29tVWm2ny/Cj3kbwuxfckAyNlE
 NUblqLNBAn8iv8gJOUuieAqQ+tdCDEX9lMNmCf6ad4NS3vJf7C
 dIhkxp7/W6O8/f9zPhMkYLlHrvmlywxeFkHWkKTHa+1x62fcpD
 9ryScsqvBvBdbZ0nrRi9paqAKxMmzb2Ilrf+qI4m4nBPoPATwK
 VCFqt5bHn21PH1ZW5Gw/OO+ATa+jM5VvEk26Mmqdo+AhB0xu1M
 WfednTbAYlaDf/jZKHp/wuC07dkj9y96JqpHTWaXQw36B/L4z6
 tS8JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 17, 2012 at 02:16:28AM -0700, Bill Huang wrote:
[...]
> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
[...]
> @@ -505,6 +519,11 @@ static int __devinit tps6586x_i2c_probe(struct i2c_c=
lient *client,
>  		goto err_add_devs;
>  	}
> =20
> +	tps6586x_dev =3D &client->dev;
> +
> +	if (pdata->pm_off && !pm_power_off)
> +		pm_power_off =3D tps6586x_power_off;
> +

I think the assignment of tps6586x_dev needs to go inside the if block
as well. Otherwise it might be overwritten by another instance for
systems that actually have more than one tps6586x. Since currently the
driver can't be built as a module it probably makes little sense to
clean this up in .remove(), but it might still be worth adding so it
isn't forgotten if and when somebody tries to convert the driver to a
module.

I should note that I don't like very much how the pm_power_off works.
Maybe this should really be changed to allow passing a context for the
function to work from. Something like:

	pm_power_off =3D tps6586x_power_off;
	pm_power_off_data =3D &client->dev;

Where pm_power_off() would receive pm_power_off_data as an argument.

Even that's not very pretty. On the other hand this doesn't really buy
us much because only the storage location of the variable would change
and nothing else. But it would still make the association of the data
clearer.

Thierry

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQLh/uAAoJEN0jrNd/PrOhXtEP/Ayc6DAD3u5m6S7qGmcWBjOG
aMsVYHcuZiFBst3U2BzwuL1ifJdAcnASgUBlKlIhLA6F4F9bWMARBYweLYoKCWt3
v+Fk11YbKfEiB/SWTOdVtSvZmyK2Rb0kSa0GsWYN8Vh5/lX6hJw/1jzPsBP4Ygt/
rWtzwjrae/pqNb0PTlpCd07PVc45atha6Rtr/k+sUX9lBpO02wijNOvVVN3+jDmo
wfgd1fTogCVmg96cI4opKBbO8qfcGZdUw1gTpRYtwN2FzK0YE3waV71Z1VBfOj5C
O0/RbZWAa0GB6ThBMxPGTPjMlwys54VXNsnUHVWJbuOTliO9Qt4EwoOuOINMMMT3
r5Du6AQFxoZvlb9E1kdjAIts5MU/3b3BFhdiVmvMYeidLZOl/ZtpqE8CbZJhj6R3
qOGcBPq5UmabJxmy1eTbj5sJz+2BAVuyN3c8WlkEU+BeqXoB3bo/CgeQ3RtvGSVm
+73wLcPlO15jRDaVWjWJTTE7LQfpydq2WE8ZyZ1GY5hHm++3Q5eSTTQiEvjuUkvL
cxelDXGcSGwT7F528mpCGCeNZH8NMS6nqctML7vQThCOLQlzRGJN9HMnh60JlLli
8+ui2Z73VaE9JF1tHUHVFSVXGpIYuOKVfb3nWF2n24Xs2jIh10zOZWG+9h6FapyK
5KvAXBn1EdsxmfoljKHc
=GqzC
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
