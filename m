Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab1BOVUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 16:20:37 -0500
Received: from eastrmfepi101.cox.net ([68.230.241.197]:38419 "EHLO
	eastrmfepi101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab1BOVUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 16:20:35 -0500
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Feb 2011 16:20:35 EST
X-VR-Score: -200.00
X-Authority-Analysis: v=1.1 cv=72mwMHry7RVIehb2GilHRvg51L14SqmocFmEXpMAk0g=
 c=1 sm=1 a=4UV-9Kl2S54A:10 a=UFf5x1fKmGVfY+5MkVsK7Q==:17 a=oGMlB6cnAAAA:8
 a=8pif782wAAAA:8 a=qhgeTVs5YOj12Lg6C_8A:9 a=j-ZIYDFsFUdIfLF5U7QA:7
 a=Qsgym4f3QbBoBbIlA5cmyFHHOH0A:4 a=CjuIK1q_8ugA:10 a=CY6gl2JlH4YA:10
 a=cKZJf8hrtHtSonyQ:21 a=zmfYgE4bM3GyqYVF:21 a=azUtSEKio4gRhm_uCAAA:9
 a=6b70LVxBGgZ9_-ncTRV3tEBuXAsA:4 a=UFf5x1fKmGVfY+5MkVsK7Q==:117
X-CM-Score: 0.00
Authentication-Results: cox.net; none
Date: Tue, 15 Feb 2011 16:11:23 -0500
From: Will Simoneau <simoneau@ele.uri.edu>
To: Will Newton <will.newton@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt@console-pimps.org>,
        David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        peterz@infradead.org, jbaron@redhat.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110215211123.GA3094@ele.uri.edu>
References: <1297707868.5226.189.camel@laptop>
 <1297718964.23343.75.camel@gandalf.stny.rr.com>
 <1297719576.23343.80.camel@gandalf.stny.rr.com>
 <20110214.134600.179933733.davem@davemloft.net>
 <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
 <4D59B891.8010300@zytor.com>
 <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 [Linux 2.6.37-rc4+ x86_64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:01 Tue 17 Feb     , Will Newton wrote:
> On Mon, Feb 14, 2011 at 11:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 02/14/2011 02:37 PM, Matt Fleming wrote:
> >>>
> >>> I don't see how cache coherency can possibly work if the hardware
> >>> behaves this way.
> >>
> >> Cache coherency is still maintained provided writes/reads both go
> >> through the cache ;-)
> >>
> >> The problem is that for read-modify-write operations the arbitration
> >> logic that decides who "wins" and is allowed to actually perform the
> >> write, assuming two or more CPUs are competing for a single memory
> >> address, is not implemented in the cache controller, I think. I'm not a
> >> hardware engineer and I never understood how the arbitration logic
> >> worked but I'm guessing that's the reason that the ll/sc instructions
> >> bypass the cache.
> >>
> >> Which is why the atomic_t functions worked out really well for that
> >> arch, such that any accesses to an atomic_t * had to go through the
> >> wrapper functions.
> >
> > I'm sorry... this doesn't compute. ?Either reads can work normally (go
> > through the cache) in which case atomic_read() can simply be a read or
> > they don't, so I don't understand this at all.
>=20
> The CPU in question has two sets of instructions:
>=20
>   load/store - these go via the cache (write through)
>   ll/sc - these operate literally as if there is no cache (they do not
> hit on read or write)
>=20
> This may or may not be a sensible way to architect a CPU, but I think
> it is possible to make it work. Making it work efficiently is more of
> a challenge.

Speaking as a (non-commercial) processor designer here, but feel free to po=
int
out anything I'm wrong on. I have direct experience implementing these
operations in hardware so I'd hope what I say here is right. This informati=
on
is definitely relevant to the MIPS R4000 as well as my own hardware. A quick
look at the PPC documentation seems to indicate it's the same there too, an=
d it
should agree with the Wikipedia article on the subject:
http://en.wikipedia.org/wiki/Load-link/store-conditional

The entire point of implementing load-linked (ll) / store-conditional (sc)
instructions is to have lockless atomic primitives *using the cache*. Proper
implementations do not bypass the cache; in fact, the cache coherence proto=
col
must get involved for them to be correct. If properly implemented, these
operations cause no external bus traffic if the critical section is unconte=
nded
and hits the cache (good for scalability). These are the semantics:

ll: Essentially the same as a normal word load. Implementations will need t=
o do
a little internal book-keeping (i.e. save physical address of last ll
instruction and/or modify coherence state for the cacheline).

sc: Store a word if and only if the address has not been written by any oth=
er
processor since the last ll. If the store fails, write 0 to a register,
otherwise write 1.

The address may be tracked on cacheline granularity; this operation may
spuriously fail, depending on implementation details (called "weak" ll/sc).
Arguably the "obvious" way to implement this is to have sc fail if the local
CPU snoops a read-for-ownership for the address in question coming from a
remote CPU. This works because the remote CPU will need to gain the cacheli=
ne
for exclusive access before its competing sc can execute. Code is supposed =
to
put ll/sc in a loop and simply retry the operation until the sc succeeds.

Note how the cache and cache coherence protocol are fundamental parts of th=
is
operation; if these instructions simply bypassed the cache, they *could not*
work correctly - how do you detect when the underlying memory has been
modified? You can't simply detect whether the value has changed - it may ha=
ve
been changed to another value and then back ("ABA" problem). You have to sn=
oop
bus transactions, and that is what the cache and its coherence algorithm
already do. ll/sc can be implemented entirely using the side-effects of the
cache coherence algorithm; my own working hardware implementation does this.

So, atomically reading the variable can be accomplished with a normal load
instruction. I can't speak for unaligned loads on implementations that do t=
hem
in hardware, but at least an aligned load of word size should be atomic on =
any
sane architecture. Only an atomic read-modify-write of the variable needs to
use ll/sc at all, and only for the reason of preventing another concurrent
modification between the load and store. A plain aligned word store should =
be
atomic too, but it's not too useful because a another concurrent store would
not be ordered relative to the local store.

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1a6/sACgkQLYBaX8VDLLXlTwCeIYQN1Aw82NNtO4jj+j8slg7P
CeEAnjHU/OTozPVLLmwKvzz6+g2HcQ6Z
=X3HF
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
