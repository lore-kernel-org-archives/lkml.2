Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868Ab0KOWmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:42:20 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:48292 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab0KOWmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:42:19 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
In-Reply-To: Your message of "Thu, 11 Nov 2010 08:26:40 MST."
             <1289489200.11397.21.camel@maggy.simson.net>
From: Valdis.Kletnieks@vt.edu
References: <1287479765.9920.9.camel@marge.simson.net> <1287487757.24189.40.camel@marge.simson.net> <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com> <1287511983.7417.45.camel@marge.simson.net> <1287514410.7368.10.camel@marge.simson.net> <20101020025652.GB26822@elte.hu> <1287648715.9021.20.camel@marge.simson.net> <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins> <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net> <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
            <1289489200.11397.21.camel@maggy.simson.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1289860866_8661P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Nov 2010 17:41:06 -0500
Message-ID: <30291.1289860866@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4CE1B703.00A7,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1289860866_8661P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Nov 2010 08:26:40 MST, Mike Galbraith said:

> Implementation: each task struct contains an inherited pointer to a ref=
counted
> autogroup struct containing a task group pointer, the default for all t=
asks
> pointing to the init_task_group.  When a task calls __proc_set_tty(), t=
he
> task's reference to the default group is dropped, a new task group is c=
reated,
> and the task is moved out of the old group and into the new.  Children =
thereafter
> inherit this task group, and increase it's refcount.  Calls to __tty_ha=
ngup()
> and proc_clear_tty() move the caller back to the init_task_group, and p=
ossibly
> destroy the task group.  On exit, reference to the current task group i=
s dropped,
> and the task group is potentially destroyed.  At runqueue selection tim=
e, iff
> a task has no cgroup assignment, it's current autogroup is used.

So the set of all tasks that never call proc_set_tty() ends up in the sam=
e one
big default group, correct?  Do we have any provisions for making sure th=
at if
a user has 8 or 10 windows open doing heavy work, the default group (with=
 a lot
of important daemons/etc in it) doesn't get starved with only a 1/10th sh=
are of
the CPU? Or am I missing something here?

> +extern void sched_autogroup_detatch(struct task_struct *p);

sched_autogroup_detach() instead?

--==_Exmh_1289860866_8661P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM4bcCcC3lWbTT17ARAvfsAJwLiFNzZhNd1OYag4pzmgAbI5ybMQCeJhiA
pdVpstuCDRoZMFfGY9GuhNc=
=FNG1
-----END PGP SIGNATURE-----

--==_Exmh_1289860866_8661P--

