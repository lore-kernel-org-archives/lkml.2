Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab1EXCAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 22:00:38 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35059 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab1EXCAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 22:00:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Ingo Molnar <mingo@elte.hu>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
In-Reply-To: Your message of "Mon, 23 May 2011 12:49:02 +0200."
             <20110523104902.GB24674@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <1305292059.1949.0.camel@dan> <1305293345.1949.22.camel@dan> <20110516153527.GC21107@elte.hu> <1305852966.3005.19.camel@dan> <20110520120750.GJ14745@elte.hu> <1305896093.3005.24.camel@dan> <20110520131108.GA17699@elte.hu> <1306089922.1806.27.camel@dan> <BANLkTik1SK_kWVvGsKk0SqdByQ5-0b5nFg@mail.gmail.com> <1306110336.25049.7.camel@dan>
            <20110523104902.GB24674@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306202368_3286P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 23 May 2011 21:59:28 -0400
Message-ID: <6733.1306202368@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DDB1106.00BE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306202368_3286P
Content-Type: text/plain; charset=us-ascii

On Mon, 23 May 2011 12:49:02 +0200, Ingo Molnar said:
> Well, since entropy does not get reduced on addition of independent variables 
> the right sequence is (pseudocode):
>
> 	rnd  = entropy_cycles();
> 	rnd += entropy_rdrand();
> 	rnd += entropy_RTC();
> 	rnd += entropy_system();

I'm having trouble convincing myself that RTC and cycles are truly independent
variables.... ;)

Consider the case of a fixed-frequency CPU - if you know the time since boot,
and the current RTC, and the current cycle count, you can work backwards to
find the RTC and cycle count at boot.  I'm not sure that a variable clockspeed
helps all that much - an attacker can perhaps find a way to force the highest/
lowest CPU speed - or the system may even helpfully do it for the attacker -
I've seen plenty of misconfigured laptops that force lowest supported CPU
clockspeed on battery rather than race-to-idle.

Having said that, the 13 bootup rdtsc values you list *seem* to have on the
order of 24-28 bits of entropy, and only the lowest-order bit seems to be
non-random (the low-order byte of the 13 values are 28, b6, 44, 54, dc, 78, 2c,
38, 02, 58, 76, 16, and be).  So rdtsc appears to be good enough for what we
want here...


--==_Exmh_1306202368_3286P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN2xEAcC3lWbTT17ARAgbhAKD1OLPE/qz+JNrvSxjNBkD+dBvMfwCfWIXp
7WGxfd+22fnkL0pA8t6TdfM=
=wZ/G
-----END PGP SIGNATURE-----

--==_Exmh_1306202368_3286P--

