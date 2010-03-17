Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab0CQDHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:07:23 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40260 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab0CQDHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:07:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Weird wireless/wpa_supplicant screw-up.
In-Reply-To: Your message of "Fri, 12 Mar 2010 19:09:09 PST."
             <1268449749.4880.2.camel@jlt3.sipsolutions.net>
From: Valdis.Kletnieks@vt.edu
References: <7197.1268086939@localhost> <1268392481.4828.7.camel@jlt3.sipsolutions.net> <5220.1268430568@localhost>
            <1268449749.4880.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268795213_4069P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Mar 2010 23:06:53 -0400
Message-ID: <12262.1268795213@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4BA0474E.017B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1268795213_4069P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Mar 2010 19:09:09 PST, Johannes Berg said:
> No ... look at _all_ that it produces.
> 
> [   98.592575] In giwencode idx=0 keys=ffff88001b304000 cipher=0
> [   98.592580] And we're going home...
> *****
> [   98.592633] In giwencode idx=1 keys=ffff88001b304000 cipher=fac04
> *****
> [   98.592749] In giwencode idx=2 keys=ffff88001b304000 cipher=0
> [   98.592751] And we're going home...
> [   98.592803] In giwencode idx=3 keys=ffff88001b304000 cipher=0
> [   98.592805] And we're going home...
> [   98.592856] In giwencode idx=0 keys=ffff88001b304000 cipher=0
> [   98.592859] And we're going home...
> 
> See? It reports one key which is the RX-only group key which is
> absolutely correct.

It matches what 'iwlist keys' reports, but I remain unconvinced of
its "correctness".  If a TX key has been set anyplace, what allows me
to verify that it was in fact set?

> > So the root cause has something to do with params[idx].cipher being unset.
> 
> Not at all.

I was referring to the root cause of why 'iwlist keys' wasn't reporting
anything for the other 3 key slots.

> GIWENCODE is 100% unsuitable for WPA. Just forget about "iwlist key".

Feel free to point me at the officially approved substitute.

> And then we'd like to know what the actual problem is.

The problem is that I do 'iwconfig', and I see:

Encryption key:off

And if I do 'iwlist keys', I don't see a TX key listed, which certainly gives
the at least the impression that we're not encrypting outbound traffic.  If I'm
not supposed to trust 'iwconfig' or 'iwlist key' to tell me whether WPA2
traffic is in fact encrypted or not, what *am* I supposed to use instead?

There's two possibilities:

1) iwconfig and iwlist keys are correctly reporting I don't have a TX key
set - which means wpa_supplicant and/or the kernel is failing to get the
key set, which is a problem.

2) iwconfig and iwlist are lying through their teeth, and reporting there
isn't any key set when in fact there is.  This is still a problem because it
implies to users their traffic isn't secured.

I'll point out that until fairly recently 'iwconfig' *did* report a key for
WPA2, so this looks like a regression on somebody's part.


--==_Exmh_1268795213_4069P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLoEdNcC3lWbTT17ARAgE3AKDxlTrvsTPkYR/tsy9JLX8ehBPA3ACfU0aG
i18TPXQEXyrzWhUEKdJR6DI=
=rZEE
-----END PGP SIGNATURE-----

--==_Exmh_1268795213_4069P--

