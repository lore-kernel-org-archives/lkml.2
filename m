Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab2GCT1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:27:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48738 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696Ab2GCT1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:27:03 -0400
Date: Tue, 3 Jul 2012 20:26:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix recursive mutex lockdep warning
Message-ID: <20120703192652.GH29030@opensource.wolfsonmicro.com>
References: <1341282066-15325-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r4jNezHNW2wfBox+"
Content-Disposition: inline
In-Reply-To: <1341282066-15325-1-git-send-email-sboyd@codeaurora.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r4jNezHNW2wfBox+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 02, 2012 at 07:21:06PM -0700, Stephen Boyd wrote:
> A recursive lockdep warning occurs if you call
> regulator_set_optimum_mode() on a regulator with a supply because
> there is no nesting annotation for the rdev->mutex. To avoid this
> warning, get the supply's load before locking the regulator's
> mutex to avoid grabbing the same class of lock twice.

Applied, thanks.  Though we should probably just remove the optimal mode
stuff on account of the total absence of any users...

--r4jNezHNW2wfBox+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP80djAAoJEBus8iNuMP3dBuEP/RA7q4pIvOvV2zPAMoR8Hogw
EfoXL73Hpj4Nv2dxwuKnPDQVGWKXu1divWBeLyV6R3iSqkrgHChaZtYILVof0In0
qnrAEXsznWYUBNfiWribhso9Fk6Bs/jkm9NbK9+2BzImEvAvN5B9jD59ZKeZRVKE
D4SQR+JmXoUAqXI10iC09ITMP+OKclP2aye3cC+5WGHWz7/mp3p9iOa6NglZAwbZ
+F9rXo85vzluURkL4+/+I6sMdjgfrVcSPvNRko1D6tkp4hc/pvLi/cWAzDWo+yhf
veOwwJ0z8+TxFlYF93ES9yBSTZnmAzsYiy+0ADO3bw9KeYEG8wA/Xdj8Ybye8H+P
qC1/BMXIhyI5jh7H7zNHrMoOnzXlURK685zkSrxxG3ExG7tfILxtZdxkBT9GEutt
sV97+jThSSqA3i2ixpwvDGAz9oQxrkRIo3nBMhIKdQvIv7Y1IKO+D+FeDhZIUH99
2HTOHE+zC/o0ysIQq160gZ9g6E47ThpXIIfjiOtGefW+VkbZIxeiMlN4yu2t90Gr
GRVUTiyMiTOZST4JjPivRz21fRAzDhWx5u0PeILPrLTplayAsCWeggxBhFMXQNuM
L0z7QJ4HVoPB8uoj/RmVvdVSEoGgVRR6N/n9qbzvBaqTKcWHkAqsrISOiOumV1m+
p+3XrBBrYrI4RgO2t6oh
=qVHs
-----END PGP SIGNATURE-----

--r4jNezHNW2wfBox+--
