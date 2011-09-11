Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab1IKCGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 22:06:05 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45508 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758682Ab1IKCGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 22:06:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Sandy Harris <sandyinchina@gmail.com>
Cc: Steve Grubb <sgrubb@redhat.com>, Neil Horman <nhorman@redhat.com>,
        Tomas Mraz <tmraz@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
In-Reply-To: Your message of "Fri, 09 Sep 2011 10:21:13 +0800."
             <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <1315464117.11199.51.camel@vespa.frost.loc> <20110908125234.GD13657@hmsreliant.think-freely.org> <201109080911.12921.sgrubb@redhat.com>
            <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1315706745_28234P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 10 Sep 2011 22:05:46 -0400
Message-ID: <118704.1315706746@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4E6C1780.0002,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1315706745_28234P
Content-Type: text/plain; charset=us-ascii

On Fri, 09 Sep 2011 10:21:13 +0800, Sandy Harris said:
> Barring a complete failure of SHA-1, an enemy who wants to
> infer the state from outputs needs astronomically large amounts
> of both data and effort.

So let me get this straight - the movie-plot attack we're defending against is
somebody readin literally gigabytes to terabytes (though I suspect realistic
attacks will require peta/exabytes) of data from /dev/urandom, then performing
all the data reduction needed to infer the state of enough of the entropy pool
to infer all 160 bits of SHA-1 when only 80 bits are output...

*and* doing it all without taking *any* action that adds any entropy to the
pool, and *also* ensuring that no other programs add any entropy via their
actions before the reading and data reduction completes. (Hint - if the
attacker can do this, you're already pwned and have bigger problems)

/me thinks RedHat needs to start insisting on random drug testing for
their security experts at BSI.  EIther that, or force BSI to share the
really good stuff they've been smoking, or they need to learn how huge
a number 2^160 *really* is....


--==_Exmh_1315706745_28234P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFObBd5cC3lWbTT17ARAiJDAKCfrzp7udA1haRF+OhRfyrjwLPcFwCfaI7M
ObCuxyAWv2Ra4E0LvLriDTM=
=4CR4
-----END PGP SIGNATURE-----

--==_Exmh_1315706745_28234P--

