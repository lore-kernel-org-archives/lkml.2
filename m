Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2KTEva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:51:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40738 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770Ab2KTEv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:51:29 -0500
Date: Tue, 20 Nov 2012 13:51:21 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] regulator: da9055: Fix return wrong selector in
 da9055_regulator_get_voltage_sel
Message-ID: <20121120045119.GG4483@opensource.wolfsonmicro.com>
References: <1353386347.19552.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lqtP4FxvQo6hb6bg"
Content-Disposition: inline
In-Reply-To: <1353386347.19552.1.camel@phoenix>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lqtP4FxvQo6hb6bg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 20, 2012 at 12:39:07PM +0800, Axel Lin wrote:
> We do "selector += info->volt.v_offset" in da9055_regulator_set_voltage_bits()
> to take care of voltage range that does not start with 0 offset.
> Thus in da9055_regulator_get_voltage_sel() we should do corresponding
> "sel -= volt.v_offset" before returning selector.
> Otherwise, we pass wrong selector for list_voltage callback.

No, we should just be using raw register values as the selectors and
fixing this in list_voltage() by returning 0 for invalid selectors.

--lqtP4FxvQo6hb6bg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQqwwpAAoJELSic+t+oim9GWMP/1Xif2cRS7QnaLRMtcgEsCK3
10tzRa4cSdmwuWW3YqQLtzimA86dldiWbEVDQmNw8ug6FrELpRvZk42XsxIDj4gQ
nhzNDZQ6vLH+zM2nMOxy1TLK5V03S0CI9q2Xlq7lVxRowYhFXXQl2IiT7i5iuDJY
wrfj2O4FPkOC8TUrfkmcgoX1sEJk50lx5VmzOHW1Csgf4+oHZ2xsIRis217T4Mmh
G2HTbye4pXVZ5SpjmDWqPqL0/wKAzAfvF3dwaEMhhf7Z61jmLuSqQVPvjm3z/0IM
21mIx5nvBE+KnOhFOipwazV8EiXu43xKG6gdUbD3ORQCfMUO2QF2afROFghYdjvW
aAQNV+M7qbNDVfgIZLLQm9ojPMiRHjUD4TlW/JOIxt4VKqjHwTGYVAEQcSh6gMMf
v7HpBS/UQhodkEfSBayIPpuqNt46lO6oUgtSLN3chy9FfYnXdtJXe2186sU5jV/I
FxxlxUxCSB9uXyEvlfHv9Vdwra0yNXlfO6vmD3x0G2fd5S9DDTSazyQ+OpZWmCJP
X8cLZgmeCmGqUf0bTbIfXCB8TsnU2CjBwXZ4H398ExXgdQp/PO5PpCrjCEX1n7az
ZhUOu46G2Kcc7DmcLj6M+ECU49bkxJr45fzt5KYhmeegUuNG+NNtEmlDwlJiQPiB
OT1ECSrHRAFLWhqsT+er
=MI4F
-----END PGP SIGNATURE-----

--lqtP4FxvQo6hb6bg--
