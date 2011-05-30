Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab1E3SoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:44:19 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57078 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1E3SoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:44:17 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "D. Jansen" <d.g.jansen@googlemail.com>
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
        Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: Your message of "Mon, 30 May 2011 20:28:24 +0200."
             <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard> <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com> <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu> <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com> <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com> <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com> <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com> <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com> <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm>
            <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306781002_2897P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 30 May 2011 14:43:22 -0400
Message-ID: <14586.1306781002@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DE3E54C.0099,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306781002_2897P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 30 May 2011 20:28:24 +0200, =22D. Jansen=22 said:

> I'm not really sure I why shouldn't have that choice as a user. Just
> because someone else could be running a mailserver on his system and
> configure it in a way that it doesn't behave as it should?

It cuts both ways.  If a piece of software really wants to be sure that t=
he
fsync() semantics it's expecting are actually adhered to and refuses to r=
un
otherwise, how does it tell that you're lying to it?

> The big problem is that so far only fsync existed and lots of software
> seemingly abuses it as an expensive write barrier. And it would really
> be lovely to have the choice to stop that on an opt-in basis in laptop
> mode.

It's not =22seemingly abuses it=22.  That's the existing userspace API fo=
r
inserting a barrier.  The problem is that as defined, it will wait for th=
e
writeback to actually finish - which is actually as good as you can get w=
ithout
getting into the async I/O support.  If there was a =22insert barrier and=
 return=22
API, how would it report back that the barrier had failed with EIO after =
it had
already returned to userspace?


--==_Exmh_1306781002_2897P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN4+VKcC3lWbTT17ARArJKAKCrsQ1jDb6VxyioLsP5tL3enKCQjwCgq54n
EjDcQXxdUh+9WtZgz44kqus=
=uSsg
-----END PGP SIGNATURE-----

--==_Exmh_1306781002_2897P--

