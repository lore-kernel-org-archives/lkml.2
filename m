Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2KMHwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:52:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58479 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab2KMHwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:52:53 -0500
Date: Tue, 13 Nov 2012 08:52:47 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Zhang <markz@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
Message-ID: <20121113075247.GB8409@avionic-0098.mockup.avionic-design.de>
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
 <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de>
 <50A1FA7C.4010507@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <50A1FA7C.4010507@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:W+Y+5/O6s5itkezMDFjJiSjR3rVVXXKPhDmH6g8W1/P
 5SQItNFxG2CT3FYDxW9k8bXXHuMgd3nLDPW08iOkchpVwxSwLy
 1wj3+HtzNzXxf513GXlLG70SyvqYc9W6p2/8VkANraeemlng7k
 DESP85Lx9ovjzYIDGMlqTZKHfjmlcr6oHdjzuKgK6Cs9nxZycp
 4sPK25OguL7O/qRoJe2qmwmWns3QGmD7pP/HMW4ZsZ8F6/evDj
 vM2TfDqgGQKA+0xU2jeKXpE7DQZc1WfzCvMANDzglp4XgXom8N
 PQiDE+SrRLYIjnqOp11vs0Ca213ncp1/qfc+0uZxijUoEJ4h3q
 ox8l+6yKTFezJAiv9VqXYnxEBiS6U+xx0sz1E1vTkR6RabCGv+
 5aix3Cx7NV/Yql4cncPRamUXBFlLHdMrO/8Aveah5iJcOGcM25
 IY/Ov
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2012 at 03:45:00PM +0800, Mark Zhang wrote:
> On 11/09/2012 09:20 PM, Thierry Reding wrote:
> > @@ -116,6 +122,9 @@ static __initdata struct tegra_clk_init_table tegra=
_dt_clk_init_table[] =3D {
> >         { "sbc2",       "pll_p",        100000000,      false },
> >         { "sbc3",       "pll_p",        100000000,      false },
> >         { "sbc4",       "pll_p",        100000000,      false },
> > +       { "host1x",     "pll_c",        144000000,      false },
> > +       { "disp1",      "pll_p",        600000000,      false },
> > +       { "disp2",      "pll_p",        600000000,      false },
>=20
> I think here the parent of disp2 should be "pll_d_out0", not "pll_p".
> Right now pll_p has not a proper clock setting to make 148.5MHz 1080p
> HDMI happy. In addition, you add the 297MHz in pll_d frequency table
> next and I think this is for disp2 has a proper clock rate to support HDM=
I.
[...]
> > @@ -1051,6 +1053,9 @@ static struct clk_duplicate tegra_clk_duplicates[=
] =3D {
> >         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.1", "fast-clk"),
> >         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.2", "fast-clk"),
> >         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.3", "fast-clk"),
> > +       CLK_DUPLICATE("pll_p", "tegra-dc.0", "parent"),
> > +       CLK_DUPLICATE("pll_p", "tegra-dc.1", "parent"),
> > +       CLK_DUPLICATE("pll_d_out0", "tegra-hdmi", "parent"),
> >  };
>=20
> The same with my above comments, the tegra-dc.1's parent should be
> pll_d_out0.

The way this works is that for HDMI it is required that the DC and HDMI
blocks have the same parent. So what really happens is that once you
setup one of the DCs to work with HDMI, its clock will automatically be
reparented to the HDMI parent clock, which in this case is "pll_d_out0".

Thierry

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQofxPAAoJEN0jrNd/PrOhDZUP/RE8Ruq8JfStjv+20FKyaJKu
lPZ1BZINCA/VVsCcdgcpRBAAiPVs8uuwhWmh39baZsFacP+gMDaVUHq7uUkACE2H
dqzPQBgcANkww5skQSfA2bY5NGR+GBaNFKNq2OLFsL2o+M4qBaLINihQxd2/IUTa
WyBJliiQVMUuQQlvWTOGZm98EKGj6MrXZGLqwyi1ucmvpuAMxEnoXX2xKbJSfe9i
d4kv/vl/mmzGhji/wY6BAGQMbfAGbk3VRRRR9eZR3z8K8BjAhAqW/R0nzpz2xHwe
tFAoptOs+Cd93VbyxuYU7z/X4M8tTp/J0HzAng6zs/hLJEWHzo2leubGvEzzcUAp
VNc5jbXFjbBrYS/NFMovDEAF2Uk8VB1YVX3dY9BOMfcI7BNEfancjvBydjVGs3ev
CGP/p9lTeKSQk53QlbeLuXhVIc4tNpUjpFHBjGt6vIzRScu3X8CHsAGwtQGAxLIU
/kwSwonEVr7dSLlyXlsFCqAsZV9OjCDW76Aj/xzPOfBqfnW+eGs9u7m9QGOJgmr0
Dw6rPWgH69iEE26fg9Ua2CWGdNqvUzTPvQ4sCQqfeUpieIdtmgj0Fs0OaCLRlrxu
I6KKF7AhUsD54WBOxDZGYkG0SGRO6FtNroSsDPME6r7bhPgZ8lEH5Kc0bm044kZJ
hfnzIIZ+/WbJMuYXEXBk
=Kd/y
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
