Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2IYLRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:17:43 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:35484 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754777Ab2IYLRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:17:39 -0400
Date: Tue, 25 Sep 2012 14:12:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, "Poddar, Sourav" <sourav.poddar@ti.com>,
        gregkh@linuxfoundation.org, khilman@ti.com, paul@pwsan.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, linux-serial@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
 suspended.
Message-ID: <20120925111243.GR9137@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
 <20120925083029.GG31374@n2100.arm.linux.org.uk>
 <20120925083118.GI9137@arwen.pp.htv.fi>
 <20120925091228.GI31374@n2100.arm.linux.org.uk>
 <20120925091112.GK9137@arwen.pp.htv.fi>
 <20120925092118.GJ31374@n2100.arm.linux.org.uk>
 <20120925094815.GL9137@arwen.pp.htv.fi>
 <20120925102958.GL31374@n2100.arm.linux.org.uk>
 <20120925103652.GN9137@arwen.pp.htv.fi>
 <20120925110703.GN31374@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pa4xkLBhPDIhDLv1"
Content-Disposition: inline
In-Reply-To: <20120925110703.GN31374@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pa4xkLBhPDIhDLv1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 25, 2012 at 12:07:03PM +0100, Russell King - ARM Linux wrote:
> On Tue, Sep 25, 2012 at 01:37:03PM +0300, Felipe Balbi wrote:
> > On Tue, Sep 25, 2012 at 11:29:58AM +0100, Russell King - ARM Linux wrot=
e:
> > > Because you are accusing me of potentially breaking your beagleboard
> > > for merely suggesting further investigation and a better commit messa=
ge.
> >=20
> > Where did I accuse you of anyting ? I just mentioned we experienced a
> > regression with beagleboard XM when using pm_runtime_set_active().
>=20
> I quote:
> :> But should we cause a regression to beagleboard XM because of that ?
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

maybe that wasn't the best way to put it, but I was trying to point out
that either there was a bug on pm core or omap_device/hwmod, not that we
shouldn't investigate.

> I say again: I was _only_ suggesting further investigation, yet you
> were mouthing off about causing a regression to beagleboard "because
> of that", effectively saying that no, we should not do any further
> investigation and this is the only fix.

not what I meant, but fair enough... The "because of that" was supposed
to mean "because of pm_runtime_set_active()". I find the documentation
for that particular call to be rather poor and a bit confusing,
specially when further down, the very same document uses a
"is_suspended" flag which, in fact, shouldn't be needed when we have
pm_runtime_is_suspended() and the like.

> > We pinged Paul and asked if he had seen that before, he had no
> > pointers... Because Documentation/power/runtime_pm.txt was using a
> > mystruct->is_suspended flag, we just decided to follow the same
> > "design" since no-one was able to suggest why pm_runtime_set_active()
> > was breaking beagleXM nor how it was supposed to actually work.
> >=20
> > Reading the code: pm_runtime_set_active() would tell pm_runtime core
> > the device is actually active by setting runtime_status to RPM_ACTIVE,
> > thus the following pm_runtime_get_sync() wouldn't actually call
> > runtime_resume() callback, but it would increment usage_counter.
> >=20
> > I can't see why this would fail on beagleXM, but it does and we'd like
> > to hear in which situations this could fail...
>=20
> Well, I've just spent five minutes analysing the code paths - which I
> hadn't looked at before - and I've pointed out what's probably causing
> the problem for Beagle.  I think you owe me an appology over your
> aggressive attitude towards my suggestions that there needed to be
> some further investigation.

I don't see any aggressive attitude towards what you suggested,
actually. Mailing list archives are available to check, but the one
cursing around was always yourself and THAT deserves an apology.

If you still think I've been at all aggressive, then sure, I apologize,
it wasn't what I meant though.

--=20
balbi

--Pa4xkLBhPDIhDLv1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQYZGrAAoJEIaOsuA1yqREEy0P/ihCb0Nuoyylswpo2d6ipgVv
w6ZxiUHig9valXqxMU8raJWo+sJuR7+7Fz1cQriGxDvNqbzcjbzd9cagm9dpFsyW
SG26rIFUc9eHNys2JMGjFbvhWH9MY7pDE4Q79F1F/uOQvkTN9cUNhIL7m+9oCDKc
s/7y7KE64ApLgtE22GqbOjfbQ3AfpRlFPpnnZJQmCu7GiBNaYy2ozaPhfvEQ+9P/
mtfByon4bsCf5BMybqsWj+62YuheoI7hoZNRCe2ns8XX8ceMIeivaU3UU5I75Bib
QpG/+umdFHIfl7NvdHJbKwCfK4b0w3oA9UE5zQ/UMUjUd+c9Oyre+e9t0ozJ56J3
N/6fi9B6KICIRhzt0csae4IuhrSo0c22mmhNshGeiJjXHYtBIN9UJ+G7uh9Wyer9
vLhfWjXSj5PzomQdOF8sjwc+i1oImMxjqlghhuh3UGhgAdBDVH66yKkiUNwwRrtG
EiMkQfFzJgoRkWMy8AgLCdIRuagKKWmzUKXF3CM5/CzlRLQ45hSE3MoJ4odASatF
aU3F3X/cTC8CicC5Up6XrJn6EscMXSo8Nylz6LFusNwpD3U1NyJpMndDwhOh62Xo
wpXkf60AOKDrPuKgiX++IpDFyahsmae6O5iDc4Pr+61gLCCK33MJ8TQSKEsPt/pA
apeiDrfX3EM57lrMP+57
=DpY1
-----END PGP SIGNATURE-----

--Pa4xkLBhPDIhDLv1--
