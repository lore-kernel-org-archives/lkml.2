Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2GDEg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 00:36:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42714 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab2GDEgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 00:36:24 -0400
Message-ID: <1341376578.4852.172.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 07/48] mm: fix slab->page _count corruption when using slub
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Pravin Shelar <pshelar@nicira.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pravin B Shelar <pshelar@nicira.com>,
        Amey Bhide <abhide@nicira.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrea Arcangeli <aarcange@redhat.com>
Date: Wed, 04 Jul 2012 05:36:18 +0100
In-Reply-To: <20120702234610.GB3552@herton-Z68MA-D2H-B3>
References: <20120701172006.535271340@decadent.org.uk>
	 <20120701172007.694144055@decadent.org.uk>
	 <20120702234610.GB3552@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-a9GRI+mhXkpInxRljXVA"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a9GRI+mhXkpInxRljXVA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-02 at 20:46 -0300, Herton Ronaldo Krzesinski wrote:
> On Sun, Jul 01, 2012 at 06:20:13PM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Pravin B Shelar <pshelar@nicira.com>
> >=20
> > commit abca7c4965845924f65d40e0aa1092bdd895e314 upstream.
> >=20
> > On arches that do not support this_cpu_cmpxchg_double() slab_lock is us=
ed
> > to do atomic cmpxchg() on double word which contains page->_count.  The
> > page count can be changed from get_page() or put_page() without taking
> > slab_lock.  That corrupts page counter.
> >=20
> > Fix it by moving page->_count out of cmpxchg_double data.  So that slub
> > does no change it while updating slub meta-data in struct page.
>=20
> Hi,
>=20
> I got a frozen machine on boot with 3.2.22 proposed patches, bisect
> pointed out to this commit (and reverting only this commit on top of
> 3.2.22 patches confirmed it). So far I was able to reproduce always.
[...]

Sorry, I should remember to test with SLUB whenever there's a patch that
touches it!  I'll drop this for now, given Pravin's feedback.

Please let me know when this is completely fixed in mainline and ready
to be cherry-picked/backported.

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-a9GRI+mhXkpInxRljXVA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/PIQue/yOyVhhEJAQqFyQ//SmqqWP6Nym8+0wWrb+tRuqPFcwih8JRk
7o++28PDDydqY/tC9moS+S3gXgKCfLOu2bdNPLBHZjpW3uCxifXBoU6ts+mXg+Z6
3Motv0agN0lA0tokxqicrHuTnDAwWAXgw5asW66PWZb77VXWjcB3q/0LnD43b0vu
KRL8mPjpEAgO3gK/c7Pr6vM7Jc3hRt4noEqDgS9opdNYhQsgixChC5sqMTj9b0vQ
tcV/SNXz4KG6sDCU9lTxmACkbxd6HrSh8LEkqkw7AMjFntBPU2pgfvAFpRXrjv76
bZU5bd5Bk3vOiH8kNP0vniCJrEnJ1HJ8lLQF7djwg8kz+9q9Yx3upFokJBAkMyA4
bQBK2bJtLj2NWR3eSV+ljjdg0Fl2PTX+VpdLgwtOTwzuR8r5SASzUU7aLP8zS/8b
A7EuWh3BZ1RklWBw2C24eKwV1Shliv6Ml+Hu5uJnv+UFPgte81nKhLukgqN/7F6h
cIV5HMZGvu89viZ/HGkxR+bUIMQ3v7+64W1l20WTtFGmeV8CaOnPgVQA+UgewcqM
+wKe5GikuJWfdKXpr4l84Kzo19AoEi+yBy9xM9h81MTQX07xkpb+oyqTnLMdcdyT
jv1ZE75pV7jMuuU2zB22K7XPUt03Q+4DX10Odxk1tggJIks1126vGfekYj3vVh9+
V07amnhMg6A=
=IwCQ
-----END PGP SIGNATURE-----

--=-a9GRI+mhXkpInxRljXVA--
