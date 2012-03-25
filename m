Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab2CYWXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 18:23:35 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59640 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab2CYWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 18:23:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.4-dev
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: fix mount -t proc -o AAA
In-Reply-To: Your message of "Sun, 25 Mar 2012 19:36:12 +0400."
             <20120325153612.GC4391@albatros>
From: Valdis.Kletnieks@vt.edu
References: <201203220903.15360.a.miskiewicz@gmail.com> <20120323171058.GA3279@albatros> <20120323161504.dced28b9.akpm@linux-foundation.org> <201203250924.06908.a.miskiewicz@gmail.com>
            <20120325153612.GC4391@albatros>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332714196_1934P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 25 Mar 2012 18:23:16 -0400
Message-ID: <97428.1332714196@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4F6F9AD7.008D,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1332714196_1934P
Content-Type: text/plain; charset=us-ascii

On Sun, 25 Mar 2012 19:36:12 +0400, Vasiliy Kulikov said:
> On Sun, Mar 25, 2012 at 09:24 +0200, Arkadiusz Miśkiewicz wrote:
> > but there is another problem - unmounting it and mounting without options
> > causes old option to persist:
> >
> > # mount none /proc -t proc -o hidepid=2
> > # umount /proc
> > # mount none /proc -t proc
> > # grep "/proc" /proc/mounts
> > none /proc proc rw,relatime,hidepid=2 0 0
> >
> > There should be no hidepid=2 now.
>
> No, that's an expected behaviour.

"You keep using that word. I do not think it means what you think it means". ;)

> Procfs is a special filesystem.

And the fact it's "special" makes this *unexpected* behavior.  Are there
any other filesystems where -o values will persist across an unmount
and then take effect *even if no -o is given* on a subsequent mount?

Yes, it may be what the code actually *does*, but it certainly violates
the Principle of Least Surprise...

--==_Exmh_1332714196_1934P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2+a1AdmEQWDXROgAQLnpg//XZfP9m/rCaml8IHgHOAYDjOwzSubea/m
QYT9jYP2ueZIupqAC1j6vdhV948VZj6+aJrxXcloUnFP2gF25pdPV4Ar0EAi11O2
Wtsk70BbypX/k7GPDDeDbdNHe9XBOmrCKTIOhXg4UYbj2tgceJL/DJlmDhjVEzEc
TPJTu1MxDCuta9Ooas2379YKBwTa/xHiOUZpHiyhgIRZgqmMb6zZfgSgKhErzHGK
L87G5ayXdKzBZ4/h+yyQkZ+D8JiTJMflUSpZJLeRufQtqHUQbCcSfIzB4sMBBFFA
Q4rZe9nQssqv/1Wgp/XEq+jmQQe2A46N2veHZiJk9WTxL+L5r390ZtZZuW90JqRa
XYi6SIJRGfApER8ebzuOnU+7V1lSmhFwzDrWdv2+fOYmu/RjLZ0WJS6qMIDV4oky
Rcsq8Wvzv41ocLjG94JXqMben8GYsEMUR2vX0FcknUzzwfT2A9ouV4MO9nbluHaK
SBSxoR4PN2zfME7PpqvfDw4kVViSpr7Ok3v2dP6i8JYqlzbuRvkbQEIwOYsyFbHL
VP4ttQXcGF+wrVHO8PNmw1I02XrLPgZocgoXangk75iVJpEDX/D+07HURzjncSAC
MPXxiGkl6scJJhxPU8p37XB+OmvRRU2tE10Pjqm+JlRQXOAm58iR8eo8kzWbClvn
OhJPei3XwY4=
=GWe5
-----END PGP SIGNATURE-----

--==_Exmh_1332714196_1934P--

