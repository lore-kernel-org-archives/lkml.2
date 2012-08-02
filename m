Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2HBQNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:13:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:52582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab2HBQNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:13:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="192521308"
Message-ID: <1343924267.25013.156.camel@sauron.fi.intel.com>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com
Date: Thu, 02 Aug 2012 19:17:47 +0300
In-Reply-To: <20120802165132.1bf1e5d7@spider.haslach.nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	 <1343916747.25013.112.camel@sauron.fi.intel.com>
	 <20120802161512.5ac7a303@spider.haslach.nod.at>
	 <1343917741.25013.114.camel@sauron.fi.intel.com>
	 <20120802165132.1bf1e5d7@spider.haslach.nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-r3APHlI1W52wjr76ZZHo"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-r3APHlI1W52wjr76ZZHo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-02 at 16:51 +0200, Richard Weinberger wrote:
> Every time fastmap writes a new fastmap to the flash it tries to get a
> new PEB and returns the old one (used for the old fastmap) back to the
> WL sub-system.

OK.

> If no free PEBs are available (E.g Volume is full or the erase worker
> is too slow) ubi_wl_get_fm_peb() returns NULL and fastmap reuses the
> currently used PEB.

This should not happen. Fastmap should _reserve_ enough of PEBs for it
to operate. It should always find the PEB to write.

Just like if you create a volume maximum possible size, we guarantee
that you can fill it with data, and UBI will find enough PEBs for that.

Just like we always have enough PEBs for the volume table.

The above things are UBI's liabilities.

In the situation when a lot of PEBs became bad, UBI will switch to R/O
mode with a scary message if it notices that it does not have enough
PEBs to satisfy all the liabilities.

And this is why we reserve 2% of PEBs for bad PEBs handling.

> In this situation ubi_wl_get_fm_peb() may trigger such an error message.
> If think we should get rid of the message as this is not an error
> condition. It's a well known execution path.

Unless I am confused, this should lead to switching to R/O mode instead,
just like we do when we write to an LEB and do not find a PEB to map to.

--=20
Best Regards,
Artem Bityutskiy

--=-r3APHlI1W52wjr76ZZHo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQGqgrAAoJECmIfjd9wqK07h4P+wcZxuQO1HnPNOwX3S9ncuGl
s7YniZNcjifHfnQcvnB7gBqUU2dD2tkOp57dshAOH58rTq1cm4tLxgUv9Y3SsE8r
FZqAjx3By4Ut4vHVW23O9QMhRoi2gzDdjHfHpCBE4XG3hxmUNDRN7Ave/ynT/+HH
Q7/F3rJdFavH5EHbzoDDayouR0Q4bfedoBhKzdEa4wqya7tUlhaprlPQRisPHeji
6goXL4XvZobEYHwZRSgTkbQSJgQp6Gx3a35BFv6QsOxwFhWTIFZCNa/ak+NVhJSW
LgqpPJ8YYLnqSYaho7LRyUwv1GX2u474otMus88xChT/7YwKIUQ3dZpWWXjSCtAt
6regcFX6JltcL9pLR6KoEUAlomdnKH0kvHNkkH8REyf9LbiJStzqQdsxaitMcmra
4x2jQIqwJ7FzDcQNqbfnWmyy3PCxohu7qMxQSJJnfoZZj8acFuVFhQbFNovQOEye
a7SiZm4v2yUYmh3jTRtmeOcry6PAyF2a/RmS/jGRt4y4tzNe/3FPPeq3VBl8k5Ld
Q4WIO/9RqqOfX9p1Br9F9lc8aEbzOkgJcCZolawP8AsCjoSR07x0Xb4NtE4rH+J7
fmhfI3p6TkA6hwvr4hAtA1yjHym6vxqbzpG50MPEUCwl4S5OgvXOKdQrUYJ/Zz/P
t+2M7g+KWAqjEniMeVys
=axHX
-----END PGP SIGNATURE-----

--=-r3APHlI1W52wjr76ZZHo--

