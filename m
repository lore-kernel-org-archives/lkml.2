Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab1EIRC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 13:02:57 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:51360 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1EIRCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 13:02:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc6-mmotm0506 and -next - __kfree_rcu breaks third-party kernel code
In-Reply-To: Your message of "Mon, 09 May 2011 12:56:32 EDT."
             <14010.1304960192@localhost>
From: Valdis.Kletnieks@vt.edu
References: <7961.1304953500@localhost> <20110509091757.580f3f6c.randy.dunlap@oracle.com>
            <14010.1304960192@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304960536_2759P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 09 May 2011 13:02:16 -0400
Message-ID: <14344.1304960536@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4DC81E19.00F5,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304960536_2759P
Content-Type: text/plain; charset=us-ascii

On Mon, 09 May 2011 12:56:32 EDT, Valdis.Kletnieks@vt.edu said:

> OK, *now* I'm confused.  The magic sauce appears to be "-Os". Adding that makes
> the compile work.  And for no obvious reason - there's something in there that
> causes indigestion, but only if the optimizer isn't invoked.

/lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/rcupdate.h: In function '__kfree_rcu':
/lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/rcupdate.h:822:2: error: size of unnamed array is negative

Apparently, it's in fact bad code - but the entire __kfree_rcu() function is
being reaped by the optimizer as dead code before the code generator
sees the size issue with the array.  Without optimization, the code hangs
around long enough for the problem to crop up.


--==_Exmh_1304960536_2759P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNyB4YcC3lWbTT17ARAtMFAJ9SlogAME6VeEfhvUiT1+IPehIDfACeM/2u
SDVXwu2FtrXWy8SYFacDx34=
=c7/F
-----END PGP SIGNATURE-----

--==_Exmh_1304960536_2759P--

