Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab2DTSsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:48:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38380 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757421Ab2DTSsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:48:10 -0400
Date: Fri, 20 Apr 2012 19:48:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
Message-ID: <20120420184806.GA3092@opensource.wolfsonmicro.com>
References: <20120419124204.GE3046@opensource.wolfsonmicro.com>
 <CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
 <20120419162905.GA3084@opensource.wolfsonmicro.com>
 <CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
 <20120420114602.GB3259@opensource.wolfsonmicro.com>
 <CAJe_ZhdKv_7fTj9ZhJE0JzmuhxEZn-JmSbHu615YMXoWZUei9A@mail.gmail.com>
 <20120420130134.GA5957@opensource.wolfsonmicro.com>
 <CAJe_ZhdKtK8YKo1qc8g18XrdnrQRZw2aFSkW8x3koELU10EsHw@mail.gmail.com>
 <20120420144256.GA6828@opensource.wolfsonmicro.com>
 <CAJe_ZhdzuHo8P5WHguKMaikht8aN4RU-j_Q9FB+xOSw=roFZ=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <CAJe_ZhdzuHo8P5WHguKMaikht8aN4RU-j_Q9FB+xOSw=roFZ=w@mail.gmail.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 20, 2012 at 11:55:22PM +0530, Jassi Brar wrote:
> On 20 April 2012 20:12, Mark Brown <broonie@opensource.wolfsonmicro.com> =
wrote:

> > No, they're here to stay - people will always be bringing up new boards
> > after all - but they're not supposed to be used on platforms.

> "some time in future" means utopia.... whenever that be. The longer that =
is
> to more important is it for dummy support to be 'complete'.

Well, for any given board it's very quick to resolve.  It's just that
=66rom time to time people will break things and then they'll get annoyed
(and probably spend forever complaining on the lists rather than the
brief time taken to make the patch).

> > In any case, as I've said it's not the fact that you've got a dummy
> > supply that's an issue for most of the cases you mention - it's the fact
> > that the supply is always on.

> I am not sure anymore you read my posts :(
> I am more bothered by the case where the supply is always off i.e,
> physically absent.

It's not what you first mentioned...  In any case, the solution is very
clear - just do proper regulator support and turn off dummy regulators
and everything is fine.

> > Even in the case where a supply might genuinely be missing (which are
> > very unusual, it's more effort in silicon to cope with missing supplies)

> It's not that unusual.  See vcc_aux at line 150 of omap_hsmmc.c

No, really - that's exceptionally unusual and quite honestly given the
"discussion" surrounding the addition of the regulator support there I'm
not convinced that anything the driver is doing here is sane; the whole
stuff with regulator_get_exclusive() never made any sense for MMC in the
first place (and has now been removed).

> See how dummy fools the driver throughout into stuff like toggling vcc
> even for platforms that don't really provide vcc_aux.
> In practice, see how dummy affects (negatively because of unnecessary
> toggles) the vcc too.  Not every platform with omap_hsmmc might afford
> having dummy disabled (I don't know all to tell for sure).

The fix here is in the boards, not with the dummy code.  Open coding
handling of this sort of stuff in individual consumers is just insane,
and you're always going to run into the situation where you don't know
if the dummy regulator is there because the board setup is incomplete or
because someone left the option turned on when it shouldn't be.

What you want here is something like regulator_get_real_no_really()
which never returns a dummy regulator but the whole thing is just adding
fragility onto bodge.  I'm not overly concerned if systems don't run as
efficiently as they might when using dummy regulators because (like I
say) they're just a crutch to keep systems running.

Note also that the performance improvement stuff I sent the other day
will help here, the bounces will be very cheap now.

I'd much rather remove the feature than start going down this rabbit
hole, it's just going to be a world of pain and fragility.  But then a
whole different bunch of people will complain.

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPka9gAAoJEBus8iNuMP3dAB0P/ixmwMF8zEtfRi9ayLB4Cu8F
/JKjjuIRG1aA/os9zqiQa5lEiJjslA6GjebZAXkRBoYSartY6YeYTE5ip5RLwAFn
4kJLIp9LAX5f6mGH5ju078ddnW0/KZJuJD1S0OC4bYcJYUzrE/aEEx8i2ZHF0ukx
QJLqXV2F/zyaP8q0llIYPethuGltoEr1jHWyO+xYAhdGfRvpoOKEIvAJQmp1BzKz
3yN/5fV4Rj8V+CnCqUW4YT91QGIyvUNtPbMN89z6FYtnayBu3eLsDpw4d0byckiP
gqJrBNThEWXPzOaZbrBPzUt3RFZXa19GTCe0FjnrEFE10CuauQGW/sliAIWLeS90
i9CMk2Q4gLaLt6Po0+8MbJk7eJqHW0TGl1x1PmKiWmjLajtGs179FCup7dGh+qI3
/F0D/uHoKfsyxupJEdMo+cGHyT8EsXbBYEyCiJ0YjsbhS2+vdwbDXUBj0ZuqCqDa
0qaSGHgIsW5atyXZCQ8/SS+OoeKzGMdlbIfEX3od871kylOQxxBM1eYX/KfzbaC1
8qH6h7o+TV/ZVSWDXDhmgd46hZGgZsgEaMwClVpJQMJboVSmlbE4uk+gkoce+84q
Fkzo72UKOA6Xq1Vyf3jiZbawvpgpPodtk5PGUmwxxaMF54Fn1nA3NWcB+jnGfNOg
h5JgobZXe+yWUfLuKXrU
=ZK6U
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
