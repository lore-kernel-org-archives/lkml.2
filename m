Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab1H3HXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:23:39 -0400
Received: from swan.madduck.net ([80.68.90.58]:49815 "EHLO swan.madduck.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab1H3HXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:23:37 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Aug 2011 03:23:37 EDT
Date: Tue, 30 Aug 2011 09:14:07 +0200
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Abysmal I/O scheduling with dm-crypt
Message-ID: <20110830071407.GA8165@albatross.gern.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux wheezy/sid kernel 3.0.0-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear list,

for years I have been plagued by the following problem, and it is
almost out of last resort that I am turning to you. I have searched
the web over the months. There is talk of dirty_ratios, of caches,
and of write throttling, but I have not been able to find a way to
fix the problem.

I am using encrypted filesystems (dm-crypt) and the 3.0.0 kernel.
Underneath might be a RAID1 or a fast SSD. On top is usually LVM
with a few LVs holding the system.

Whenever an I/O-intensive task starts, such as:

  - tar -c or -x
  - dd
  - rsync
  - notmuch
  - =E2=80=A6

the system becomes unusable for several seconds at a time, at least
once or twice per minute. What seems to happen is that Vim or the
Shell or Firefox or whatever else completely blocks, waiting for
I/O, but Linux is not satisfying those I/O requests because it's
busy servicing the aforementioned I/O-intensive task. As a result,
Vim or the Shell or Firefox or whatever do not update, forcing me to
wait for them to get an I/O service slot.

People not running dm-crypt seem unable to reproduce this problem,
making me think that it must be due to dm-crypt, and I wouldn't find
it hard to imagine, because dm-crypt basically shields the
I/O-scheduler of the kernel, doesn't it? Worse, it probably doesn't
make any effort of scheduling I/O itself. Note: I know very little
about the internals, so please correct me if I am wrong.

I am wondering if this is the case, and if so, what could be done
about it.

Do you have any ideas and/or concrete suggestions?

PS: http://bugs.debian.org/635768 was the latest incarnation of my
    attempts to solve this problem (I accidentally wrote notmuch
    when I mean to write awesome in that report=E2=80=A6).

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"gilmour's guitar sounds good
 whether you've got a bottle of cider in your hand
 or a keyboard and a mouse."
                                                -- prof. bruce maxwell
=20
spamtraps: madduck.bogus@madduck.net

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQLvBAEBCgDZBQJOXI28wBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xInK
EACpQlFs2QFBEyXAg5oIxRaAM1fdYMDhN6BlZhCDKrbR5GPjJ7Lo6s0Rx/CsG27f
+DEzI1/VAxZc8YJIuxWDJ+EhYsb4UEnxaZSOduTlJ8ZSGzSfbMlbvVkc75bUBEym
Jl9Bl4V0tmzbaGt1pETJDEnoTF5F8NsjevfZ33py98fEBPgE3nCnJNvp8ywd7/Nu
CZHzebeFqyYrmhYnCwDOsXa9brTI7IDPcXPqaQBAVfeQab8AzLFCUpRQR+zO+nXH
DiJqi3JO7s8/zWlx9DsloasdUa9rerwyzgCKHZc8PY+wZ55tSB9jiP2oQe1qgvAQ
yjQickC5j8LJzvjUdwZANh/9MAHSgXphsxphfRujs/k4Fqhn/BJH+uhrWNeXmJM2
Fi35PSAozaxtapFnwmn5LwHnBufgAofzvSQ76Tcbp8NPVg3ktmnRzCqZwtrdJtOL
8SBf2UvYsetezUMe2dAfpWlC9KbSRupLBgddVJq8EHvOyLURucRcf07axIE6pyXa
Z4Lk5SBMHPF0ZGtlWGKXfjodST3OnRR5HQkeONJmqR7Ap/xnHy+O9diresFIDy9q
68XwP09MLPmn3eIw9fHJmxnfl2Wn0il4HgjPXEmLJBszhOKfoykgZOVsHLW/ZTxL
NYJw5N7eZImvfRnd4gOxdqm3sWmIB6mNKOrsxQFV+j73oA==
=99X1
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--

