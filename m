Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab0D0VuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 17:50:15 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40156 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab0D0VuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 17:50:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Psychovisually-optimized HZ setting (2.6.33.3)
In-Reply-To: Your message of "Tue, 27 Apr 2010 21:03:11 +0200."
             <op.vbt4jlyn6426ze@millennium.getinternet.no>
From: Valdis.Kletnieks@vt.edu
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <4BC588CF.5010507@redhat.com> <1902445479.2078.458.camel@ymzhang.sh.intel.com> <4BC6C8CD.1020801@redhat.com> <1902473858.2078.481.camel@ymzhang.sh.intel.com>
            <op.vbt4jlyn6426ze@millennium.getinternet.no>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272405003_4032P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Apr 2010 17:50:03 -0400
Message-ID: <29999.1272405003@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4BD75C0E.002A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272405003_4032P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Apr 2010 21:03:11 +0200, Uwaysi Bin Kareem said:

> http://www.paradoxuncreated.com/articles/Millennium/Millennium.html

> +	config HZ_3956
> +		bool "3956 HZ"
> +	help
> +	 3956 Hz is nearly the highest timer interrupt rate supported in the kernel.
> +	 Graphics workstations, and OpenGL applications may benefit from this,
> +	 since it gives the lowest framerate-jitter. The exact value 3956 is
> +	 psychovisually-optimized, meaning that it aims for a level of jitter,

Even after reading your link, it's unclear why 3956 and not 4000. All your link
said was "A granularity below 0.5 milliseconds, seems to suit the human
senses." - anything over 2000 meets that requirement.  Also, if your screen
refresh is sitting at 72hz or a bit under 14ms per refresh, any jitter under
that won't really matter much - it doesn't matter if your next frame is
ready 5ms early or 5.5ms early, you *still* have to wait for the next vertical
blanking interval or suffer tearing.

There's also the case of programs where HZ=300 would *make* the time budget,
but the added 3,356 timer interrupts and associated overhead would cause a
missed screen refresh.

I think you need more technical justification of why 3956 is better than 1000.

--==_Exmh_1272405003_4032P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL11wLcC3lWbTT17ARAvMgAJ0ah240ABdHNHKQWCnb5OcuvUbifgCgjNx7
Kc9UfdccQNtI+tGF/iTQp5c=
=IPvH
-----END PGP SIGNATURE-----

--==_Exmh_1272405003_4032P--

