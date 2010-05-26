Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0EZM6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:58:11 -0400
Received: from [18.85.46.34] ([18.85.46.34]:46180 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0EZM6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:58:08 -0400
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
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
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Greg KH <gregkh@suse.de>, tytso@mit.edu,
       James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <20100526124929.GA32580@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org>
	 <201005252344.37639.rjw@sisk.pl>
	 <AANLkTimL5rU5lALezEZVCwdcZL85tVahhsTibdpq9s-Y@mail.gmail.com>
	 <1274863342.5882.4850.camel@twins> <1274863987.5882.4892.camel@twins>
	 <20100526124929.GA32580@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 14:57:45 +0200
Message-ID: <1274878665.27810.354.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 13:49 +0100, Matthew Garrett wrote:

Lack of quoting makes it hard to see what your 'this' refers to. I'll
assume its the userspace suspend manager.

> While this approach could be made to work, it's ugly in other ways. 
> After wakeup, userspace has to pause for a while before it can trigger 
> another sleep in order to give all the apps an opportunity to check for 
> wakeup events and block suspend if they wish to. That's additional 
> runtime that doesn't exist in the kernel-mediated case.

I fail to see why. In both cases the woken userspace will contact a
central governing task, either the kernel or the userspace suspend
manager, and inform it there is work to be done, and please don't
suspend now.

Also, since we did get woken, there clearly is work to do and we should
only try suspending again once someone did inform us of completing it.

In both cases, once the event is fully handled, will there be
communication of this fact and suspend can be attempted.

I don't see a reason to 'wait' for anything -- except maybe speculate on
the avgerage wakeup rate and decide not to suspend quite yet.
