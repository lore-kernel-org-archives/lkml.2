Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2DQMwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 08:52:41 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54289 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2DQMwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 08:52:40 -0400
Message-ID: <4F8D678C.6050104@nasza-klasa.pl>
Date: Tue, 17 Apr 2012 14:52:28 +0200
From: =?UTF-8?B?TGVzxYJhdyBLb3BlxIc=?= <leslaw.kopec@nasza-klasa.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Aman Gupta <aman@tmm1.net>, linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>,
        Damien Wyart <damien.wyart@free.fr>, Kyle McMartin <kyle@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Doug Smythies <dsmythies@telus.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inconsistent load average on tickless kernels
References: <CAK=uwuy80LaNdQ4P49i+bGUXFvxf1zB=oKqNBTdAyvFc+mOTyw@mail.gmail.com>	 <4F465F6E.9070605@nasza-klasa.pl> <1330517195.11248.148.camel@twins>	 <1330532667.11248.153.camel@twins> <1330534998.11248.158.camel@twins>	 <4F551ABE.5080605@nasza-klasa.pl>	 <CAK=uwuxvzGwes4ffy9EXVReG95U3HQaKmPPKgFnHzo_MwaO_NA@mail.gmail.com>	 <1330989903.11248.261.camel@twins> <1330990360.11248.264.camel@twins> <1330990413.11248.265.camel@twins>
In-Reply-To: <1330990413.11248.265.camel@twins>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig40343A29FA9B69FFD175B25B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig40343A29FA9B69FFD175B25B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello!

I've finally finished testing patch c308b56b53. Apologies for the delay
in reporting back. This time I've compared kernels from 3.2 and 2.6.32
branches. Here's a snapshot of load 15 on different versions:

2.6.32.55-hz-0f004f5a69			12.78
2.6.32.55-no-hz-74f5187ac8		4.42
2.6.32.55-no-hz-0f004f5a69		0.49
2.6.32.55-no-hz-c308b56b53		4.37
3.2.12-hz				12.85
3.2.12-no-hz				0.65
3.2.12-no-hz-c308b56b53			7.25
3.2.12-no-hz-c308b56b53	nohz=3Doff	10.59

A whole day trend is available on a comparison chart [1].

Just to make things clear 2.6.32 kernels were patched as follows:
* 74f5187ac8 - just 74f5187ac8
* 0f004f5a69 - 74f5187ac8 + 0f004f5a69
* c308b56b53 - 74f5187ac8 + 0f004f5a69 + c308b56b53

For kernel 3.2.12 patch c308b56b53 seems almost perfect. For low CPU
utilization the load value is slightly lower for NO_HZ version than it
is for HZ one. However the difference is small and the overall trend
relates to CPU usage quite closely. This is definitely the best match so
far. Thanks!

Looking at results for 2.6.32.55 branch it seems that we're back at
74f5187ac8 patch - the values are almost the same. The difference
between NO_HZ and HZ versions is noticeable. At the risk of sounding
like an ungrateful bastard - will there be further attempts at fixing
this bug for 2.6.32 kernels?


[1] http://img535.imageshack.us/img535/2204/kernelload.png

--=20
Les=C5=82aw Kope=C4=87


--------------enig40343A29FA9B69FFD175B25B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+NZ40ACgkQNZJfI+JDs2JIMwCgm85X8vDmAjqB9Vu9CICDcOAD
TvMAnAhBIm/ZjYHpnidnMkBomHS5jOxf
=Nvds
-----END PGP SIGNATURE-----

--------------enig40343A29FA9B69FFD175B25B--
