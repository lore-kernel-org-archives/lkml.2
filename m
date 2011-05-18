Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1ERUTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:19:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37083 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1ERUTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:19:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@gmail.com
Subject: Re: [PATCH v4 1/2] PM / Core: suspend_again callback for suspend_ops.
Date: Wed, 18 May 2011 22:20:21 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, kyungmin.park@samsung.com
References: <20110512061928.GB2460@localhost.ucw.cz> <201105172240.46970.rjw@sisk.pl> <BANLkTim6ygf9JN2k1ZnW5kLwvUggDBJyNA@mail.gmail.com>
In-Reply-To: <BANLkTim6ygf9JN2k1ZnW5kLwvUggDBJyNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105182220.21512.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 18, 2011, MyungJoo Ham wrote:
> 2011/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Tuesday, May 17, 2011, MyungJoo Ham wrote:
> []
> >> -static int suspend_enter(suspend_state_t state)
> >> +static int suspend_enter(suspend_state_t state, bool *wakeup_pending)
> >
> > You don't need to use the wakeup_pending argument at all.  I think you
> > shouldn't use it even, because in theory there may be a wakeup event after
> > you've called pm_wakeup_pending() in suspend_enter() and in that case
> > you should break the loop too.
> 
> In the case where:
> - at the first instance of suspend_enter, pm_wakeup_pending() returns false.
> - after suspend_ops->enter(state), the pm_wakeup_pending() "wants" to
> return true.
> - however, suspend_again forces to loop again.
> - then, at the second instance of suspend_enter, pm_wakeup_pending()
> returns true.
> - the suspend_again's loop breaks.
> 
> Although it did not break the loop at the first while, it breaks
> without calling suspend_ops->enter again anyway.
> 
> []
> >
> > So I would simply call pm_wakeup_pending() here again.
> >
> 
> Besides, if we simply call pm_wakeup_pending() again at there, the
> loop will NOT break with pm_wakeup_pending() is true at the first call
> inside of suspend_enter(). The function pm_wakeup_pending() clears out
> the pending wakeup at each call;

Ah, that's correct, sorry.

Thanks,
Rafael
