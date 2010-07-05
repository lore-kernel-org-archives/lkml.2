Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0GEUpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 16:45:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53703 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab0GEUpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 16:45:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Valdis.Kletnieks@vt.edu
Subject: Re: mmotm 2010-07-01 pm_get_wakeup_count() declaration
Date: Mon, 5 Jul 2010 22:43:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <201007011948.o61JmnT2022795@imap1.linux-foundation.org> <74766.1278362136@localhost>
In-Reply-To: <74766.1278362136@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201007052243.55551.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 05, 2010, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 01 Jul 2010 12:19:51 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-07-01-12-19 has been uploaded to
> 
> Not sure who to blame for the commit, it was in the linux-next.patch and I'm
> too lazy to pull down the git tree and dig it out.
> 
>   CC      kernel/power/main.o
> kernel/power/main.c: In function 'wakeup_count_show':
> kernel/power/main.c:241: error: implicit declaration of function 'pm_get_wakeup_count'
> kernel/power/main.c: In function 'wakeup_count_store':
> kernel/power/main.c:251: error: implicit declaration of function 'pm_save_wakeup_count'
> make[2]: *** [kernel/power/main.o] Error 1
> 
> Problem is that declaration in include/linux/suspend.h is wrapped in
> a #ifdef CONFIG_PM_SLEEP, but the usage in kernel/power/main.c isn't. So
> it dies a horrid death if your config doesn't include PM_SLEEP.

Yeah, sorry.  I'm in the process of fixing it up.

Thanks,
Rafael
