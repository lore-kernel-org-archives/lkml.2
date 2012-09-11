Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab2IKF6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 01:58:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab2IKF6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 01:58:35 -0400
Date: Tue, 11 Sep 2012 15:58:20 +1000
From: NeilBrown <neilb@suse.de>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>, Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, drbd-dev@lists.linbit.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
Message-ID: <20120911155820.74f1f918@notabene.brown>
In-Reply-To: <20120910233159.GE19739@google.com>
References: <8439412.RChiDciQdh@fat-tyre>
	<20120904224620.GB9092@dhcp-172-17-108-109.mtv.corp.google.com>
	<3029802.oqG0dEY71l@fat-tyre>
	<20120905084915.GF3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120905100724.GA27527@soda.linbit>
	<20120906212952.GP29092@google.com>
	<20120907084221.GD7028@soda.linbit>
	<20120910225442.GE7677@google.com>
	<20120910230654.GF7677@google.com>
	<20120910233159.GE19739@google.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Jw=60H___5Tf7jFB8TqIxye"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Jw=60H___5Tf7jFB8TqIxye
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012 16:31:59 -0700 Kent Overstreet <koverstreet@google.com>
wrote:

> cc'ing Neil
>=20
> On Mon, Sep 10, 2012 at 04:06:54PM -0700, Tejun Heo wrote:
> > Hello, again.
> >=20
> > cc'ing Kent and Vivek.  The original thread is at
> >=20
> >   http://thread.gmane.org/gmane.linux.network.drbd.devel/2130
> >=20
> > On Mon, Sep 10, 2012 at 03:54:42PM -0700, Tejun Heo wrote:
> > > > We can possibly work around that by introducing an additional submi=
tter thread,
> > > > or at least our own list where we queue assembled bios until the lo=
wer
> > > > level device queue drains.
> > > >=20
> > > > But we'd rather have the elevator see the FLUSH/FUA,
> > > > and treat them as at least a soft barrier/reorder boundary.
> > > >=20
> > > > I may be wrong here, but all the necessary bits for this seem to be=
 in
> > > > place already, if the information would even reach the elevator in =
one
> > > > way or other, and not be completely stripped away early.
> > > >=20
> > > > What would you rather see, the elevator recognizing reorder boundar=
ies?
> > > > Or additional higher level queueing and extra thread/work queue/wha=
tever?
> > > >=20
> > > > Both are fine with me, I'm just asking for an opinion.
> > >=20
> > > First of all, using FLUSH/FUA for such purpose is an error-prone
> > > abuse.  You're trying to exploit an implementation detail which may
> > > change at any time.  I think what you want is to be able to specify
> > > REQ_SOFTBARRIER on bio submission, which shouldn't be too hard but I'm
> > > still lost why this is necessary.  Can you please explain it a bit
> > > more?
> >=20
> > The problem with exposing REQ_SOFTBARRIER at bio submission is that it
> > would require block layer not to reorder bios while passing through
> > stacked adrivers until it reaches a rq-based driver.  I *suspect* this
> > has been true until now but Kent's pending patch to fix possible
> > deadlock issue breaks that.
>=20
> Yeah, you might be right about that. I think Neil Brown would know
> better than I if this ordering was ever explicitly broken.

While don't deliberately re-order bios just for the fun of it, there is no
real effort to keep the bios "in order" (assuming that even means something
in a multi-processor environment).  The old barrier code did impose ordering
but thankfully we don't have that any more.

RAID5 can certainly re-order write bios as it tries to assemble complete
stripes.  RAID1/4/5/6/10 can certainly re-order things if there is an error
that needs to be handled.

The only way to ensure one request completes before another is to not submit
the other until the one has completed.

NeilBrown


>=20
> But I don't think anything else is relying on that kind of ordering any
> more.
>=20
> >   http://thread.gmane.org/gmane.linux.kernel.bcache.devel/1017/focus=3D=
1356250
> >=20
> > As for what the resolution should be, urgh... I don't know. :(


--Sig_/Jw=60H___5Tf7jFB8TqIxye
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIUAwUBUE7S/Dnsnt1WYoG5AQLSrQ/2OmdxjUZftkMVkVyYSsXJeoabX9soiGl4
hzwBWXM6eZupS0b1OEa3q/nzY+BLs3rDYfDmmXVOJ5a9myDkQxSzWpFFk28KpTSs
PYLCg3TcbBmxqh9qIohrLhBMXpZyUMq+4IERD1V2tw7TP8w7PcipC/T3ptUYcTUR
yE8s1j7mXucFfjAuIqmvBKpjJqWTm3de5kExLonW/wCvWMokEq194kIkFqfROPso
Oef5mOn1usvZlvLRf9PT7+95GLYBck6eJtr58TrTLUPJJfH942q0hXbHAf6Ui05I
0tnbzBwOY4V0Qtl2Drc6wbTASSOM5g01i9TiCF0RAHGve4h2khuGZeLLd3aLQoOm
tcDdwSCjfMTTBQ9c4ixl36EBHP97KeaR4D+VD1NE8hQqaXEYwAhpmwuTNpjm31AV
/riH1t5HKS55NCJ1Iz9+0bn/BM/nX2rBHUWfchME1kuZw+DDufWw+7lD8pBtddYr
V7CFfOtjmvH2cCfkgNYr/ljkFxa3aP2EIFQZeTBU8JvlYOq4mcW4ASR9zg24HVhE
UqoDNr99AIN8zYpMh4Q6jSoLNlr4fQ2fmyhoK7cUFFCkffKnico8n5UczM/t6AmL
6mufQocsW4Sq6fjnFDWYAb07+P9deN+JZ5ZkIkFY+4SHmEmNljc+mguLk5peN34l
KKT+w8pvpQ==
=5qFD
-----END PGP SIGNATURE-----

--Sig_/Jw=60H___5Tf7jFB8TqIxye--
