Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2DHUaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 16:30:39 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab2DHUai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 16:30:38 -0400
Message-ID: <4F81F564.3020904@nod.at>
Date: Sun, 08 Apr 2012 22:30:28 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: linux-mm@kvack.org, paul.gortmaker@windriver.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: swapoff() runs forever
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC5366DC4EF9D255FD0AF3754"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC5366DC4EF9D255FD0AF3754
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi!

I'm observing a strange issue (at least on UML) on recent Linux kernels.
If swap is being used the swapoff() system call never terminates.
To be precise "while ((i =3D find_next_to_unuse(si, i)) !=3D 0)" in try_t=
o_unuse()
never terminates.

The affected machine has 256MiB ram and 256MiB swap.
If an application uses more than 256MiB memory swap is being used.
But after the application terminates the free command still reports that =
a few
MiB are on my swap device and swappoff never terminates.

Here some numbers:
root@linux:~# free
             total       used       free     shared    buffers     cached=

Mem:        255472      13520     241952          0        312       7080=

-/+ buffers/cache:       6128     249344
Swap:       262140      17104     245036
root@linux:~# cat /proc/meminfo
MemTotal:         255472 kB
MemFree:          241952 kB
Buffers:             312 kB
Cached:             7080 kB
SwapCached:            0 kB
Active:             3596 kB
Inactive:           6076 kB
Active(anon):       1512 kB
Inactive(anon):      848 kB
Active(file):       2084 kB
Inactive(file):     5228 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:        262140 kB
SwapFree:         245036 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          2296 kB
Mapped:             1824 kB
Shmem:                80 kB
Slab:               2452 kB
SReclaimable:       1116 kB
SUnreclaim:         1336 kB
KernelStack:         192 kB
PageTables:          556 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      389876 kB
Committed_AS:     238412 kB
VmallocTotal:    3788784 kB
VmallocUsed:          68 kB
VmallocChunk:    3788716 kB

What could cause this issue?
I'm not sure whether this is UML specific or not.
Maybe only UML is able to trigger the issue...

Thanks,
//richard


--------------enigC5366DC4EF9D255FD0AF3754
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPgfVlAAoJEN9758yqZn9emQ0H/2ldqm+CUGOd3cNvazaGJhQl
AchUlj/lsgDcuMrW7RZC+IDTRDjmWoyUgrMr9WXyQ1bMNu1CDiB9vsunGqn3ROyq
Mp0zQPqg0OCfQWMLmW2Je5/jjxQVk4myYCUZp0KIKUHG9tK/LiyQE7PsOr3Mi6EI
VtBsdjO8Y0Ka++fZBE0tsv16Ok9QJd5GovxSm9w+djAXV1wxK7Lc71JFMx+w5Fi0
B5lZHQHUQ/RgKEH8qT4Q7TqX1BIY/xoFS8Wo5bQnML5PzTzLdlaX0x7/ExWrDGj4
j3OwN3wKqBz2+7wf7+9MQ8jv5jpDCwS+pYr2gBt8u/5pughFh3xsB6sjWEHAbfw=
=6Wvw
-----END PGP SIGNATURE-----

--------------enigC5366DC4EF9D255FD0AF3754--
