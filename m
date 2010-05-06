Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab0EFT12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 15:27:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53080 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687Ab0EFT10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 15:27:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Date: Thu, 6 May 2010 21:28:30 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
References: <Pine.LNX.4.44L0.1005061110090.1708-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005061110090.1708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005062128.31068.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 May 2010, Alan Stern wrote:
> On Tue, 27 Apr 2010, [UTF-8] Arve Hjønnevåg wrote:
> 
> > +static void suspend_worker(struct work_struct *work)
> > +{
> > +	int ret;
> > +	int entry_event_num;
> > +
> > +	enable_suspend_blockers = true;
> > +	while (!suspend_is_blocked()) {
> > +		entry_event_num = current_event_num;
> > +
> > +		if (debug_mask & DEBUG_SUSPEND)
> > +			pr_info("suspend: enter suspend\n");
> > +
> > +		ret = pm_suspend(requested_suspend_state);
> > +
> > +		if (debug_mask & DEBUG_EXIT_SUSPEND)
> > +			pr_info_time("suspend: exit suspend, ret = %d ", ret);
> > +
> > +		if (current_event_num == entry_event_num)
> > +			pr_info("suspend: pm_suspend returned with no event\n");
> > +	}
> > +	enable_suspend_blockers = false;
> > +}
> 
> Here's a completely new issue.  When using opportunistic suspends on an
> SMP system, it could happen that the system gets a wakeup event and
> this routine starts running again before the event's IRQ handler has
> finished (or has enabled a suspend blocker).  The system would 
> re-suspend too soon.

This routine will be run from a freezable workqueue.

Rafael
