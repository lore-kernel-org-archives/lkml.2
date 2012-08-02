Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2HBQlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:41:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:39361 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab2HBQlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:41:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="176249980"
Message-ID: <1343925930.25013.163.camel@sauron.fi.intel.com>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com
Date: Thu, 02 Aug 2012 19:45:30 +0300
In-Reply-To: <20120802183210.7076aa48@spider.haslach.nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	 <1343916747.25013.112.camel@sauron.fi.intel.com>
	 <20120802161512.5ac7a303@spider.haslach.nod.at>
	 <1343917741.25013.114.camel@sauron.fi.intel.com>
	 <20120802165132.1bf1e5d7@spider.haslach.nod.at>
	 <1343924267.25013.156.camel@sauron.fi.intel.com>
	 <20120802183210.7076aa48@spider.haslach.nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-IhLBQdzXFe/FmfaN8Tue"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IhLBQdzXFe/FmfaN8Tue
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Richard,

On Thu, 2012-08-02 at 18:32 +0200, Richard Weinberger wrote:
> > This should not happen. Fastmap should _reserve_ enough of PEBs for it
> > to operate. It should always find the PEB to write.
>=20
> What is the benefit?
> IOW what is wrong with the current approach?

Several reasons. The main is: fastmap will start consuming PEBs reserved
for volumes when the amount of available PEBs is just enough to map all
LEBs. This will break UBI liability.

> Why?
> If everything goes wrong, fastmap makes sure that no fastmap is on
> flash.
> In case of a powercut we fall back to scanning mode.
> R/O mode is overkill IMHO.

So can I interpret this the following way. Not only fastmap give no
guarantees that it exists after an unclean reboot, it does not even give
guarantees that it exists after a clean reboot.

Unless I am confused, the fastmap design is over-simplified.


--=20
Best Regards,
Artem Bityutskiy

--=-IhLBQdzXFe/FmfaN8Tue
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQGq6qAAoJECmIfjd9wqK0w5sP/R0Lhh2KGl2j6ictpIiDn4pU
lxLBsBEyUYmKGEX0etKFPI/e431PzU+ifzRQUH2OTUz7SiCFjjr6u7YSp3feczY2
FmVomzLXH1L4R5xEJyCc6zhuUiIe9BpLCJqNJkkiA++ufjdvv44RCsMjItwgRLQj
XTgjiAH2snOYwnNgMdmbbtkzynMuKvZmFp/BR2gXfyIVcwXqpw6T6zeH7AzTAbf8
uqTxuHXpCuLIo0f2wNvUBFe3fDo5l/+sRjF4mKWYl26E+QuUfLw/JuPW/oULP0rT
H1dVH9d98FEEkDTTW5R2Ea/hz9aORhIdXjOefyP6hrW+C7je4NeplG6Pu2IY39KG
MUNt0U8ERmJQ7BpxG8Zj0KxteylHNI1ZJwmqvacXVTxMOzqROzNphAqn7bwFAq7l
xdyBOj/g6opIxxLxArUwt1e8I41rrLhM5Wj4kA6uNQnsHgHibbRTOwykTzypna1k
AQv8bC44BbMBEOVFDiti6un/o9ub9AUav698JpC/rbwm6W7+cKu3BYXAklB0k2t6
60kzOTwtL7KI3Dg/wyyUGef24AElNigF70NVfPLxHa0CW5zbMcblHNod1WUSyX4i
PxW67tCUC+HTe3Drv2svPpT5QpVI+oZD10xzzRZHLC7xtNl8hJQTWl+dp1ocBIcD
vRFa/Ehk+BmirkKuCja2
=rhGe
-----END PGP SIGNATURE-----

--=-IhLBQdzXFe/FmfaN8Tue--

