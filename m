Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1EEJba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:31:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33621 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1EEJb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:31:28 -0400
Date: Thu, 5 May 2011 11:31:23 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, john stultz <johnstul@us.ibm.com>
Subject: Re: [rtc-linux] Re: [PATCH 0/3] repair RTC subsys (for i.MX)
Message-ID: <20110505093123.GA2653@pengutronix.de>
References: <1304523088-17039-1-git-send-email-w.sang@pengutronix.de>
 <1304548259.2943.5.camel@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <1304548259.2943.5.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 04, 2011 at 03:30:59PM -0700, john stultz wrote:
> On Wed, 2011-05-04 at 17:31 +0200, Wolfram Sang wrote:
> > The recent updates to the RTC subsystem (removing UIE interrupts and use
> > alarms instead) introduced two problems for i.MX (and the subsys in
> > general, I'd think):
> >=20
> > a) because registering the rtc now calls get_alarm(), the requirement
> > has been added for a lot of drivers that drvdata is properly set up
> > _before_ registering. rtc-mxc did not do that (probably bad; but as said
> > like a lot of other rtc-drivers currently) and oopsed.
> >=20
> > b) the callbacks to the rtc-core for update_irqs have been removed, but
> > irq-handlers are still there, now being unused cruft. In case of
> > rtc-mxc, this is only one if-block, but for rtc-mc13xxx.c this is a
> > seperate handler.
> >=20
> > From a glimpse, most platform drivers seem to have at least one of these
> > problems now :( John, am I correct or am I missing something?
>=20
> I've tried to go through and clean up most of the b) issues, although
> some have apparently slipped by. Please let me know of any others you
> ran across.

I discovered it when working on the rtc-stmp3xxx driver. For this, I
will send a patch series in a few minutes, because there are more things
to be done there. Grepping for 'RTC_UF' should point to other areas of
interest.

> And indeed we've hit a few of issue a) already, so I should probably run
> through and do a full audit.

I hacked a q'n'd coccinelle-script pointing out potential candidates. It
found two more for which I will send patches, too. But I think a
seperate audit would be a good idea, just to be sure.

> Your patches look fine to me. Do you intend to push them or should I
> queue them up?

I'd say they should go via your tree.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAk3CbmsACgkQD27XaX1/VRsEtwCgr9OhyTPBByt2AbM7YYE8tIF4
7FsAl3fxN/Ydg6GPErq7zQRwvMX4cao=
=oYnH
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
