Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab2LLV1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:27:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36388 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab2LLV1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:27:46 -0500
Date: Thu, 13 Dec 2012 08:27:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mel Gorman <mgorman@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Automatic NUMA Balancing V11
Message-Id: <20121213082741.fac1b3fa361a0746bcbe1040@canb.auug.org.au>
In-Reply-To: <20121212100338.GS1009@suse.de>
References: <20121212100338.GS1009@suse.de>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Dec_2012_08_27_41_+1100_B7OSWz9dEzNbgCKp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Dec_2012_08_27_41_+1100_B7OSWz9dEzNbgCKp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 12 Dec 2012 10:03:38 +0000 Mel Gorman <mgorman@suse.de> wrote:
>
> This is a pull request for "Automatic NUMA Balancing V11". The list
> of changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:
>=20
>   Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma.git=
 balancenuma-v11
>=20
> for you to fetch changes up to 4fc3f1d66b1ef0d7b8dc11f4ff1cc510f78b37d6:
>=20
>   mm/rmap, migration: Make rmap_walk_anon() and try_to_unmap_anon() more =
scalable (2012-12-11 14:43:00 +0000)
>=20
> There are three implementations for NUMA balancing, this tree (balancenum=
a),
> numacore which has been developed in tip/master and autonuma which is in
> aa.git. In almost all respects balancenuma is the dumbest of the three
> because its main impact is on the VM side with no attempt to be smart
> about scheduling.  In the interest of getting the ball rolling, it would
> be desirable to see this much merged for 3.8 with the view to building
> scheduler smarts on top and adapting the VM where required for 3.9.
>=20
> The most recent set of comparisons available from different people are
>=20
> mel:    https://lkml.org/lkml/2012/12/9/108
> mingo:  https://lkml.org/lkml/2012/12/7/331
> tglx:   https://lkml.org/lkml/2012/12/10/437
> srikar: https://lkml.org/lkml/2012/12/10/397
>=20
> The results are a mixed bag. In my own tests, balancenuma does reasonably
> well. It's dumb as rocks and does not regress against mainline. On the
> other hand, Ingo's tests shows that balancenuma is incapable of converging
> for this workloads driven by perf which is bad but is potentially explain=
ed
> by the lack of scheduler smarts. Thomas' results show balancenuma improves
> on mainline but falls far short of numacore or autonuma. Srikar's results
> indicate we all suffer on a large machine with imbalanced node sizes.
>=20
> My own testing showed that recent numacore results have improved
> dramatically, particularly in the last week but not universally.  We've
> butted heads heavily on system CPU usage and high levels of migration even
> when it shows that overall performance is better. There are also cases
> where it regresses. Of interest is that for specjbb in some configurations
> it will regress for lower numbers of warehouses and show gains for higher
> numbers which is not reported by the tool by default and sometimes missed
> in treports. Recently I reported for numacore that the JVM was crashing
> with NullPointerExceptions but currently it's unclear what the source of
> this problem is. Initially I thought it was in how numacore batch handles
> PTEs but I'm no longer think this is the case. It's possible numacore is
> just able to trigger it due to higher rates of migration.
>=20
> These reports were quite late in the cycle so I/we would like to start
> with this tree as it contains much of the code we can agree on and has
> not changed significantly over the last 2-3 weeks.

It has, however all been rebased from what still exists in the linux-next
tree (as part of the tip tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Dec_2012_08_27_41_+1100_B7OSWz9dEzNbgCKp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQyPbNAAoJEECxmPOUX5FEhzgP/jYfYm54LPsdXUNYymFjh6xC
oDX4cA4eDQo9Pu1v/hRQHikiVLTdveaIuyOMng+eSb9JCALFVl8olW5bxBmOmo/1
H7v5Rai6tLsWKqGesnBKA24QcIT8JKFZ4moCDqWcWfQ9JhV8dXnl5rBsL2Y7QKvN
Cr8nvSlVDF6RiCrsPTG/qdt+59du+5KJgig67YY/lJmjxB108gpY5v6J12Yb2Nrf
lLD1JCqTC90j3FoBoQhiJqDhOj2DtSCGjQHYAXXSAehgMBRIOBaMELWoGoygRhvv
0rC6bAGiKxkOg5UQbYMZUfjRiVSdXXia9lmXpYhm4JGcWfSpgnIx9jzokCKD431u
CYPBMP41TzOQyqC2m88g5UZ2q2FLZgrTs48xDIuuX1kcfFClMkjLmxhHZvJxfFRr
kmfm4+aEIWGF6hOMyUSvLr40/Ko7+XePtJe1Jc6xyuWTFK+DDL0gxzkaqhvs4drt
rbEhJX9A4RR8EqCiC4N4noKlG+E/bCV8fogvypOrAjjij+PwP7VC6nnV7Z+N4eLL
3d+5xXjI4W7RgTsiZWHHtYwTIxA4N7G4wDKPwJvaWWb0pt/V0AAV/rOwgCEZ6ZZR
UF2/2RJZmt3j8uIxYLPuvAYLBxKfF4UWyb2nglM1fN68t2y2RjSpXDg4dbgDUhDP
Ho00bi7OP8ur+E3dGBFU
=1Dbj
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Dec_2012_08_27_41_+1100_B7OSWz9dEzNbgCKp--
