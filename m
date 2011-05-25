Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1EYUsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:48:37 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48384 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab1EYUsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:48:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Kasper Dupont <kasperd@nhnxn.25.may.2011.kasperd.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (Short?) merge window reminder
In-Reply-To: Your message of "Wed, 25 May 2011 14:26:18 +0200."
             <20110525122618.GA14303@colin.search.kasperd.net>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com> <20110523231721.GM10009@thunk.org> <4DDAEC68.30803@zytor.com> <BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com> <6043.1306285994@localhost>
            <20110525122618.GA14303@colin.search.kasperd.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306356508_2932P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 25 May 2011 16:48:29 -0400
Message-ID: <24360.1306356509@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4DDD6B1E.008C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306356508_2932P
Content-Type: text/plain; charset=us-ascii

On Wed, 25 May 2011 14:26:18 +0200, Kasper Dupont said:
> On 24/05/11 21.13, Valdis.Kletnieks@vt.edu wrote:
> > Well, if we're looking at ELF-sized ABI changes, how about 3.0 be the
> > release where we re-sync the syscall numbers on all the archs? ;)
>
> If you want to do that I think the best way to do it is to
> have both the old and the new numbers co-exist through the
> 3.x series and the old ones go away in 4.0.
>
> You'd first have to find the highest number currently
> assigned and then add a bit of safety margin to decide on
> a starting point for the new numbers.

Most archs are sitting around 300-340.  Alpha is the apparent
winner with 501.  So start at 512 which is a nice round number.

> Or was it all a joke, and you don't actually want that
> cleanup to happen because of too much breakage?

Well, with 2.0, we had some ABI cratering due to ELF.  I figured
*if* we're willing to do ABI cratering for a 3.0, cleaning up the
syscalls would be a nice drastic way to start. ;)

(Though to be honest, I think moving the a copy syscalls into one consistent
table starting at 512 or so for 3.0, and then nuking the low numbers for 4.0
would be better.  We would however have to take into account architectures
that have limited number of syscalls available - any archs unable to handle
syscall numbers up to 1024?)


--==_Exmh_1306356508_2932P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN3WsccC3lWbTT17ARAlEjAJwNRKL5BmEUcn9khC7iputwhtsg9QCgm3/T
3ObSPOm3Njl8V4PZ80r7eg4=
=QvZs
-----END PGP SIGNATURE-----

--==_Exmh_1306356508_2932P--

