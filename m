Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab0E0Ar3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 20:47:29 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35549 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752721Ab0E0Ar2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 20:47:28 -0400
Date: Wed, 26 May 2010 20:47:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
In-Reply-To: <AANLkTikFwznonORd42piWZvBv3oqqSj9odC9Jaud8o3x@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005262044001.6349-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Arve Hjønnevåg wrote:

> > I must be missing something.  In Arve's patch 1/8, if the system is in
> > opportunistic suspend, and a wakeup event occurs but no suspend
> > blockers get enabled by the handler, what causes the system to go back
> > into suspend after the event is handled?  Isn't that a loop of some
> > sort?
> >
> 
> Yes it is a loop. I think what you are missing is that it only loops
> repeatedly if the driver that aborts suspend does not use a suspend
> blocker.

You mean "the driver that handles the wakeup event".  I was asking what 
happened if suspend succeeded and then a wakeup occurred.  But yes, if 
a suspend blocker is used then its release causes another suspend 
attempt, with no looping.

> > And even if it isn't, so what?  What's wrong with looping behavior?
> 
> It is a significant power drain.

Not in the situation I was discussing.

Alan Stern

