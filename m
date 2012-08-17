Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2HQNHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:07:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:60755 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab2HQNHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:07:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,784,1336374000"; 
   d="asc'?scan'208";a="182211886"
Message-ID: <1345209115.27859.84.camel@sauron.fi.intel.com>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com
Date: Fri, 17 Aug 2012 16:11:55 +0300
In-Reply-To: <1341836323-43916-1-git-send-email-richard@nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-+RQFhelgzX44+h1ZQMRM"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+RQFhelgzX44+h1ZQMRM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-09 at 14:18 +0200, Richard Weinberger wrote:
> This is the next round of UBI fastmap updates.
> It fixes all issues pointed out by Shmulik. :-)
>=20
> If you want to test fastmap you can use my git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v17

One thing which just came to my mind why looking at other MTD e-mails. I
do not know if it is relevant for fastmap or not, just want you to
check.

In UBIFS we have we have the "fixup" feature which is used to
work-around dumb flashers which are present in many factories:
http://www.linux-mtd.infradead.org/faq/ubifs.html#L_free_space_fixup

This is because the "correct" UBI flasher should be able to skip empty
space when flashing, see here:
http://www.linux-mtd.infradead.org/doc/ubi.html#L_flasher_algo

So with this fixup flag UBIFS will basically read all its eraseblocks
which have empty spece which it will use, and write them back. Just to
make the empty space writable again. This is done only once on the very
first boot.

We do not do anything like this in UBI because UBI does not need this,
it does not have any complex data structures on the media.

With fastmap - I am unsure. I think it is not a problem, because
probably you never append more data, you just re-write everything,
right?

--=20
Best Regards,
Artem Bityutskiy

--=-+RQFhelgzX44+h1ZQMRM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLkMbAAoJECmIfjd9wqK0ZYgP/RzVGvW82uGMQb2BnfBEcsb9
uUBq3Ne14+I1ARZCHyiw7hOi0XTxNktOfu2jzKQlhRz4tbumAQY0Ex1ujXwO1lL9
9zEQN8EWNbyuzK64R+Uoy420Q9bgI22hS+zZ+rDkYqlw2OhR9AAaIqtSvxJPq+lT
xhO6Fji5o6RIErXewBkBhNUd9CvOskDZ+njPxufvjbJiJzT8CTaCf/wcyq86D0Tc
LiujdEQM+M+VHJ6NUDNuTkwgkTTxSSs0iEu6TXNSVAuA8yuJAukqwuyN6capdIpR
r9d4otRtcQH/x4RVq6mUYkZOoanPHR4WA3G8vjhl8QfZR/o5bvL0LO0saXgXyBkY
XIbzgaLjwzvl+WvGe/CRZmGsiA/dB0qL+tGKfEfYe2l2AOOXe1EVy1Cp/WyeajFF
nSKFJB7zOLHwTlE0Yfs0nZ0xPV6DaaCR0gzwUKTtJJFSvzSHNN81qN4h00R1dxEA
Io2mdmzk2tN+GM/b3rzW4991cMWoAvMRENIScO7AO3L9bcNE6e8e3lNClD/5LGi3
EPLZ5e6WyVyKsRvIIs/GZT/VM/Hxn3u0wSxdK+gqiX9aQbMggKDGmQKMXdSKGuwG
TvFRie/3Y/0huIyHt+jPpaNjXkaEZt51VUYbix1a19JxQ33b4iPemWBKjkizdX30
WNFiD9JpAVuEZsMHB9gj
=03PU
-----END PGP SIGNATURE-----

--=-+RQFhelgzX44+h1ZQMRM--

