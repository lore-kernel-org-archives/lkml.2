Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1D1A0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 20:26:11 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43535 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1D1A0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 20:26:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Borislav Petkov <bp@alien8.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3.1] kbuild: implement several W= levels
In-Reply-To: Your message of "Wed, 27 Apr 2011 13:35:13 +0200."
             <20110427113513.GB18112@eferding.osrc.amd.com>
From: Valdis.Kletnieks@vt.edu
References: <20110422110947.GA20715@merkur.ravnborg.org> <1303494642-18594-1-git-send-email-bp@alien8.de> <20110427082555.GC5726@merkur.ravnborg.org>
            <20110427113513.GB18112@eferding.osrc.amd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1303950319_5598P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 27 Apr 2011 20:25:20 -0400
Message-ID: <11802.1303950320@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4DB8B3F4.001D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1303950319_5598P
Content-Type: text/plain; charset=us-ascii

On Wed, 27 Apr 2011 13:35:13 +0200, Borislav Petkov said:

> If we do this inclusive, then W=2 dumps the, let's call it, level 1
> _plus_ the new level 2 warnings, polluting the output with something
> I've already seen, but only partially. And then I start to think, did
> I see this one already, didn't I, which was it? By the time you enable
> W=3, the output becomes pretty useless. For example, W=3 generates 190+
> MB logfile here only with level 3 warnings. Now imagine all 3 levels
> combined.

If each level is averaging 10x the previous level, then all 3 levels will only be 11%
bigger, or 211MB.

You *really* want to get *all* the warnings - quite often, you'll be looking
at a set of 15 or 20 level-3 warnings.  And if you had the Level-2's in there as
well, you'd immediately realize that the single level-2 was the real root-cause
of all the cascating warnings.

Also, having it as a "volume control" means I don't have to go reading the
Makefile to figure out which number I need to specify for which message - I can
just say W=3 and *know* the flavor I want will be in there somewhere. Let's
face it, if there's over 10 or 15 warnings involved, grep or your editor's
"locate next" will do a better job of finding it than you ever can...


--==_Exmh_1303950319_5598P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNuLPvcC3lWbTT17ARAtXzAJ9XjQ/BmPeVMYk2Y9CDg4mvDVSVfACghzoC
iKAPd5eNOOzRAup+pTsdX/o=
=vHpr
-----END PGP SIGNATURE-----

--==_Exmh_1303950319_5598P--

