Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab2FTXqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:46:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34672 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932191Ab2FTXqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:46:51 -0400
Date: Thu, 21 Jun 2012 00:46:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: boot_on regulator constraint vs. regulator-boot-on DT property
Message-ID: <20120620234648.GE4037@opensource.wolfsonmicro.com>
References: <4FE238C9.3010408@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ey/N+yb7u/X9mFhi"
Content-Disposition: inline
In-Reply-To: <4FE238C9.3010408@wwwdotorg.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ey/N+yb7u/X9mFhi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 02:55:37PM -0600, Stephen Warren wrote:

> include/linux/regulator/machine.h says:

> >  * @boot_on: Set if the regulator is enabled when the system is initially
> >  *           started.  If the regulator is not enabled by the hardware or
> >  *           bootloader then it will be enabled when the constraints are
> >  *           applied.

> Documentation/devicetree/bindings/regulator/regulator.txt says:

> > - regulator-boot-on: bootloader/firmware enabled regulator

> ... and of_regulator.c sets the boot_on constraint based on this property.

> The former quote implies that this is a flag to tell Linux to turn on
> the regulator when it's first registered, whereas the latter quote
> implies that it's guaranteeing the state that previous SW placed the
> regulator into already.

> I assume the documentation from machine.h is correct, and I should send
> a patch to make regulator.txt match it?

There's no great inconsistency between the two, this is only supposed to
be used for supplies which are already enabled on boot but if the supply
is not already enabled then currently the API will try to make it so
since probably there's some reason for that.  Generally it's supposed to
be used as a crutch to keep hotplug going.

I'm not sure we should clarify this since I'm not sure that for DT
setups which (as we were discussing in the other thread) are supposed to
be usable over many software versions it's something that should really
be used.  We ought to in the endgame be able to have DT systems turn on
full constraints and that probably breaks anything relying too much on
boot-on, I'd expect they either need the regulator to be always on or
some more consumers.

--ey/N+yb7u/X9mFhi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4mDhAAoJEBus8iNuMP3dGi0P/1EFnIaEpwUdf0kC2rnuKIuc
Dr0pKFG4C7XnE3H7bO/yluFlqm/5QwzuKfm6/l09w6jtN8YClN7GVP8r0GTaePdH
86CnZrR7nxoIcrTkrPfCqoVXpx6AZxmHsyjeIF4qzjcFa4GWCCcEpkhgyuuJXIAJ
wub0dd+5p0PSZYdRnIl6AnbK2GrV+xyYrdfLmFsctnIf7YYSPhYdcoeHEvJ8/X5L
+2ykr7TalHrLfKbCEKQZGfLr5Vp0F4F9Ex6a+G4Ar3lQMcTbAnG7Fh7VRMalE+Qr
mwoYDTvY3ogv9AVAqX4WD4x/0JcBVJbGJ1YVN3bqR3BwsclDo5Td4Ao7tUhQNIGW
hkC+F2ffYqHlSnyNlj5OoD0Q9e6p6V1fIiJQlGW6KjOe3SFEPOLIrFZxxiZ2zIfk
7O4mIjCWVnMO7FLI4BlGypKnd9HlNap5B2ngjCSsSzQFzv4hiUnWy7vGYsVzJ6Nw
VgNQLo12yGi6VOYIn8kuqWwuuLpPLqpuKV2oEhJCoo/DcbnkI21SivUfKVOBVus1
z1Xab/dhvctXHdt9TptlkBa+bIq6Th1EO5UK9/igSFMtXTpTm7mELx4EP3usfCNx
JCBJa8dUQVozUijFDcs2wwvDvU710/DuYnYeH9c45tfvZ4J85PWFaKyAEYNjnKLy
SW1ghxTs24yW+w8LAGbs
=dmEY
-----END PGP SIGNATURE-----

--ey/N+yb7u/X9mFhi--
