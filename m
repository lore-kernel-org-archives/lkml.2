Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab0GEUhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 16:37:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57501 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab0GEUhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 16:37:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: mmotm 2010-07-01 pm_get_wakeup_count() declaration
In-Reply-To: Your message of "Thu, 01 Jul 2010 12:19:51 PDT."
             <201007011948.o61JmnT2022795@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201007011948.o61JmnT2022795@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1278362136_4495P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Jul 2010 16:35:36 -0400
Message-ID: <74766.1278362136@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4C324219.0163,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1278362136_4495P
Content-Type: text/plain; charset=us-ascii

On Thu, 01 Jul 2010 12:19:51 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-07-01-12-19 has been uploaded to

Not sure who to blame for the commit, it was in the linux-next.patch and I'm
too lazy to pull down the git tree and dig it out.

  CC      kernel/power/main.o
kernel/power/main.c: In function 'wakeup_count_show':
kernel/power/main.c:241: error: implicit declaration of function 'pm_get_wakeup_count'
kernel/power/main.c: In function 'wakeup_count_store':
kernel/power/main.c:251: error: implicit declaration of function 'pm_save_wakeup_count'
make[2]: *** [kernel/power/main.o] Error 1

Problem is that declaration in include/linux/suspend.h is wrapped in
a #ifdef CONFIG_PM_SLEEP, but the usage in kernel/power/main.c isn't. So
it dies a horrid death if your config doesn't include PM_SLEEP.

--==_Exmh_1278362136_4495P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMMkIYcC3lWbTT17ARAiK5AKCFH+wKqddKak0q92FzUIvIrk/rrwCgqGLf
nPAv8+nNsZ/iUjxjvKKh/j8=
=Ubv5
-----END PGP SIGNATURE-----

--==_Exmh_1278362136_4495P--

