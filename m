Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0DXFjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 01:39:22 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33978 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751434Ab0DXFjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 01:39:20 -0400
Date: Sat, 24 Apr 2010 07:39:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tytso@mit.edu, Arve Hj??nnev??g <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/9] PM: suspend_block: Add driver to access suspend
 blockers from user-space
Message-ID: <20100424053916.GA2290@elf.ucw.cz>
References: <1271984938-13920-1-git-send-email-arve@android.com>
 <1271984938-13920-2-git-send-email-arve@android.com>
 <1271984938-13920-3-git-send-email-arve@android.com>
 <20100423084349.GC1573@ucw.cz>
 <20100424015334.GO14986@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100424015334.GO14986@thunk.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-04-23 21:53:34, tytso@mit.edu wrote:
> On Fri, Apr 23, 2010 at 10:43:49AM +0200, Pavel Machek wrote:
> > > +To create a suspend_blocker from user-space, open the suspend_blocker device:
> > > +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> > > +then call:
> > > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);
> > 
> > 
> > This seems like very wrong idea -- it uses different ioctl number for
> > each length AFAICT.
> 
> Yep, and there's nothing wrong with that IMHO.  It's a clever use of
> the _IOC encoding scheme.

I'm not sure if "clever" is right word. So what if strlen is in 2GB
range, will macros still work correctly?

Will it be easy for strace to display such ioctls?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
