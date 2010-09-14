Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0INIKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 04:10:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34090 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab0INIKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 04:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=SpD+kOCsVXlARxBz2DwHjz4usI7OzYyFT1/YE97QA9XQxxsDthfLWcxZtO6qmscaR9
         knFCHTiXtqcdhYKjbWMYm/WcHzOhk6a+NPZs1k4ChFsgnNbL804yO/u9BzoZqlzP2gK9
         oWlUR0LwurEp80iF7KPB18L+nV+Juh/VrbvcM=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Subject: Re: Interrupt latency on some 945GM platforms
Date: Tue, 14 Sep 2010 11:09:36 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.35-gentoo-r5-anarsoul; KDE/4.5.1; i686; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <201009132336.17310.anarsoul@gmail.com> <201009140104.03135.anarsoul@gmail.com> <AANLkTi=UCvj9prjv9WzurUg8Gb4i3LZxVJeNwvLtYieN@mail.gmail.com>
In-Reply-To: <AANLkTi=UCvj9prjv9WzurUg8Gb4i3LZxVJeNwvLtYieN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart18620413.uCaTN5nVUu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009141109.41596.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart18620413.uCaTN5nVUu
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
14 of September 2010 03:55:32 =D0=B0=D0=B2=D1=82=D0=BE=D1=80 Venkatesh Pall=
ipadi=20
=D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:

> Whats the clockevent in this case ("Tick Device" section of
> /proc/timer_list). clocksource=3D option only changes the clocksource used
> to maintain
> timeofday. But, timer interrupt (clockevent) source will not change.
> Wondering how just the clocksource change is making the diff here..
>=20
> Also, if clocksource tsc has a higher rating than HPET. The reason
> HPET is getting used as clocksource in the first place seems to be due
> to TSC is not a dependable clocksource on this platform (may be it
> stops in C3). So, I am not sure forcing it to tsc will be a good
> thing. May be clocksource=3Dacpi_pm is a better thing to try.
>=20
> Thanks,
> Venki

I investigated it a bit and found out that single nohz=3Doff option helps. =
Just=20
changing clocksource doesn't help, but it works smoothly with any clocksour=
ce=20
with nohz=3Doff. So, it seems that something wrong with intel driver while=
=20
system is in tickless mode.=20

Regards
Vasily

--nextPart18620413.uCaTN5nVUu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkyPLcUACgkQRM6pQpltKE7B1gCfTr8l8V7ZHlxVy/yvVeIbq4Rw
0ZcAoLn83BiqtHbUBQy5hkRpr1ZfGedh
=0Rlc
-----END PGP SIGNATURE-----

--nextPart18620413.uCaTN5nVUu--
