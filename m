Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab0ECWLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:11:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49460 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758258Ab0ECWLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:11:33 -0400
Date: Mon, 3 May 2010 18:11:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, Arve Hj??nnev??g <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
In-Reply-To: <201005032338.26439.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1005031810000.1328-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 May 2010, Rafael J. Wysocki wrote:

> The main problem is that the entire suspend subsystem is going to work in a
> different way when suspend blockers are enforced.  Thus IMO it makes sense to
> provide a switch between the "opportunistic" and "forced" modes, because that
> clearly indicates to the user (or user space in general) how the whole suspend
> subsystem actually works at the moment.
> 
> As long as it's "opportunistic", the system will autosuspend if suspend
> blockers are not active and the behavior of "state" reflects that.  If you want
> to enforce a transition, switch to "forced" first.
> 
> That's not at all confusing if you know what you're doing.  The defailt mode is
> "forced", so the suspend subsystem works "as usual" by default.  You have to
> directly switch it to "opportunistic" to change the behavior and once you've
> done that, you shouldn't really be surprised that the behavior has changed.
> That's what you've requested after all.

How about changing the contents of /sys/power/state depending on the 
current policy?  When the policy is "forced" it should look the same as 
it does now.  When the policy is "opportunistic" it should contain 
"mem" and "on".

Alan Stern

