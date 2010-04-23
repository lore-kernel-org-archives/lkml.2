Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab0DWP3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:29:53 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45182 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756259Ab0DWP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:29:48 -0400
Date: Fri, 23 Apr 2010 10:43:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj??nnev??g <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/9] PM: suspend_block: Add driver to access suspend
 blockers from user-space
Message-ID: <20100423084349.GC1573@ucw.cz>
References: <1271984938-13920-1-git-send-email-arve@android.com>
 <1271984938-13920-2-git-send-email-arve@android.com>
 <1271984938-13920-3-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271984938-13920-3-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add a misc device, "suspend_blocker", that allows user-space processes
> to block auto suspend. The device has ioctls to create a suspend_blocker,
> and to block and unblock suspend. To delete the suspend_blocker, close
> the device.
> 
> Signed-off-by: Arve Hj??nnev??g <arve@android.com>

> --- a/Documentation/power/suspend-blockers.txt
> +++ b/Documentation/power/suspend-blockers.txt
> @@ -95,3 +95,20 @@ if (list_empty(&state->pending_work))
>  else
>  	suspend_block(&state->suspend_blocker);
>  
> +User-space API
> +==============
> +
> +To create a suspend_blocker from user-space, open the suspend_blocker device:
> +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> +then call:
> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);


This seems like very wrong idea -- it uses different ioctl number for
each length AFAICT.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
