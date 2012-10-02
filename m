Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2JBHjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:39:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab2JBHjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:39:45 -0400
Date: Tue, 2 Oct 2012 17:39:28 +1000
From: NeilBrown <neilb@suse.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/3] Volatile Ranges (v7) & Lots of words
Message-ID: <20121002173928.2062004e@notabene.brown>
In-Reply-To: <1348888593-23047-1-git-send-email-john.stultz@linaro.org>
References: <1348888593-23047-1-git-send-email-john.stultz@linaro.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hk9CXA/NFkYmH0Yl2ERrvbE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hk9CXA/NFkYmH0Yl2ERrvbE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Sep 2012 23:16:30 -0400 John Stultz <john.stultz@linaro.org> wro=
te:

>=20
> After Kernel Summit and Plumbers, I wanted to consider all the various
> side-discussions and try to summarize my current thoughts here along
> with sending out my current implementation for review.
>=20
> Also: I'm going on four weeks of paternity leave in the very near
> (but non-deterministic) future. So while I hope I still have time
> for some discussion, I may have to deal with fussier complaints
> then yours. :)  In any case, you'll have more time to chew on
> the idea and come up with amazing suggestions. :)

Hi John,

 I wonder if you are trying to please everyone and risking pleasing no-one?
 Well, maybe not quite that extreme, but you can't please all the people all
 the time.

 For example, allowing sub-page volatile region seems to be above and beyond
 the call of duty.  You cannot mmap sub-pages, so why should they be volati=
le?

 Similarly the suggestion of using madvise - while tempting - is probably a
 minority interest and can probably be managed with library code.  I'm glad
 you haven't pursued it.

 I think discarding whole ranges at a time is very sensible, and so merging
 adjacent ranges is best avoided.  If you require page-aligned ranges this
 becomes trivial - is that right?

 I wonder if the oldest page/oldest range issue can be defined way by
 requiring apps the touch the first page in a range when they touch the ran=
ge.
 Then the age of a range is the age of the first page.  Non-initial pages
 could even be kept off the free list .... though that might confuse NUMA
 page reclaim if a range had pages from different nodes.


 Application to non-tmpfs files seems very unclear and so probably best
 avoided.
 If I understand you correctly, then you have suggested both that a volatile
 range would be a "lazy hole punch" and a "don't let this get written to di=
sk
 yet" flag.  It cannot really be both.  The former sounds like fallocate,
 the latter like fadvise.
 I think the later sounds more like the general purpose of volatile ranges,
 but I also suspect that some journalling filesystems might be uncomfortable
 providing a guarantee like that.  So I would suggest firmly stating that it
 is a tmpfs-only feature.  If someone wants something vaguely similar for
 other filesystems, let them implement it separately.


 The SIGBUS interface could have some merit if it really reduces overhead. =
 I
 worry about app bugs that could result from the non-deterministic
 behaviour.   A range could get unmapped while it is in use and testing for
 the case of "get a SIGBUS half way though accessing something" would not
 be straight forward (SIGBUS on first step of access should be easy).
 I guess that is up to the app writer, but I have never liked anything about
 the signal interface and encouraging further use doesn't feel wise.

 That's my 2c worth for now.  Keep up the good work,

NeilBrown


--Sig_/hk9CXA/NFkYmH0Yl2ERrvbE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGqaMDnsnt1WYoG5AQKIgQ//bj4bJrK+vrhnPB66LJQK0zxKa84GsSD7
svXgIJc/r89cfL4h/B3KwLv3F/CheSe9UIO1+S7RcU9nOBsyUUPmbgwzs1AG6CZb
bculntNvEImqi5W/nEpzMaPZBu8VZKl5JZNvB3zN+lZV2ZMgMjXC5CS65kzE9KqI
wUvW1r/DZNrF3h5hiNc7DelVWr1H30eFFUdpDDUL25N5KsttZ7Uj9dbndD2V1QBP
6FrXzgLAqc+akXF3/kmu8DSDGDtpQMS/kzaNAR9Y4e3jZNwqEfE/0Pi6hwxL5F5J
ov7k707vqqjAmvfs/Gp+dEdzcvJwTvROEKmgEhUifEahpUosUYPVsb1d05SPWLFX
+ifMHKi71uSrb+cIBlK7uNm/MJ0qnHHRzjJ6rDXaRSZ6DYg4d91iC8eOEq0GVt8p
nh+CN+VxlE9HCzGZShdxQJmkw8BtSTLOs+gE13ZR63k2vrpbOOr6XDmXf7CheNox
u+OVai6+eqg5NURrP7lOKlQzIFZc+eLfm7nXpKZGX+ae4QudkK3UFTIBz/TsnPOp
FkRkO+lfR8jqE/lwpDyzRdFhn9CcDGyTDpun9+W2gm2boEqNu/r6B3B10hHFIMK7
qPmHB1L9N9g6U/Xt65m1EVz677M8gI7qEdblyIOt1tjU4lu+SO51eQgY2e1pyDUl
f1e/pwv9iuA=
=6Daf
-----END PGP SIGNATURE-----

--Sig_/hk9CXA/NFkYmH0Yl2ERrvbE--
