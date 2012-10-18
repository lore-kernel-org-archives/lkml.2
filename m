Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2JRKXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:23:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2JRKXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:23:45 -0400
Message-ID: <507FD8AA.50500@canonical.com>
Date: Thu, 18 Oct 2012 12:23:38 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de
Subject: Re: [tip:sched/core] sched: Fix race in task_group()
References: <1340364965.18025.71.camel@twins> <tip-8323f26ce3425460769605a6aece7a174edaa7d1@git.kernel.org> <CAE5mzvjPXAZdOi1p8AB47zOQzgAErBU66gAS8spnpOs+=-+azA@mail.gmail.com>
In-Reply-To: <CAE5mzvjPXAZdOi1p8AB47zOQzgAErBU66gAS8spnpOs+=-+azA@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigFFDC2738258993D489844527"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFFDC2738258993D489844527
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 18.10.2012 10:27, cwillu wrote:
> On Tue, Jul 24, 2012 at 8:21 AM, tip-bot for Peter Zijlstra
> <peterz@infradead.org> wrote:
>> Commit-ID:  8323f26ce3425460769605a6aece7a174edaa7d1
>> Gitweb:     http://git.kernel.org/tip/8323f26ce3425460769605a6aece7a17=
4edaa7d1
>> Author:     Peter Zijlstra <peterz@infradead.org>
>> AuthorDate: Fri, 22 Jun 2012 13:36:05 +0200
>> Committer:  Ingo Molnar <mingo@kernel.org>
>> CommitDate: Tue, 24 Jul 2012 13:58:20 +0200
>>
>> sched: Fix race in task_group()
>>
>> Stefan reported a crash on a kernel before a3e5d1091c1 ("sched:
>> Don't call task_group() too many times in set_task_rq()"), he
>> found the reason to be that the multiple task_group()
>> invocations in set_task_rq() returned different values.
>>
>> Looking at all that I found a lack of serialization and plain
>> wrong comments.
>>
>> The below tries to fix it using an extra pointer which is
>> updated under the appropriate scheduler locks. Its not pretty,
>> but I can't really see another way given how all the cgroup
>> stuff works.
>>
>> Reported-and-tested-by: Stefan Bader <stefan.bader@canonical.com>
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Link: http://lkml.kernel.org/r/1340364965.18025.71.camel@twins
>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>=20
> I just finished bisecting a crash on boot to this commit; booting with
> "noautogroup" brings it back.
>=20
> 3.5.4 is the latest -stable that still boots, and none of the 3.6 rc's
> boot at all.
>=20
> Photo of the bug (3.6.0next is 3.6 + btrfs's for-linus):
> https://lh5.googleusercontent.com/-0DY-YYhgvzs/UHdB-BQdzMI/AAAAAAAAAEg/=
QhY9rgxnv98/s811/2012-10-11
>=20

On a very quick glance I wonder whether there might be a case where sched=
_fork
goes into set_task_cpu with a different cpu than the current but has not =
yet
task_group.sched_task_group set to something valid...



--------------enigFFDC2738258993D489844527
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBCgAGBQJQf9iqAAoJEOhnXe7L7s6jXGYQANoHhRafySzjbpZUW0nj8IBf
mC+Z1+VC4TfZIr2LQX/uw6Sw8amYcgivwr9b0ET2FOXTeO2Ntha/MOacJXibJIMd
w8CjkubfbfZvbzSHgOhpiFDw4gcQlqD2VjvE1fx6xdpLGtYqWjjDW9GZHBXAOcfK
NaMKyPO6j60yoQyq/jG+UW00ZTtGwxbcJXKtKyYil7iG/CH6I9P8f5tD+5n+pqwR
rTl7IdcQKkmDcAfLc+FFEasMX0LC5DnGptquZ2BzCHaUeFYswmtcAcL5kRWZAIe4
W2Iy5esCh6zONfanFUlYM1gIV7Q9i1SaRgoiQ4jWlUVs1vUGk3Qpq8+BSZLWtmVf
0QyLpJzFCmlm/xti45qLztz5rmtTLUZ4dnGigVkdMoBkE92usTRVMZm/69FnWxfQ
Rh4WlBZ2ZrErTsr7KbpV777NzUvMhrct3tPgXWJOTdS2ymrQ9cKL351GW8+LJAXV
WMPQcEdnrdBqpYMLCa24yFKLfUIt/ECVx7mFgRyyif0IPisTk1WvpBl92uzaZ8PK
SWmmJX5jJe9NHiJD3r0lm/PtoZsYB4oQsRLJuwihYRXupuqyjKX2LLGRU1FBQDe2
M5QB81m3cYz3JRbwSTM6BbTOjv2RrW2M2+dQc+L4yYz/xUmbhii8l8DiAAzgy3Aa
mrYikgfdxYx2KufaI4Z6
=bjGF
-----END PGP SIGNATURE-----

--------------enigFFDC2738258993D489844527--
