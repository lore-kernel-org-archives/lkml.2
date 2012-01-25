Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2AYNoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 08:44:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49398 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab2AYNoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 08:44:09 -0500
Date: Wed, 25 Jan 2012 13:44:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] regulator: Reverse the disable sequence in
 regulator_bulk_disable()
Message-ID: <20120125134406.GL3687@opensource.wolfsonmicro.com>
References: <1327491338-18817-1-git-send-email-s.nawrocki@samsung.com>
 <20120125115705.GF3687@opensource.wolfsonmicro.com>
 <CADkCAuudPtdb04HXMgHzgDpFWrr9xPJu3yMRe9pE4YDLD+_cUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KaGhPsiNaI6/sRd6"
Content-Disposition: inline
In-Reply-To: <CADkCAuudPtdb04HXMgHzgDpFWrr9xPJu3yMRe9pE4YDLD+_cUw@mail.gmail.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KaGhPsiNaI6/sRd6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 25, 2012 at 02:35:25PM +0100, Bill Gatliff wrote:
> On Wed, Jan 25, 2012 at 12:57 PM, Mark Brown
> > On Wed, Jan 25, 2012 at 12:35:38PM +0100, Sylwester Nawrocki wrote:

> > guarantees about ordering - in particular when we do the enable we fire
> > off a bunch of threads to bring the regulators up in parallel so the

> Presumably, then, the notifier mechanism will remain positive
> confirmation that the associated regulator has indeed come up?  And

The notifiers are called after the enable has finished, yes.

> that multithreading thing will be interesting to implement given
> parent-child relationships of regulator sources at times...

This multithreading thing is already implemented, and has been since
v3.1.  It's pretty trivial, it just fires up a bunch of threads in
parallel to call the underlying regulator_enable() API which already
needs locking to handle concurrent users anyway.

> > Whatever driver inspired you to submit this change is therefore probably
> > buggy or fragile at the minute - is it something that's in mainline or
> > next right now?

> I think he's probably dealing with a "VLOGIC <= VDD"-type requirement,
> which isn't uncommon.  I'm dealing with it myself right now, actually.

I'd imagine so, that's one of the common cases for requiring sequencing,
but if the driver is using the bulk APIs for this then it's buggy.

> In addition to the sequencing that imposes, it also has implications
> for recalculating VLOGIC when VDD changes--- which means a notifier
> somewhere.  I might be convinced that implementing this logic inside
> the API itself might be of benefit, though I don't see right now how
> to do it in a clear and generic way.

I can imagine a bulk set_voltage() that applied constraints and unwound
things when they went wrong but actually working out the values doesn't
feel generic.

> >> The alternatives to directly modifying regulator_bulk_disable() could be:

> I really don't have a problem with the disable order being the reverse
> of the enable order, as it generally follows common sense for people
> who work with e.g. multiple mutexes.  I kind of would have expected it
> to be that way, actually.

Right, that's why I applied the patch - I'm just saying we might not
actually wind up implementing that ordering due to the concurrency.

--KaGhPsiNaI6/sRd6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPIAcbAAoJEBus8iNuMP3d2R8P/16t2R4PZWILyd9aV7kHTVnW
k2EyK3NpK133TkRNHBMr643agWhhFYoYUX4OIyAEwzZP/537pxkUlVYAbACkR8km
/V7FUMlbYpLp58zKyy3JiCe3wyysRCuI2X1k8mbivH+ALarZtFntaz+a6K9Ht9QY
u3JwXz1F+ziyd53wdhdSuesPCV/xY+l7haIIVscbRNqEtw4p+rJy8uNYdymA4s67
8HadOJHbzFWXzO6ZmAIAgjXYozI14rRkxxgDFzBFX3A3d4YUqjCoKM1R6nBKIrU5
eqYQwLVMkJQ3QtMTzhUtM0aiTk4lvPz4Jak7qnbGlKcwMDOHNdUD5wFnlNoijSgK
9Lfj8Cv4lMaKI2MRtqJ9UuR28EIdzzyM5FvC2Qk6PJhaCuDDirkO2lkz4PHE2Jji
ZzbMXkp7oAAFl4UAr2S40sG1YSdLoyMuXhGVScOptXrtQ1FoHCK06iVJZh46QnFP
XUdX1AZblOpfxEYHhUTsGS/mmiKTjTiJ+vbacF8UGGxHHh/x1QfOQboOlFgchXz7
1Y7LQSR4epyK4XfGZHLpYWxNeYgRBlVePn9nBeKeNC70E9aeqg51i7AczYKuegOs
HmMdE1dhu2N6w9znZQKWUsqUTJ1Bs6URuYgshW9ZR4s/RIleeERCP66Ff5fmacls
eLn+JDrepYEftpm3pxms
=jQCx
-----END PGP SIGNATURE-----

--KaGhPsiNaI6/sRd6--
