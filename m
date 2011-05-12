Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab1ELGTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 02:19:38 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35332 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755381Ab1ELGTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 02:19:37 -0400
Date: Thu, 12 May 2011 06:19:28 +0000
From: Pavel Machek <pavel@ucw.cz>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        Len Brown <len.brown@intel.com>
Subject: Re: [RFC PATCH v3 1/2] PM / Core: suspend_again callback for
	suspend_ops.
Message-ID: <20110512061928.GB2460@localhost.ucw.cz>
References: <1305091105-27173-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305091105-27173-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> A system or a device may need to control suspend/wakeup events. It may
> want to wakeup the system after a predefined amount of time or at a
> predefined event decided while entering suspend for polling or delayed
> work. Then, it may want to enter suspend again if its predefined wakeup
> condition is the only wakeup reason and there is no outstanding events;
> thus, it does not wakeup the userspace unnecessary or unnecessary
> devices and keeps suspended as long as possible (saving the power).
> 
> Enabling a system to wakeup after a specified time can be easily
> achieved by using RTC. However, to enter suspend again immediately
> without invoking userland and unrelated devices, we need additional
> features in the suspend framework.

Looks ok to me.

>  /**
>   *	suspend_enter - enter the desired system sleep state.
>   *	@state:		state to enter
> + *	@pm_wkup_pending:	indicates that the power transition in progress
> + *				should be aborted.
>   *

Wowels are cheap, I'd add them here.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
