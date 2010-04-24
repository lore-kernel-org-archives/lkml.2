Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0DXC0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:26:03 -0400
Received: from thunk.org ([69.25.196.29]:44080 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab0DXCZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:25:59 -0400
Date: Fri, 23 Apr 2010 21:53:34 -0400
From: tytso@mit.edu
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj??nnev??g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/9] PM: suspend_block: Add driver to access suspend
 blockers from user-space
Message-ID: <20100424015334.GO14986@thunk.org>
Mail-Followup-To: tytso@mit.edu, Pavel Machek <pavel@ucw.cz>,
	Arve Hj??nnev??g <arve@android.com>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Magnus Damm <damm@igel.co.jp>,
	Nigel Cunningham <nigel@tuxonice.net>,
	Cornelia Huck <cornelia.huck@de.ibm.com>, linux-doc@vger.kernel.org
References: <1271984938-13920-1-git-send-email-arve@android.com>
 <1271984938-13920-2-git-send-email-arve@android.com>
 <1271984938-13920-3-git-send-email-arve@android.com>
 <20100423084349.GC1573@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423084349.GC1573@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 10:43:49AM +0200, Pavel Machek wrote:
> > +To create a suspend_blocker from user-space, open the suspend_blocker device:
> > +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> > +then call:
> > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);
> 
> 
> This seems like very wrong idea -- it uses different ioctl number for
> each length AFAICT.

Yep, and there's nothing wrong with that IMHO.  It's a clever use of
the _IOC encoding scheme.

						- Ted
