Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab1CJRyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:54:54 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:44070 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1CJRyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:54:53 -0500
Date: Thu, 10 Mar 2011 18:54:12 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Andi Kleen <ak@linux.intel.com>
Cc: dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-crypt: Performance Regression 2.6.37 -> 2.6.38-rc8
Message-ID: <20110310175411.GB25027@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Andi Kleen <ak@linux.intel.com>, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>
References: <20110308164508.GA8729@darkside.kls.lan>
 <20110310165730.GC20504@alboin.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20110310165730.GC20504@alboin.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 10, 2011 at 08:57:30AM -0800, Andi Kleen wrote:
> On Tue, Mar 08, 2011 at 05:45:08PM +0100, Mario 'BitKoenig' Holbe wrote:
> > I'm running a 4-disk RAID0 on top of 4 independent dm-crypt(aes-xts)
> > devices on a Core2Quad 3GHz. This setup did overcome the single-CPU
> Do you actually use dd for production or is this just a benchmark?

The array is streaming most of the time, i.e. single-process sequential
read or write (read mostly) for large chunks of data.
So, no and yes, but...

> (if yes: newsflash: use a better benchmark)

this makes dd quite a valid benchmark for me in this case.

> It will be better with multiple processes running on different CPUs.=20
> The new design is really for multiple processes.

Of course it is. What bother me is that I can't get back my old
performance in my case whatever I do.

I don't know what kind of parallelism padata uses, i.e. whether a
padata-based solution would suffer from the same limitations like the
current dm-crypt/kcryptd-parallelism or not.

Wth the current approach:
Would it be possible to make CPU-affinity configurable for *single*
kcryptd instances? Either in the way to nail a specific kcryptd to a
specific CPU or (what would be better for me, I guess) in the way to
completely remove CPU-affinity from a specific kcryptd, like it was
before?


Mario
--=20
There is nothing more deceptive than an obvious fact.
             -- Sherlock Holmes by Arthur Conan Doyle

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTXkQQxS+e2HeSPbpAQLT+AgAmDizJdzSW7yIlJMm99YpPb8uZmMXKcCQ
y4n+DWslnVCDhneQtxCzip0IIzBVnGwuxXkE8/EtlL6PsEgwTSAVLU8MfrW2kWKS
Iqw+NZJWGxWXaIbtRtk8ORAhXFekHtuGyvMrrkndSL8ClPIzN3ulAq+ZKo0zjeGA
WpvZ2ou0rf4PvIs8ucPPUUY8jcDTeRmeh0t7oX148yc0ORcoJXqzfBaJX1sCWncN
RULJL8ND97U6KXlsSooCBcNjvUncqsz1k/kVopjqShM6nEYaAEkv+AIGz9Z7ONt5
nU96WV09lweGBUscPdKSuffaAUYtDau94Eu6IdYCRIGwdn9srcyrJw==
=pqGo
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
