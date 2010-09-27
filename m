Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab0I0Vwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:52:35 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43680 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0I0Vwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:52:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: =?utf-8?Q?Pawe=C5=82?= Sikora <pluto@agmk.net>,
        linux-kernel@vger.kernel.org
Subject: Re: git bisect selects commit outside initial bisect range?
In-Reply-To: Your message of "Mon, 27 Sep 2010 22:29:13 +0200."
             <m2fwwv7wx2.fsf@igel.home>
From: Valdis.Kletnieks@vt.edu
References: <201009272051.33882.pluto@agmk.net>
            <m2fwwv7wx2.fsf@igel.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1285624307_7757P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Sep 2010 17:51:47 -0400
Message-ID: <32106.1285624307@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A090209.4CA111F3.0158,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1285624307_7757P
Content-Type: text/plain; charset=us-ascii

On Mon, 27 Sep 2010 22:29:13 +0200, Andreas Schwab said:
> Paweł Sikora <pluto@agmk.net> writes:
> 
> > i've started git bisect between good-v2.6.34 and bad-v2.6.35-rc1
> > and after few steps git-bisect jumps to commit before v2.6.34.
> >
> > [~/src/linux/linux-2.6]$ make kernelrelease
> > 2.6.34-rc6-00551-g7a6cb0d
> >
> > is it normal that bisect selects next step outside initial range?
> 
> It's not outside the range:
> 
> $ git rev-list v2.6.34..v2.6.35-rc1 | grep ^7a6cb0d
> 7a6cb0d5497418599d2125b670926b75e673861c
> 
> 7a6cb0d is a commit in a branch reachable from v2.6.35-rc1 but not from
> v2.6.34.

I think he was confused because that commit is in an section of the tree
that was committed to a maintainer tree before 2.6.34 - so when he boots
the resulting kernel it says 2.6.33-rc3-mumble or similar.  I know it threw
me for a loop the first few times it happened.

Pawel: What's happened is you're looking at a commit that got into a maintainer
tree *before* 2.6.34 came out (so the top-level Makefile *at that time in that
tree* said 2.6.33-mumble or something), but the maintainer fed it into Linus's
tree in the merge window *after* 2.6.34 shipped.  Yes, it's bizarre, but that's
how git deals with it.  If you look at the graph produced by 'git bisect
visualize' it makes a bit more sense.


--==_Exmh_1285624307_7757P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMoRHzcC3lWbTT17ARAniOAKDaMU1ZLAjLfuRheopjF4p7YYjwqgCbBvfV
bQQ5iABIFmbyxtfCgOnfLTg=
=/Nia
-----END PGP SIGNATURE-----

--==_Exmh_1285624307_7757P--

