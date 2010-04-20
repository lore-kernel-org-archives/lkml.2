Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0DTUDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:03:11 -0400
Received: from mail.copilotco.com ([216.105.40.123]:33609 "EHLO
	mail.copilotco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab0DTUDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 16:03:10 -0400
Date: Tue, 20 Apr 2010 13:03:10 -0700
From: Tracy Reed <treed@ultraviolet.org>
To: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: xen-devel@lists.xensource.com, Aoetools-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] domU is causing misaligned disk writes
Message-ID: <20100420200310.GR5660@tracyreed.org>
Mail-Followup-To: Tracy Reed <treed@ultraviolet.org>,
	Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
	xen-devel@lists.xensource.com,
	Aoetools-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20100420080958.GN5660@tracyreed.org>
 <20100420084955.GV1878@reaktio.net>
 <20100420193952.GP5660@tracyreed.org>
 <20100420195442.GC1878@reaktio.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IlmwW192PJ8CjiJ7"
Content-Disposition: inline
In-Reply-To: <20100420195442.GC1878@reaktio.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IlmwW192PJ8CjiJ7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2010 at 10:54:42PM +0300, Pasi K=E4rkk=E4inen spake thusly:
> Please try with "bs=3D1024k" and maybe with "bs=3D64k" aswell.
> =20
> 4k blocksize transfer will always be slower in domU than in dom0
> since virtual disk abstraction makes some overhead, which is more
> visible with small blocksizes.

But overhead in domU wouldn't be causing all of these reads. I am
doing a test with bs=3D64k now:

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz
avgqu-sz   await  svctm  %util
sda               0.00  3258.20 964.00 54.00  3903.20 13652.80
34.49     2.75    2.71   0.68  68.88
sdb               0.00  3270.20 974.80 54.00  3940.80 13710.40
34.31     2.42    2.38   0.55  56.22

> So the speed is the same to the partitioned disk than to the raw disk?=20
> What disk backend are you using in dom0? phy:? tap:aio: ?

Yes.=20

I am using phy: disk backend. Should I be using something else?

--=20
Tracy Reed
http://tracyreed.org

--IlmwW192PJ8CjiJ7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFLzgh+9PIYKZYVAq0RAj+EAKCgFWRIhdF2z9MAfb5JqqS/84kbrwCeKf3h
4tuevARQqS5DJkalfRYDpFg=
=QmcF
-----END PGP SIGNATURE-----

--IlmwW192PJ8CjiJ7--
