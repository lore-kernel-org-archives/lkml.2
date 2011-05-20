Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab1ETP2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:28:47 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:60576 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab1ETP2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:28:46 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: d.g.jansen@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tytso@mit.edu
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: Your message of "Thu, 19 May 2011 15:34:46 +0200."
             <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1305905293_2669P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 20 May 2011 11:28:13 -0400
Message-ID: <9534.1305905293@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4DD6888E.009A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1305905293_2669P
Content-Type: text/plain; charset=us-ascii

On Thu, 19 May 2011 15:34:46 +0200, Dennis Jansen said:

> Testing:
> I've been using this workaround on my netbook for over six months now.
> It works as expected for me with all software in a Ubuntu 9.10
> environment and saves me at least 0.5 Watt or roughly 10 % battery
> time - without destroying my hard disk. I have seen no negative side
> effects.
> 
> What I didn't test:
> I didn't test this on different platforms and environments. But as
> it's generic code I expect no different behavior. I didn't benchmark
> how this might affect performance due to the additional if() check for
> every fsync call. But as the fsync is rather expensive and not used
> *that* much, I think it should have not noticeable impact.

How much destructive testing did you do?  In the 6 months, how many times did
the system crash (or had the battery pulled out, or whatever) while large
amounts of data were still pending after apps thought they were fsync'ed? How
much crash testing was done against apps that use fsync for ordering or
correctness reasons?

> In short: That it makes laptop_mode work as advertised IHO is no valid
> point against this solution. And if, we could consider a sending a
> printk the first time an fsync is skipped.

That would be the same printk that the user never actually *sees* because your
patch suppressed syslogd's fsync to guarantee it made it to disk, so it was
lost when the system crashed soon thereafter, along with the user's work? ;)



--==_Exmh_1305905293_2669P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN1oiNcC3lWbTT17ARAgm4AKCQRATeS6Ziz/jCKzCfiRpVTQ1oxACg1X1c
LrU/oHb+Ckb2PJfF4B5yuqk=
=R0PL
-----END PGP SIGNATURE-----

--==_Exmh_1305905293_2669P--

