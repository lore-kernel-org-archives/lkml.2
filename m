Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab2BXPRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:17:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047Ab2BXPRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:17:45 -0500
Message-ID: <1330096655.26569.22.camel@atropine>
Subject: Re: [PATCH] drm: Reduce the number of retries whilst reading EDIDs
From: Adam Jackson <ajax@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Date: Fri, 24 Feb 2012 10:17:35 -0500
In-Reply-To: <CA+55aFyAUgY5BBLA+eVF4bFTFkooxQneKE-0BWy1nrjUni=vxg@mail.gmail.com>
References: <CA+55aFxO27oa+WAtDLuWtr-NFNmKb2T0V6pccn=AE+g5PePPUg@mail.gmail.com>
	 <1330026771-19937-1-git-send-email-chris@chris-wilson.co.uk>
	 <CA+55aFyAUgY5BBLA+eVF4bFTFkooxQneKE-0BWy1nrjUni=vxg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-LNXy8NS34izb/+DfYEse"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LNXy8NS34izb/+DfYEse
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-02-23 at 12:15 -0800, Linus Torvalds wrote:

> Btw, clearly X does *not* cache the EDID results, at least not for
> this case. So the explicit xrandr example is probably pretty close to
> what wine does. Maybe the proper fix is to just make X.org force
> caching when clients do this (because it's definitely X that does the
> drm_mode_getconnector() thing - xrandr itself spends zero time on
> this, it just does an X request and waits for the result).

RANDR exposes two requests here for a reason.  We used to only have
RRGetScreenResources which always pulled data afresh.  We added
RRGetScreenResourcesCurrent to get the cached version.  If you want
xrandr(1) to use the latter say xrandr --current.  Arguably xrandr
should do things the other way around and require you to say --reprobe
or something.

Even then, the kernel should cache if it can.  And any competent
hardware has plug interrupts on DP and DVI, so we really should get this
right.

- ajax

--=-LNXy8NS34izb/+DfYEse
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9Hqg8ACgkQW4otUKDs0NM/XACfXXyznC7tb5O01KyqOdRk5Xul
3eYAoMiARUruSD5lCytmP8AV7FApTasL
=9dGB
-----END PGP SIGNATURE-----

--=-LNXy8NS34izb/+DfYEse--

