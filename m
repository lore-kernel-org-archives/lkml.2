Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2K3KjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:39:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50187 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2K3KjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:39:02 -0500
Date: Fri, 30 Nov 2012 11:38:50 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
Message-ID: <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
 <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
 <50B73710.2040102@nvidia.com>
 <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
 <50B874C7.5030208@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <50B874C7.5030208@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:1kO1S7mvjO5/0N6B0VDfBlbTKIkGuDwEqoYT7JX2i3v
 nqSU4AcmgrR+C/WbwOe51Cwa7l3T4nppiZk90THBH0gtHqKem2
 +KjVSfa5Z48f02oCNZCTxXRvHhwnky2SJ04LqLbxcywCYqh16r
 Uq2uzevOqxATXdPNgbORWtqLT2qq9E9+xyu8Hs/4YNWGlrOmdG
 LCvoR8HRRI7OnSxZ1yaEPJeL7pw4Zn73joGX9XtSraKIjzzFuK
 jg2whKCLP2gEaQGp+ckPTuKw8ZNWWO6iXgIWZ7XRDcLIqOkT/+
 TX0NJj8U1Qd3AO4AkdOGJY2snEDCGTXTtm8tTm+vOaYTR8JOFO
 S/QGp8vH5+JcwTq7woT+a5ccgKmwgFJDI29HGkiUy9LhCkyrYI
 w21BFx9y91s0Hce5xBF5uGWkTihkVcV09c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 30, 2012 at 10:56:39AM +0200, Terje Bergstr=C3=B6m wrote:
> On 29.11.2012 13:47, Thierry Reding wrote:
> > On Thu, Nov 29, 2012 at 12:21:04PM +0200, Terje Bergstr=C3=B6m wrote:
> >> Tegra20 and Tegra30 are compatible, but future chips are not. I was
> >> hoping we would be ready in upstream kernel for future chips.
> >=20
> > I think we should ignore that problem for now. Generally planning for
> > any possible combination of incompatibilities leads to overgeneralized
> > designs that require precisely these kinds of indirections.
> >=20
> > Once some documentation for Tegra 40 materializes we can start thinking
> > about how to encapsulate the incompatible code.
>=20
> I think here our perspectives differ a lot. That is natural considering
> the company I work for and company you work for, so let's try to sync
> the perspective.
>=20
> In my reality, whatever is in market is old news and I barely work on
> them anymore. Upstreaming activity is the exception. 90% of my time is
> spent dealing with future chips which I know cannot be handled without
> this split to logical and physical driver parts.
>=20
> For you, Tegra2 and Tegra3 are the reality.

To be fair, Tegra2 and Tegra3 are the reality for *everyone* *outside*
NVIDIA.

It's great that you spend most of your time working with future chips,
but unless you submit the code for inclusion or review nobody upstream
needs to be concerned about the implications. Most people don't have
time to waste so we naturally try to keep the maintenance burden to a
minimum.

The above implies that when you submit code it shouldn't contain pieces
that prepare for possible future extensions which may or may not be
submitted (the exception being if such changes are part of a series
where subsequent patches actually use them). The outcome is that the
amount of cruft in the mainline kernel is kept to a minimum. And that's
a very good thing.

> If we move nvhost in upstream a bit incompatible, that's fine, like
> ripping out features or adding new new stuff, like a new memory type.
> All of this I can support with a good diff tool to get all the patches
> flowing between upstream and downstream.
>=20
> If we do fundamental changes that prevent bringing the code back to
> downstream, like removing this abstraction, the whole process of
> upstream and downstream converging hits a brick wall. We wouldn't have
> proper continuing co-operation, but just pushing code out and being done
> with it.

Generally upstream doesn't concern itself with downstream. However we
still willingly accept code that is submitted for upstream inclusion
independent of where it comes from. The only requirements are that the
code conforms to the established standards and has gone through an
appropriate amount of review. Downstream maintenance is up to you. If
you need to maintain code that doesn't meet the above requirements or
that you don't want to submit or haven't got around to yet that's your
problem.

If you're serious about wanting to derive your downstream kernel from a
mainline kernel, then the only realistic way for you to reduce your
amount of work is to push your code upstream. And typically the earlier
you do so, the better.

> >> I could move this to debug.c, but it's debugging aid when a command
> >> stream is misbehaving and it spews this to UART when sync point wait is
> >> timing out. So not debugfs stuff.
> >=20
> > Okay, in that case it should stay in. Perhaps convert dev_info() to
> > dev_dbg(). Perhaps wrapping it in some #ifdef CONFIG_TEGRA_HOST1X_DEBUG
> > guards would also be useful. Maybe not.
>=20
> I could do that for upstream. In downstream it cannot depend on DEBUG
> flag, as these spews are an important part of how we debug problems with
> customer devices and the DEBUG flag is never on in customer builds.

So I've just looked through these patches once more and I can't find
where this functionality is actually used. The host1x_syncpt_debug()
function is assigned to the nvhost_syncpt_ops.debug member, which in
turn is only used by nvhost_syncpt_debug(). The latter, however is
never used (not even by the debug infrastructure introduced in patch
4).

> >> I like static inline because I get the benefit of compiler type
> >> checking, and gcov shows me which register definitions have been used =
in
> >> different tests.
> >=20
> > Type checking shouldn't be necessary for simple defines. And I wasn't
> > aware that you could get the Linux kernel to write out data to be fed to
> > gcov.
> >=20
> >> #defines are always messy and I pretty much hate them. But if the
> >> general request is to use #define's, even though I don't agree, I can
> >> accommodate. It's simple to write a sed script to do the conversion.
> >=20
> > There are a lot of opportunities to abuse #defines but they are harmless
> > for register definitions. The Linux kernel is full of them and I haven't
> > yet seen any code that uses static inline functions for this purpose.
>=20
> My problem is just that I know that the code generated is the same. What
> we're talking about is that should we let the preprocessor or compiler
> take care of this.
>=20
> My take is that using preprocessor is not wise - it's the last resort if
> there's no other proper way of doing things. Preprocessor requires all
> sorts of extra parenthesis to protect against its deficiencies, and it
> it merely a tool to do search-and-replace. Even multi-line needs special
> treatment.

Okay, so what you're saying here is that a huge number of people haven't
been wise in using the preprocessor for register definitions all these
years. That's a pretty bold statement. Now I obviously haven't looked at
every single line in the kernel, but I have never come across this usage
for static inline functions used for this. So, to be honest, I don't
think this is really up for discussion. Of course if you come up with an
example where this is done in a similar way I could be persuaded
otherwise.

> > What you need to consider as well is that many people that work with the
> > Linux kernel expect code to be in a certain style. Register accesses of
> > the form
> >=20
> >         writel(value, base + OFFSET);
> >=20
> > are very common and expected to look a certain way, so if you write code
> > that doesn't comply with these guidelines you make it extra hard for
> > people to read the code. And that'll cost extra time, which people don't
> > usually have in excess.
>=20
> But this has nothing to do with static inline vs. #define anymore, right?

Of course it has. With the way you've chosen to define registers the
code will look like this:

	writel(value, base + offset_r())

Maybe it's just me, but when I read code like that I need additional
time to parse it as opposed to the canonical form.

> > Maybe you can explain the usefulness of this some more. Why would it be
> > easier to look at them in sysfs than in debugfs? You could be providing
> > a simple list of syncpoints along with min/max, name, requested status,
> > etc. in debugfs and it should be as easy to parse for both humans and
> > machines as sysfs. I don't think IOCTLs would be any gain as they tend
> > to have higher ABI stability requirements than debugfs (which doesn't
> > have very strong requirements) or sysfs (which is often considered as a
> > public ABI as well and therefore needs to be stable).
>=20
> debugfs is just a debugging tool, and user space cannot rely on it. Only
> developers can rely on existence of debugfs, as they have the means to
> enable it.
>=20
> sysfs is a place for actual APIs as you mention, and user space can rely
> on them as proper APIs. That's what the values were exported for.

But I don't see how that's relevant here. Let me quote what you said
originally:

> This is actually the only interface to read the max value to user space,
> which can be useful for doing some comparisons that take wrapping into
> account. But we could just add IOCTLs and remove the sysfs entries.

To me that sounded like it was only used for debugging purposes. If you
actually need to access this from a userspace driver then, as opposed to
what I said earlier, this should be handled by some IOCTL.

Thierry

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuIy6AAoJEN0jrNd/PrOhg3AP/jyFO9s8DUWxsqpVnYpEpmBK
Ur80/6/Maf3/TC2FY0T9dbH5eIJOO5eaAbNRPb/jqe/rIDH3LQMYg6XeYZNZD2u/
0QFzUCvJ6Isz7bUZgIqUNjOP83iEUJwqIPURPDt2NG4Hzas1OUqjYo2rMDtUDuX3
GWWvG0zZY1BBUsoXcye0eBg3EiGyE2+6Gobojzqnar+5W7XnFNvfOEr06lbycGU1
0xvxPrEyaqAXRIdN4OEUXzTvzFTG/DihjkG3H/5CTheuHVZ6KnI3Qc1cyxqbLOh0
ryHOf78Zp2yvDgveON36NQ61QYRRZgzsjYOpg/pduM8YhTHmuF3rQMBPtN0ICoEs
I4ile8ipwRPEW2zJ6M7rKNzfitgis5M3Jd5ryEVIIlM8txxwE7TYpZiA1DQXgTmG
JkrjGG5K0mR9ALuOixk2bUWsGFpntSrUIfO0hONaKaddfoN0J7FRJO8jGLuD6Ueu
4yP60qm/+Mn5NtLGeeZalIzs5MlH10AwE+C9fEg8bMuYWGv1Ci27GZCDifrxZF+H
6khgseyW62p2Q0yJ/iZhDEKXgueg1xa4SmSlbKHGDGCl/KKd74WvFk+YN5irqe1a
qaX4hXL5TtzSxpgYjhu15jXNA+nHMv1DvQTOPzKYq3npBwSE1Lf+pke/i477xb10
jA0RxU6IdwbFVrkK5q5f
=Dm+v
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
