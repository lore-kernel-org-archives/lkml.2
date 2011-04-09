Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1DIWot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 18:44:49 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43952 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab1DIWor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 18:44:47 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Robert Hailey <lkml@osndok.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A long overdue fork-bomb defense ?
In-Reply-To: Your message of "Sat, 09 Apr 2011 17:25:48 CDT."
             <009EC62D-F6F7-48C4-9D03-9B1B8D6796ED@osndok.com>
From: Valdis.Kletnieks@vt.edu
References: <67B98EE7-9CD6-44E9-9B6E-C1CDF3115737@osndok.com> <E6EFCBFA-65D9-49D4-B042-EA6773F4D209@osndok.com> <106827.1302379928@localhost>
            <009EC62D-F6F7-48C4-9D03-9B1B8D6796ED@osndok.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302389083_4802P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 09 Apr 2011 18:44:43 -0400
Message-ID: <112094.1302389083@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4DA0E15E.0023,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302389083_4802P
Content-Type: text/plain; charset=us-ascii

On Sat, 09 Apr 2011 17:25:48 CDT, Robert Hailey said:

> Is there a better way to handle the integer overflows?

Oh, is that for overflow handling? My (admittedly quick) review
of the code made it look like it was an exponential-decay feature.

Might want to think about what situations will cause an integer overflow
here.  What has to happen before an overflow is a concern?

> >> 		for ( p : process_table) {
> >
> > Ditto.
>
> Thankfully, this logic would only be triggered when the process table
> is full. At that point I doubt anyone would miss the compute time of
> even the most painful lock :)

If you get to the point where it's full, you've already lost.

> Presuming for a moment that it works, I think the worst case is
> actually a single (perhaps compromised) process spawning child fork
> bombs. For that matter it could be a bash shell with the user setting
> them off. In that case it might *never* cause enough forking it to get
> itself automatically killed, but the system would still be [somewhat?]

bash$ :(){ :|:&};:

Try it and see. ;)

> responsive through the attack b/c it no longer denies a legitimate  
> fork, i.e. logging in & using a shell work, even while the process  
> table is *FULL* of active fork bombs.

I suspect recent patches that allow an entire process tree to be sent SIGSTOP
will be a more productive approach.

> Even if a fork bomb is downgraded from "fatal" to "makes things darn  
> slow", it's worth considering, no?

Depends why a fork bomb was allowed to be fatal in the first place...

--==_Exmh_1302389083_4802P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNoOFbcC3lWbTT17ARAl5vAKDNNJDoCZDr0825HSKhXRIQ9QIrEQCaAnJ/
giortYNab0DyGhj9OV47/N8=
=NQNd
-----END PGP SIGNATURE-----

--==_Exmh_1302389083_4802P--

