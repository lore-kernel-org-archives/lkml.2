Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934417Ab2DLPxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:53:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50059 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757746Ab2DLPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:53:44 -0400
Date: Thu, 12 Apr 2012 16:53:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: Re: [PATCH 1/2] mfd: da9052: add device-tree support for i2c driver
Message-ID: <20120412155341.GB3195@opensource.wolfsonmicro.com>
References: <1334245182-31725-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <1334245182-31725-1-git-send-email-paul.liu@linaro.org>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 12, 2012 at 11:39:41PM +0800, Ying-Chun Liu (PaulLiu) wrote:

> +- compatible : Should be "dialog,da9052", "dialog,da9053-aa",
> +			 "dialog,da9053-ab", or "dialog,da9053-bb"

This is generally the stock ticker symbol so DLG for Dialog.

> +Sub-nodes:
> +- regulators : Contain the regulator nodes.  The DA9052 regulators are
> +  sorted as following:

This seems poor from a usability point of view, the user shouldn't have
to care about the order in which they list things in their device tree
and they should be able to only list the regulators they use.

> +    buck_core : regulator BUCK_CORE (id: 0 )

Having to care about numeric IDs also seems bad for usability.

> +#ifdef CONFIG_OF
> +	if (!id) {
> +		int i;
> +		struct device_node *np = client->dev.of_node;
> +
> +		for (i = 0;
> +		     i < sizeof(dialog_dt_ids)/sizeof(dialog_dt_ids[0]);
> +		     i++)
> +			if (of_device_is_compatible(np,
> +						dialog_dt_ids[i].compatible))
> +				id = &da9052_i2c_id[i];
> +	}
> +#endif

Ick, this doesn't look terribly nice - are you sure this is idiomatic?
The bound for the iteration also looks a lot like ARRAY_SIZE().

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhvpjAAoJEBus8iNuMP3dljMP+wRB2qfmlyqzFb0zvpPQdyOT
BskosFcVpCzJoJ1DMqbnD0aKQgkzxvnZ8qhDyqkPgbp9WdeiWD3sEM6F3uBRPJqg
RC3KrElKc9yGeMAV/cDoXr5iFqHu8BOfyoHU/DIMkMTZiEhiSxwzAnTeFC3Ncgp4
GTcukxB77vQw9yLgX3J6S0jS35ZPAxQJsGPfJao4l1NdYlDXrklGelPjTTUHA/cx
ohfsE8P9svs5w8b+mntF5o82HUeeqFOh9YJRP/7+Ec5EWEhjU8zKAanJEZ+05OZS
fk7dLnZr+psWFLX6YLjdYwxXLNphWhN7M3p9ZWcF7avDGor0nKdA9kUL/ZLY2jMO
z3pn31D0846EM/WUnHrE6RN4b6Q9ASdnrismRzjd/ulG2WrT4R/YYYqWRxDB8JS8
OfNfE+H6cIfim3GT9gTz6FB53+Cqi5wUfKgB8KJuwjcO7gSMbZPzq/bfd+QgTOzZ
sEvGliS3d7jPh59Tm276I2cc/I7uqe9/JLanWjTaG545uLGEq4MZlvul9KSQv9Bu
CLCCYPdj1+FhjXC9q0nShY6CnoG3/GrlrcPAGi02gXkHrJr0m1NHEIVomf/FncxR
z8Rk9JyEblgZUwboRDMAqKBb3h8TVDPY29haZigaUmGEwx6vItKynB3gC0fj1WN9
6gXixMD04fszE11SDP8m
=CNHg
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
