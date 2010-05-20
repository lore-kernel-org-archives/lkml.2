Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0ETJL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:11:27 -0400
Received: from ist.d-labs.de ([213.239.218.44]:37496 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab0ETJL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:11:26 -0400
Date: Thu, 20 May 2010 11:11:11 +0200
From: Florian Mickler <florian@mickler.org>
To: Pavel Machek <pavel@ucw.cz>
Newsgroups: gmane.linux.documentation,gmane.linux.kernel
Cc: Arve Hj??nnev??g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100520111111.333beb73@schatten.dmk.lab>
In-Reply-To: <20100518131111.GB1563@ucw.cz>
References: <1273810273-3039-1-git-send-email-arve@android.com>
	<1273810273-3039-2-git-send-email-arve@android.com>
	<20100518131111.GB1563@ucw.cz>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010 15:11:11 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> On Thu 2010-05-13 21:11:06, Arve Hj??nnev??g wrote:
> > Adds /sys/power/policy that selects the behaviour of /sys/power/state.
> > After setting the policy to opportunistic, writes to /sys/power/state
> > become non-blocking requests that specify which suspend state to
> > enter
> 
> Yeah, one file selects behavior of another file, and to read available
> states for opportunistic, you have to write to file first.
> 
> I still don't like the interface.
> 

Actually, what would be a better interface? 

I wonder why it is not like this:

/sys/power/state 
	no change, works with and without opportunistic suspend the
	same. Ignores suspend blockers. Really no change. (From user
	perspective)

/sys/power/opportunistic
	On / Off
	While Off the opportunistic suspend is off.
	While On, the opportunistic suspend is on and if there are no
	suspend blockers the system goes to suspend. 

Cheers,
Flo



