Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab1IPVQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 17:16:14 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46608 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab1IPVQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 17:16:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: use a global counter for the global clock
In-Reply-To: Your message of "Fri, 16 Sep 2011 08:18:26 EDT."
             <1316175506.26295.36.camel@gandalf.stny.rr.com>
From: Valdis.Kletnieks@vt.edu
References: <1316163765.10174.8.camel@twins>
            <1316175506.26295.36.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316207693_55056P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Sep 2011 17:14:53 -0400
Message-ID: <66899.1316207693@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4E73BC4F.00CE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316207693_55056P
Content-Type: text/plain; charset=us-ascii

On Fri, 16 Sep 2011 08:18:26 EDT, Steven Rostedt said:

> +	return atomic64_add_return(1, &trace_counter);

Given that the usefulness of this is probably directly proportional to the
number of cores on the box, is this subject to cache line ping-ponging on
systems with many cores?

> When debugging tight race conditions, it can be helpful to have a
> synchronized tracing method. Although in most cases the global clock
> provides this functionality, if timings is not the issue, it is more
> comforting to know that the order of events really happened in a precise
> order.

One wonders if the overhead can end up being enough to change the
ordering, and possibly cause a heisenbug (most likely if the race condition
involves one CPU doing something we're tracing, and another CPU doing
something we are *not* tracing)...

If that's considered not an issue, feel free to stick this on it:
Reviewed-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>



--==_Exmh_1316207693_55056P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOc7xNcC3lWbTT17ARAg6UAJ9+wB4nwmM691iXvcPehfRoDw/4tQCdGWJb
yN2tdD5Y/mPuO8w/9vsqiNc=
=bxpH
-----END PGP SIGNATURE-----

--==_Exmh_1316207693_55056P--

