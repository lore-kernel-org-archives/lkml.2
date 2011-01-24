Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1AXOf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 09:35:26 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:33474 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1AXOfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:35:25 -0500
Date: Mon, 24 Jan 2011 15:35:18 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Patrick McHardy <kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: netfilter: marking IPv6 packets sends them to the wrong
 interface
Message-ID: <20110124143518.GA2616@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20110123122108.GA30305@darkside.kls.lan>
 <4D3D82D1.6050305@trash.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <4D3D82D1.6050305@trash.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 24, 2011 at 02:46:57PM +0100, Patrick McHardy wrote:
> On 23.01.2011 13:21, Mario 'BitKoenig' Holbe wrote:
> > Without marking everything runs as it should be.
> > Marking eth0 packets results in all advertisements transmitted via eth1.
> > The behaviour goes back to normal as soon as the marking disappears.
> > I also tried marking with 0xff00 instead of 1 - same results.
> That probably means that we're not using the correct keys
> when rerouting in ip6_route_me_harder(). Just for testing,
> please try to disable the ip6_route_me_harder() call in
> net/ipv6/netfilter/ip6table_mangle.c::ip6t_mangle_out().

Yes, disabling the ip6_route_me_harder() call in ip6t_mangle_out()
results in the advertisements being transmitted on the correct
interfaces.


Mario
--=20
I thought the only thing the internet was good for was porn.  -- Futurama

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTT2OJhS+e2HeSPbpAQKMvQf/b8mSHiKJnarNyI94b7ReRh92QZB0w5Bs
pvy/CJ6wgk9M2MxoVlJYI/QF3Ys5jGnkURDEvcyo/Moi863t+7xX4IsLE4gB/jqw
bDwMRHToITovKuE/pWqR3flHQEhMwAtCMI8QHrJcLicY/hpsltsj7TDnP3XHIVYn
AMUoY0aLe8EWkPHLNfSBGOE2t5SYRTolsexyBdA9K4184HERRkIozKj3DMg6AgMM
suF3D6olTdYN6poJLkPYMp/ZRECriO1e9b10hc0AV8hXrn65pGKXGrwCNP6mljpW
edO6dOcpY4h4juXuCAaTcIbMJut3GPfbQnou/y0rICVluT6it0uIJQ==
=G19Y
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
