Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab2LCVDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:03:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2LCVDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 16:03:40 -0500
Date: Mon, 3 Dec 2012 22:03:29 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
Message-ID: <20121203210328.GA20884@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
 <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
 <50B73710.2040102@nvidia.com>
 <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
 <50B874C7.5030208@nvidia.com>
 <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de>
 <50BCFB7E.4020007@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <50BCFB7E.4020007@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:kyBjwC+6T2pksr5CujHK2txpIzu+9HN4esqytMOqJ9s
 ckj6rn8sf77UeVKEqxn7noWxrYJXuLiMmwEvcwvahYudcCh30L
 v5lTmYJK6C2yF4AFnzbApmzcUAc8M11aSQ/As9rtRDASdnGSMS
 xBcyPDwQOeF8U96X/nCyaeMjeeH39C5rwLjRSDj26zixrhD/YL
 4/M4i3/Nmlw1AMAJO8O6BYWeMq66LfIeJjgNuqum0ysPifqLDN
 QXC98DKLU5FDBZ6yvr98S4E58112pheq27p7FPh3bQlZbhpgJQ
 uPvvPJv76/8tUa0ap2N5oRA6rl2JXOyD1IJVaM/II78XcU6b9F
 DYF5L4NG0DtYesUx9ReOj28jfNx2nPbrKRkB9SOvVmIG9d2okO
 RJ/VkhCNPffvZa+3mU9Lf58dapgKeeM7BtU9lES/ZdsYj4EMfW
 HRFVT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 03, 2012 at 12:20:30PM -0700, Stephen Warren wrote:
> On 11/30/2012 03:38 AM, Thierry Reding wrote:
> > On Fri, Nov 30, 2012 at 10:56:39AM +0200, Terje Bergstr=C3=B6m wrote:
> >> On 29.11.2012 13:47, Thierry Reding wrote:
> >>> On Thu, Nov 29, 2012 at 12:21:04PM +0200, Terje Bergstr=C3=B6m
> >>> wrote:
> >>>> Tegra20 and Tegra30 are compatible, but future chips are not.
> >>>> I was hoping we would be ready in upstream kernel for future
> >>>> chips.
> >>>=20
> >>> I think we should ignore that problem for now. Generally
> >>> planning for any possible combination of incompatibilities
> >>> leads to overgeneralized designs that require precisely these
> >>> kinds of indirections.
> >>>=20
> >>> Once some documentation for Tegra 40 materializes we can start
> >>> thinking about how to encapsulate the incompatible code.
> >>=20
> >> I think here our perspectives differ a lot. That is natural
> >> considering the company I work for and company you work for, so
> >> let's try to sync the perspective.
> >>=20
> >> In my reality, whatever is in market is old news and I barely
> >> work on them anymore. Upstreaming activity is the exception. 90%
> >> of my time is spent dealing with future chips which I know cannot
> >> be handled without this split to logical and physical driver
> >> parts.
> >>=20
> >> For you, Tegra2 and Tegra3 are the reality.
> >=20
> > To be fair, Tegra2 and Tegra3 are the reality for *everyone*
> > *outside* NVIDIA.
> >=20
> > It's great that you spend most of your time working with future
> > chips, but unless you submit the code for inclusion or review
> > nobody upstream needs to be concerned about the implications. Most
> > people don't have time to waste so we naturally try to keep the
> > maintenance burden to a minimum.
> >=20
> > The above implies that when you submit code it shouldn't contain
> > pieces that prepare for possible future extensions which may or may
> > not be submitted (the exception being if such changes are part of a
> > series where subsequent patches actually use them). The outcome is
> > that the amount of cruft in the mainline kernel is kept to a
> > minimum. And that's a very good thing.
>=20
> I think there's room for letting Terje's complete knowledge of future
> chips guide the design of the current code that's sent upstream.
> Certainly we shouldn't add a ton of unnecessary abstraction layers
> right now that aren't needed for Tegra20/30, but if there's some
> decision that doesn't affect the bloat, opaqueness, ... of the current
> code but one choice is better for future development without serious
> negatives for the current code, it's pretty reasonable to make that
> decision rather than the other.

The original point was that the current design stashes every function of
host1x into an ops structure and you have to go through those ops to get
at the functionality. I can understand the need to add an ops structure
to cope with incompatibilities between versions, but as you say there
should to be a reason for them being introduced. If such reasons exists,
then I think they at least warrant a comment somewhere.

Furthermore this is usually best handled by wrapping the ops accesses in
a public API, so that the ops structure can be hidden within the driver.
For example, submitting a job to a channel should have a public API such
as:

	int host1x_channel_submit(struct host1x_channel *channel,
				  struct host1x_job *job)
	{
		...
	}

An initial implementation would just add the code into this function. If
it turns out some future version requires special incantations to submit
a job, only then should we introduce an ops structure, with only the one
function:

	struct host1x_channel_ops {
		int (*submit)(struct host1x_channel *channel,
			      struct host1x_job *job);
	};

But since only the public API above has been used, access to the special
implementation can be hidden from the user. So the public function could
be modified in this way:

	int host1x_channel_submit(struct hostx1_channel *channel,
				  struct host1x_job *job)
	{
		if (channel->ops && channel->ops->submit)
			return channel->ops->submit(channel, job);

		...
	}

And then you have two choices: either you keep the code for previous
generations after the if block or you provide a separate ops structure
for older generations as well and handle them via the same code path.

One other thing that such a design can help with is refactoring common
code or parameterizing code. Maybe newer generations are not compatible
but can easily be made to work with existing code by introducing a
variable such as register stride or something.

What's really difficult to follow is if an ops structure is accessed via
some global macro. It also breaks encapsulation because you have a
global ops structure. That may even work fine for now, but it will break
once you have more than a single host1x in a system. I know this will
never happen, but all of a sudden it happens anyway and the code breaks.
Doing this right isn't very hard and it will lead to a better design and
is less likely to break at some point.

Thierry

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQvROgAAoJEN0jrNd/PrOhKGQQAJdr9SXX0eMGb1zpAKJbbeTg
A4KgIRBHEwLX5cNPsA1CrXm0o53UDrkiSrcusj+G1Yib8kKlwCDGU6gkzx9NGpxf
uIugVvO9Fjb5WjtvZ+k66nBOVZsxs7AHzT17omh6ODpxAtkr7ysbltDtFTUeuUPd
gyl2tsZXBorj7eWbanuZD8SJ6WjjJWB4hiK/qiT0X0LPUZiQQiHZ2jpOAjf26uD1
nTPBfEBNIC9c/3Vn2MTHWr6ZlmL30ynLwJIrRNxebmjcWdn4jcfkhX4wdwj2OMIb
qVKKidkDdq0EfgsVTY9SRGiB7qAvGL1Lo3x5k4d0vQVqbHlsMXVNjcp/StrryEKG
NAJGa+8scDkLuX+DoGoWLp0aYngZRp3dAKDrN6XLZWLnNT4y6NXbgIqMe4w72Xjm
F9GLJnlKPWsU2EjHVQl6Qcr9zGxmOQMFFlV5/QhV941dKb+VRyVE50yyrgXQYauL
j3+ofZRfKfbhpkzkINxnDhPaG2Rq33F2Cu0X0k33W9YtvPrFn3QGHz7HTnqQeGkk
POfk9Qf2Zw4BBcJDoP77ML50ty2rDLk192MuL5wZ5ogKJDV/eE+MtAk+XCwifULR
RJoUXi/edSP1oHeAsMPUutyT0KeStM3kIgVkjrc3nUyi0ZtidwKz+2bv/+9t336Y
uTDGFIL25CBV+zr66X2I
=q8Ew
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
