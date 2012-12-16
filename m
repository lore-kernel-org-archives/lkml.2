Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab2LPMQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 07:16:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57025 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2LPMQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 07:16:15 -0500
Date: Sun, 16 Dec 2012 13:16:03 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de>
References: <50BF345A.8050201@nvidia.com>
 <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de>
 <50C5CAB5.3040000@nvidia.com>
 <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de>
 <50C99677.6090306@nvidia.com>
 <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de>
 <50CA175F.60002@wwwdotorg.org>
 <50CAC2AC.1010704@nvidia.com>
 <50CB5205.1030303@wwwdotorg.org>
 <50CB850F.9090704@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <50CB850F.9090704@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Ik3pX0hecNzTkXH863bbYrrBtqHEl7ClLQzd/oyc0W3
 dN7EHu8lFGsi5aIsjZHGwlmD72PdDRc/QJeV+qiYRDwagZOs1z
 rbpuZjvwGGgNG7ah6Iu7u81Gk1CUEW0oNGyyyi8mXyCcQlL5F0
 pz+5SE48FHSYNUIkB2n5cD690uBPGYwmq8AOL7SwLj6GRoreup
 6ftn5g6KOVOkSb9gmDWdPjSdD4TMOkWib60ienLAPmJewoAEck
 UyLYGMiozlosWbTA7IKq8c7/GkyeO62FmwLDpIn4ZD9Ik2ZcVd
 mXUAlknyEPpZcyvd1BJWbp6W3T7zF6q/TWi8v5w+cyj3SOCb1U
 45w+Qz7HZfIvpAdjNsWM3vCb/SlnYlHyFKS92faiJvmA+VLLJg
 xKu0o16GJF6a6lRcLx+5x9Umq5VC4HuZvg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 14, 2012 at 09:59:11PM +0200, Terje Bergstr=C3=B6m wrote:
> On 14.12.2012 18:21, Stephen Warren wrote:
> > On 12/13/2012 11:09 PM, Terje Bergstr=C3=B6m wrote:
> >> They want to get the global data by getting drvdata of their parent.
> >=20
> > There's no reason that /has/ to be so; they can get any information from
> > wherever it is, rather than trying to require it to be somewhere it isn=
't.
>=20
> Exactly, this was also my solution.
>=20
> >> The dummy device is not their parent - host1x is. There's no
> >> connection between the dummy and the real client devices.
> >=20
> > It's quite possible for the client devices to ask their actual parent
> > (host1x) for the tegradrm struct device *, by calling a host1x API, and
> > have host1x implement that API by returning the dummy/virtual device
> > that it created. That should be just 1-2 lines of code to implement in
> > host1x, plus maybe a couple more to correctly return -EPROBE_DEFERRED
> > when appropriate.
>=20
> My solution was to just have one global, and an getter for the global.
> Instead of drvdata, the pointer is retrieved with the getter. No need
> for dummy device, or passing points between host1x and tegradrm.

Okay, so we're back on the topic of using globals. I need to assert
again that this is not an option. If we were to use globals, then we
could just as well leave out the dummy device and just do all of that in
the tegra-drm driver's initialization function.

The whole point of all this is to link the host1x and it's particular
tegra-drm instance. I will see if I can find the time to implement this
in the existing driver, so that the host1x code that you want to remove
registers the tegra-drm dummy device and the tegra-drm devices use the
accessors as discussed previously to access host1x and the dummy device.
Once that is implemented, removing the original host1x implementation
should be much easier since you will only have to keep the dummy device
instantiation along with the one or two accessor functions.

Thierry

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQzbuDAAoJEN0jrNd/PrOhKAEP/2BL5yE+k5akcV/F8ezfTJPK
7c06MaJMPsljqrYRdneieddpTNwEYP6eIUvJqr+0OEl6W7J3BUEAyy7V3cS8rnjs
5NY+Y5cCHI3GTjmIDCnc4A335FhWEAcyFg5CAuJPA6avptYbOXtPZWCRH4QG/+Q8
/jaXVYVk35fDkQY9SAANjz4PrF5JkIICCZYCgAnLaMuvpgJpDEJLJWY9bnCTJNnI
WKn08gnoRTE1YRt0/It9+G2SqzZwWXaojx5/0jfN4CGcN6VS1EkKkJAvi4m+iX4w
GyQcdn1FsIV/BDbKce/QJWElTpfYQAFvcPXHHcaHjGVLsl50zRusZ0203X16vFwj
NPdRqaBMbGcrCxxYg0oc+eKHm6LogXf7m9IXtGbWjVTSjbtlSdgsWykrZxD2N8kO
UyRPjuwDyX+wRnYy/9xdngXf3SJh1obnQsRznFH7XGKgCR7S2C1KvOIkNdk6sp5g
JaBJ4J89dRisqLb6TByU88OxWXqV4u2Q4B2UgSjQgSNszDjjAFcmIkoaXPHZiPsc
zPL5MF6CwIZwj6vJ7dw8ofGkLR7PHpgDraKY++bzIAP03TlKt0fJ+88zSRuLawRS
LUG0D4L2UaJ23RFEu2HNj8xqV32PJ/Ml2/LoOOGQ0H0WsJK9M9dj3aVTvT7Z4cnr
1dPZfR++hFyI/XAkgdoT
=Wk0e
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
