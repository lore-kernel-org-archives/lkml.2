Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab2BXOvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:51:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47119 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755673Ab2BXOvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:51:35 -0500
Date: Fri, 24 Feb 2012 14:51:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Set delay to 0 if set_voltage_time_sel
 callback returns error
Message-ID: <20120224145132.GO5450@opensource.wolfsonmicro.com>
References: <1330067866.27530.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncX6roZrNNHXnAbh"
Content-Disposition: inline
In-Reply-To: <1330067866.27530.1.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncX6roZrNNHXnAbh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 24, 2012 at 03:17:46PM +0800, Axel Lin wrote:

>  			delay = rdev->desc->ops->set_voltage_time_sel(rdev,
>  						old_selector, selector);
> +			if (delay < 0)
> +				delay = 0;

We should complain if we get an error rather than silently ignore it,
possibly we'll end up returning prior to the ramp finishing which may
break things.

--ncX6roZrNNHXnAbh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR6PuAAoJEBus8iNuMP3dLG8P/RI0IY/xmfJs0maRESbbfKly
CKvyaqzTYi33ejkNJ1iwe1MtgB/x6cMMhcpuZQWEYElj7c5UVkYPW7hfIF6kao3z
cpYDukeHE/NaSidqmgQRM7aJTiHU0BFiFSw46DZ5FYA/r3U9Q9JXtGupa9bEdXqD
XZDQFjwWKIGXwbhe6A9UbuK9vWI+298N2oMYNE4DsVkB72uHPKNICBuljge8KKzT
x6zbzo07xFN+gZWzkjF0dO+ufRb3+sYI8bTaZkZE2wJ16r1u9JJZi5fNcj6R1ycp
HzGRSjhbkiFyoB35wsGUz543oC/gfeyBKBDr6+ERYO5DBMbH/M8NBUn5fgW+0B6j
bKnQwHF8M+2F/rb+QU/Fh66P1GV4L8jai49awXSiPokU0dZhS0e32va7l/3oUcsd
FutE95dNUtjPfdwwtuMTT+IWNhyoKxeZICGQs1Svq4Je+Cmzn6p8VbuNtVo3ai5q
wclKKxKrfGbITmQFR3CEmIfmlgUG366Pd8DkuskSK9ylqX07ZcRvSJnJOY7ZCza2
GY2/+Q5hBVEj8s2WiRs0Zj3qB+jTK1w7b16G7Y8cfXdsWkons54rmJqS1s4X559I
S0xQN2f2hFjEnXaudNeoKTXd/2vy3keKabFF2v2PPC4JteSmkmiow6jnxRVsbEdw
zqXjXesEY3MGaQV40tzQ
=Qr9U
-----END PGP SIGNATURE-----

--ncX6roZrNNHXnAbh--
