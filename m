Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab1DIUMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 16:12:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47857 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab1DIUMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 16:12:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: linux-kernel@vger.kernel.org, lkml@osndok.com
Subject: Re: A long overdue fork-bomb defense ?
In-Reply-To: Your message of "Fri, 08 Apr 2011 15:47:13 CDT."
             <E6EFCBFA-65D9-49D4-B042-EA6773F4D209@osndok.com>
From: Valdis.Kletnieks@vt.edu
References: <67B98EE7-9CD6-44E9-9B6E-C1CDF3115737@osndok.com>
            <E6EFCBFA-65D9-49D4-B042-EA6773F4D209@osndok.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302379928_4802P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 09 Apr 2011 16:12:08 -0400
Message-ID: <106827.1302379928@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4DA0BD9B.0012,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302379928_4802P
Content-Type: text/plain; charset=us-ascii

On Fri, 08 Apr 2011 15:47:13 CDT, Robert Hailey said:

> 		log("fork_count generation");
> 		divide_all_process_fork_counts_by_two();

This will involve painful locking on large systems with lots of procs running.


> 		for ( p : process_table) {

Ditto.

>	if (fork_alert_level) {
>		if (fork_count >= fork_alert_level) {
>			signal(KILL, proc) && log('killed ...');
>			//don't: fork_alert_time=now();
>			return/dispatch?;
>		}
>		if (now()-fork_alert_time>10 seconds?) {
>			fork_alert_level=0; //Relax
>		}
>	}

A smart attacker can probably use this to  game the fork rate to fly just under
the wire, while still piling up lots of processes, *and* adding extra overhead
as it goes. If the rate limit is 5000 forks every 10 seconds, it can do 4500
every 10 seconds, and in a few minutes the poor scaling sections will eat your
system alive.

(And don't say "but it can be detected and stopped in those few minutes" -
because the *reality* in the security world is that people will say "We have
this great anti-forkbomb patch in the kernel, and don't need to check anymore".
Yes, they *will* do that.  Users that will blindly click on stuff because their AV
will stop anything bad are one of the banes of my existence. ;)


--==_Exmh_1302379928_4802P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNoL2YcC3lWbTT17ARAjsbAJ0TJegVu23ckJinqk3+sp+LrPzxCACfWLAv
Fop3aHGnKp847bab1kUFRzo=
=bT9U
-----END PGP SIGNATURE-----

--==_Exmh_1302379928_4802P--

