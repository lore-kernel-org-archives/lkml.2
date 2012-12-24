Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2LXQSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:18:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43781 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab2LXQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:18:30 -0500
Date: Mon, 24 Dec 2012 16:18:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-input@vger.kernel.org
Subject: Re: [PATCH 17/25] wm97xx: don't use [delayed_]work_pending()
Message-ID: <20121224161827.GR30837@opensource.wolfsonmicro.com>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-18-git-send-email-tj@kernel.org>
 <20121223095450.GA17407@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uw+RRa3pmtkgiNaD"
Content-Disposition: inline
In-Reply-To: <20121223095450.GA17407@core.coreip.homeip.net>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Uw+RRa3pmtkgiNaD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 23, 2012 at 01:54:50AM -0800, Dmitry Torokhov wrote:

> This is not 100% equivalent transformation as now we schedule first and
> disable IRQ later... Anyway, I think the driver shoudl be converted to
> threaded IRQ instead. Mark, does the patch below make any sense to you?

I'm a bit nervous about the fact that currently both the pen down IRQ
and the coordinate read are pushed through a single workqueue so are
serialised but after your patch they'll be split into the IRQ thread and
the workqueue.  It *should* be fine but I'd have to sit there and study
it to convince myself that it's safe.

--Uw+RRa3pmtkgiNaD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ2IBFAAoJELSic+t+oim9mGYP/3C4VuumUxsIPl+RptwTmy4O
8JNW2IYdnTmsP8FbNGrXH/sAqERbOzTt9gfJuRAz1jhUT02p6+IX4naDcSxSMN68
4Uxt3ZgFUCRu6J13wV+Wkd6d1714UyzrK8eE+RQG8N5Xyx4I1N5DsT9kPmmzsFUB
TxCWkK5J7iwPHamgYL34j2AbvKe4kyCeHckxMVEt6pGlDqcm4o6JF+/HL6pLHtkS
Ez+M0m1/waw/tGASZJgCJ4mANkAja/kT1EPiXmzBD4rrVyej1N9JVoU6GcO2LzT6
GUrdqw9MQ6J634A+fMkSNfcwy7if4KLJb4kOWTTXiRYaXEISgT83NIdKV30dJdTz
wzfaGCGVYzXZXvo4jQjUhGAXiP9Kaf8PftmSlH2ebNpK1g0fCbs78Py9bb+MYHdK
6eBTwydWgD2LwnKGrNwYAIPPjd/+PRDr8rIEHFuME2g6Q/IyAgWkk171CvTvRaZv
CvnVTOXfa0AOWc96jKVGlBNCVFOJW1zKnTxF3p63LwtAPyxvGdcxH3Eig3G7qTRr
hK3Qs8ZPdl/LRc12Pj1ZQ84ibbxF+mGzsyjJK63nh2ryGMSB54j71rsRBBr1IpiL
TEgi1xdpcWAeLu7Sl1M+kXQCd+mopjq1tkvhcc+KXM41+alIPDrYRZjHExGVYgV/
nvDIPFAUwFwBJAeIvgoo
=a4ol
-----END PGP SIGNATURE-----

--Uw+RRa3pmtkgiNaD--
