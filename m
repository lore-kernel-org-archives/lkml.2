Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab2DYJ6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:58:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34053 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754975Ab2DYJ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:58:22 -0400
Date: Wed, 25 Apr 2012 10:58:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
Message-ID: <20120425095819.GG3195@opensource.wolfsonmicro.com>
References: <20120423110522.GB8318@opensource.wolfsonmicro.com>
 <4F95495D.4050508@stericsson.com>
 <20120423122555.GM8318@opensource.wolfsonmicro.com>
 <4F954ED6.2040201@stericsson.com>
 <20120423180140.GR8318@opensource.wolfsonmicro.com>
 <4F965FC4.7010502@stericsson.com>
 <20120424105603.GA12063@opensource.wolfsonmicro.com>
 <4F969FE8.7040500@stericsson.com>
 <20120425080226.GA3195@opensource.wolfsonmicro.com>
 <4F97C5E0.1050808@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4eRLI4hEmsdu6Npr"
Content-Disposition: inline
In-Reply-To: <4F97C5E0.1050808@stericsson.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4eRLI4hEmsdu6Npr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 25, 2012 at 11:37:36AM +0200, Ulf Hansson wrote:

> Maybe you have convinced me now :-) I will therefore start thinking
> of a patch on the mmc framework instead. I will include you if/when
> I send out the patch to the mmc-list, just for reference if that is
> ok with you?

Yes, please - there've been some issues with the way regulators are used
in MMC for a while.  There's definitely some stuff that needs to be
worked through here.

I've also added Jassi who it just occurred to me was talking about some
vaugley similar stuff relatively recently (though I'm not sure it was
MMC).  Jassi, the issue here is working out if an MMC device is powered
at boot so we can skip probing then shutting it down cleanly.

> Some final thoughts (please comment if you like):
> We already have the boot_on constraint, which to me is similar to
> what a new kind of "boot keep state" constraint would be. I think it
> would be no more odd than what boot_on already is. Maybe not a good
> argument, but still..

Yeah, the main use case for boot_on is to support things like automatic
enumeration of devices - for buses where we can enumerate devices when
they're plugged in we normally don't explicitly register them so if we
boot with the regulator disabled we need some way of allowing the device
to appear on the bus.  Don't know that that actually gets much use
though.  It is also used by regulators which for some reason can't
figure out their initial state, there's a few examples of that in
mainline.

--4eRLI4hEmsdu6Npr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPl8q0AAoJEBus8iNuMP3dAnEQAIWtGGWp78Jh8/qWGr0cCcg3
LSefOlHnWIopPdpDdPu/cXYl2pw5X3Z8LcCN/J3d20bzoB5ba6PYhkqRsaSxK45p
uFXbETxMAsIT/dmFC35/bl9PZYSF2nuyR+nXJwEpi3AZpJhCc8dlt0ciyaBgU8/o
T6i+u1Nnk6ZLRSFby26dFKcREU0xqI8RvgprFOr7isVKuhun04U8FLMDVsPl3c63
UtRObFp2pD0B8a3x8C7tCIS/AkEKg1W54ftegfxrdT9VuuWtBCOzIadv0QH+zy6H
7Xe5j8I8MVOpQe9s03miNDc4CvqK9qtIr7MvrN8q/WxxOk5lqxZAtmu/1Vw464UE
8pPLRk2sAXXFPlCvP4m731oIOfRfIFpMaCYGb3NEpubZiQ9K5AtQfwZgY7cZd88f
wktvyrwMhOaRW8aAXuoq0mud46V3rhwWZ1w8nigF1Jy3RSXySeX085Qkiw/NVeTk
ehc+ZLX9eoMQA37erZS+a69Nfn8YJ9sJ83R+iebmqqZQIcYXwNdZB0KyLt5N4Zjy
6/JyFTzYjTNhmSKvELKgYdlZmnk4OuEbHFIsCDwnUn6pFH6ZG2jpumS8Q+j7JaP+
mvGXcRodUh1N1IjGI+rwEDZKQUE1fTP1eDL+YfXqQkxeSMt6vnvP1PhFHWXHgufD
TfeBd0hLa36T2K/xIF0o
=boSG
-----END PGP SIGNATURE-----

--4eRLI4hEmsdu6Npr--
