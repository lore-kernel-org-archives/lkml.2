Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab0GFCZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:25:31 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:55889 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab0GFCZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:25:30 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: mmotm 2010-07-01 pm_get_wakeup_count() declaration
In-Reply-To: Your message of "Mon, 05 Jul 2010 22:43:55 +0200."
             <201007052243.55551.rjw@sisk.pl>
From: Valdis.Kletnieks@vt.edu
References: <201007011948.o61JmnT2022795@imap1.linux-foundation.org> <74766.1278362136@localhost>
            <201007052243.55551.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1278383075_2695P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Jul 2010 22:24:35 -0400
Message-ID: <2755.1278383075@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4C3293E4.02E0,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1278383075_2695P
Content-Type: text/plain; charset=us-ascii

On Mon, 05 Jul 2010 22:43:55 +0200, "Rafael J. Wysocki" said:
> On Monday, July 05, 2010, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 01 Jul 2010 12:19:51 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2010-07-01-12-19 has been uploaded to
> > 
> > Not sure who to blame for the commit, it was in the linux-next.patch and I'm
> > too lazy to pull down the git tree and dig it out.
> > 
> >   CC      kernel/power/main.o
> > kernel/power/main.c: In function 'wakeup_count_show':
> > kernel/power/main.c:241: error: implicit declaration of function 'pm_get_wakeup_count'
> > kernel/power/main.c: In function 'wakeup_count_store':
> > kernel/power/main.c:251: error: implicit declaration of function 'pm_save_wakeup_count'
> > make[2]: *** [kernel/power/main.o] Error 1
> > 
> > Problem is that declaration in include/linux/suspend.h is wrapped in
> > a #ifdef CONFIG_PM_SLEEP, but the usage in kernel/power/main.c isn't. So
> > it dies a horrid death if your config doesn't include PM_SLEEP.
> 
> Yeah, sorry.  I'm in the process of fixing it up.

I threw in some ad-crock #ifdef to get past that one, and hit
another one, same basic issue but include/linux/pm.h this time:

  CC      drivers/base/power/sysfs.o
drivers/base/power/sysfs.c: In function 'wakeup_count_show':
drivers/base/power/sysfs.c:152: error: 'struct dev_pm_info' has no member named 'wakeup_count'
make[3]: *** [drivers/base/power/sysfs.o] Error 1





--==_Exmh_1278383075_2695P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMMpPjcC3lWbTT17ARAn9iAKCPhhVJOK+6Kfegx1rgtfabw0lrQACeNV9W
rPHrJDs9D644n/JPKiA2JNw=
=9kNE
-----END PGP SIGNATURE-----

--==_Exmh_1278383075_2695P--

