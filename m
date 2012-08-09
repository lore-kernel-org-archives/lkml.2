Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2HIH5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:57:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab2HIH5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:57:21 -0400
Date: Thu, 9 Aug 2012 09:57:16 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda - Defer probe when loading patch firmware
Message-ID: <20120809075716.GB24808@avionic-0098.mockup.avionic-design.de>
References: <1344494723-6827-1-git-send-email-thierry.reding@avionic-design.de>
 <s5hhascft86.wl%tiwai@suse.de>
 <20120809070813.GA6979@avionic-0098.mockup.avionic-design.de>
 <s5hd330frn1.wl%tiwai@suse.de>
 <20120809073642.GA24695@avionic-0098.mockup.avionic-design.de>
 <s5h7gt8fr47.wl%tiwai@suse.de>
 <s5h393wfqqm.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <s5h393wfqqm.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:YJblW8XlxK8y5xW8OIedQ9ojRJ72BIa3raMhZme5sd4
 ETd+NeSbWsDaZFLiuHjQbucs/GpGDySMMeSndDqjo2WuvEb3/e
 xhju15nQc9QnHtnC1WBFdVSnJlGwHIoonRHciin9gcOEFer3c5
 1TeY4aWJMaQh8JRE4gCiF3Uxbn9yc6oJSytqBhc3+V54tMU4j3
 m4BFN7IV6tKTonQz9Zt5fJ1yzV1aEmo6Ju1LxJ6Z+gzd2AlQLb
 2LVRDxg3g8MTJmyoxQXCi8cvUC8WONPrhfloM328Z0B4SxeQrz
 3/kQB5IJul5iUq5HYj9MxOrg1JrihiaoG4C+TfUkWT4a0iThD3
 sqN4ESBThseTVU3nezM9nMFv0fx4KCYP5A7RQBEw7EZnzrIyoQ
 PYNzLahsvRbv4wHTnXG/p9/2X8bzVCnYCAmWXrUNlhqXSHAqFs
 hzQvJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 09:50:57AM +0200, Takashi Iwai wrote:
> At Thu, 09 Aug 2012 09:42:48 +0200,
> Takashi Iwai wrote:
> >=20
> > At Thu, 9 Aug 2012 09:36:42 +0200,
> > Thierry Reding wrote:
> > >=20
> > > On Thu, Aug 09, 2012 at 09:31:30AM +0200, Takashi Iwai wrote:
> > > > At Thu, 9 Aug 2012 09:08:13 +0200,
> > > > Thierry Reding wrote:
> > > > >=20
> > > > > On Thu, Aug 09, 2012 at 08:57:13AM +0200, Takashi Iwai wrote:
> > > > > > At Thu,  9 Aug 2012 08:45:23 +0200,
> > > > > > Thierry Reding wrote:
> > > > > > >=20
> > > > > > > Recent changes to the firmware loading helpers cause drivers =
to stall
> > > > > > > when firmware is loaded during the module_init() call. The sn=
d-hda-intel
> > > > > > > module requests firmware if the patch=3D parameter is used to=
 load a patch
> > > > > > > file. This patch works around the problem by deferring the pr=
obe in such
> > > > > > > cases, which will cause the module to load successfully and t=
he driver
> > > > > > > binding to the device outside the module_init() call.
> > > > > >=20
> > > > > > Is the "recent" change meant 3.6 kernel, or in linux-next?
> > > > > >=20
> > > > > > In anyway, I don't understand why such a change was allowed.  M=
ost
> > > > > > drivers do call request_firmware() at the device probing time.
> > > > > > If this really has to be resolved in the driver side, it must b=
e a bug
> > > > > > in the firmware loader core code.
> > > > >=20
> > > > > A good explanation of the problem and subsequent discussion can b=
e found
> > > > > here:
> > > > >=20
> > > > > 	http://article.gmane.org/gmane.linux.drivers.video-input-infrast=
ructure/49975
> > > >=20
> > > > Yeah, but it doesn't justify this ugly module option.
> > > > It's a simple bug.  Papering over it with this option doesn't fix
> > > > anything.
> > >=20
> > > It's not an option, all it does is defer probing if and only if the
> > > patch parameter was specified to make sure the firmware load won't
> > > stall. I realize that this may not be an optimal solution, but at lea=
st
> > > it fixes the problem with no fallout.
> >=20
> > Ah sorry, I misread the patch.
> >=20
> > Then it shouldn't be checked at that point.  Since 3.5 kernel, the
> > probing code was already split for vga_switcheroo support.  The point
> > you added is the second stage.
>=20
> ... and the patch won't work properly if there are multiple HD-audio=20
> controllers.  Hmm.

Right... the deferred probe would mess up the matching done by the
static dev variable. So maybe a proper implementation that uses
asynchronous firmware loading is inevitable.

Thierry

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI21cAAoJEN0jrNd/PrOhAGYQAJIjDX5M4B/2cnixCCPv+tOi
UOf5KCQjRPoMS1fKZJzD8t7UVP+TidIPh66ElNgUu3tz9GksAPO3Pmsfsw9kbigc
eXugF3v1WGBUlQ1xRYYbPRoVIP5dd2/sCXQ31WdGy0XsKgemoh+Jzt0a1IJxnzkH
0K/mzgDon0dmILF0M6wZ1A2W3k7aB7PHZ25bOvcUJ4Hb4Hmt2Qkl4/Wflv/WgbUM
9+p24Jm1bU3U6nub0/EvCHqi7rUp+iTcBmzoNzDPQAgJAJ8XAth/d8tmX3UVz7eg
hYAfWA+zX7GIZ61E63rIy+7QWXj/NOeexPqVpGtEW3puUSLIKogtgOhqZ0SrQUEU
5YXqhuGaigNwYu6Im+0MigqazM9am5ZtF1Lgv0xADcWe9z7/UR8VE0vV5SpIlOBV
yeCDlOJifsexoDYo024wnYUi0DdRanTeAGz13SADkC686uz2dRj2CPObQTYrexxA
t4gdgd6eCvKW2ydZ0JxuPMzqlghjv5KqfmOpMeMLr69HH//WVCt4owE16xnh/YC+
QfB1aG4athb88LjKC4mcg9vZ5oZD2G+BOd7kdCKZuWYWoL0ixInWAhZi9QUGviI9
6H7+AM06Z3DCDD6mar7iaca4iJyQA475c9JHS7wZFS/ANCuSfj2oOX5DGnAaK/El
eebILoVGhiSrgFukuOnh
=SbLW
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
