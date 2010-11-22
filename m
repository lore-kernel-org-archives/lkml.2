Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab0KVSMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:12:50 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:42135 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab0KVSMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:12:49 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: holzheu@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Oleg Nesterov <oleg@redhat.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/4] taskstats: Improve cumulative time accounting
In-Reply-To: Your message of "Mon, 22 Nov 2010 13:47:55 +0100."
             <1290430075.5655.3.camel@holzheu-laptop>
From: Valdis.Kletnieks@vt.edu
References: <20101119201108.269346583@linux.vnet.ibm.com> <1290197955.2109.1617.camel@laptop> <1290423780.1974.1.camel@holzheu-laptop>
            <1290430075.5655.3.camel@holzheu-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290449494_5325P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 22 Nov 2010 13:11:34 -0500
Message-ID: <9359.1290449494@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4CEAB256.0211,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290449494_5325P
Content-Type: text/plain; charset=us-ascii

On Mon, 22 Nov 2010 13:47:55 +0100, Michael Holzheu said:

> Currently the cumulative time accounting in Linux is not complete.
> Due to POSIX POSIX.1-2001, the CPU time of processes is not accounted
> to the cumulative time of the parents, if the parents ignore SIGCHLD
> or have set SA_NOCLDWAIT. This behaviour has the major drawback that
> it is not possible to calculate all consumed CPU time of a system by
> looking at the current tasks. CPU time can be lost.
> 
> This patch adds a new sysctl "kernel.full_cdata" that allows to switch
> between the POSIX behavior and complete cumulative accounting.

> +unsigned int full_cdata_enabled = 1;

This probably needs to default to "current kernel behavior" but allow
sysadmins to change to the new behavior.

--==_Exmh_1290449494_5325P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM6rJWcC3lWbTT17ARAhLuAJ9w9yHiwsgg93iJ9IglEfL7oX5UjQCeK/t3
zhgax7MWZ1/i9HVqgzueW/o=
=PjvI
-----END PGP SIGNATURE-----

--==_Exmh_1290449494_5325P--

