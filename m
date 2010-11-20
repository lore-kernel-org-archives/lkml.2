Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab0KTAFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 19:05:10 -0500
Received: from mail.wdtv.com ([66.118.69.84]:39562 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab0KTAFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 19:05:09 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Galbraith patch
Date: Fri, 19 Nov 2010 19:05:03 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.3; i686; ; )
Cc: Jordi Pujol <jordipujolp@gmail.com>, LKML <linux-kernel@vger.kernel.org>
References: <201011191509.49586.jordipujolp@gmail.com> <201011191005.12189.gene.heskett@gmail.com> <1290183668.24581.16.camel@maggy.simson.net>
In-Reply-To: <1290183668.24581.16.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191905.03889.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 19, 2010, Mike Galbraith wrote:
>On Fri, 2010-11-19 at 10:05 -0500, Gene Heskett wrote:
>> On Friday, November 19, 2010, Jordi Pujol wrote:
>> >Hello,
>> >
>> >it requires a little modification,
>> >
>> >CONFIG_SCHED_DEBUG should not be a condition to create autogroup in
>> >structure task_group
>> >
>> >remove
>> >
>> >    && defined(CONFIG_SCHED_DEBUG)
>> >
>> >in the following conditional:
>> >
>> >+++ linux-2.6.36/kernel/sched.c
>> >@@ -78,6 +78,7 @@
>> >
>> > #include "sched_cpupri.h"
>> > #include "workqueue_sched.h"
>> >
>> >+#include "sched_autogroup.h"
>> >
>> > #define CREATE_TRACE_POINTS
>> > #include <trace/events/sched.h>
>> >
>> >@@ -268,6 +269,10 @@ struct task_group {
>> >
>> > 	struct task_group *parent;
>> > 	struct list_head siblings;
>> > 	struct list_head children;
>> >
>> >+
>> >+#if (defined(CONFIG_SCHED_AUTOGROUP) && defined(CONFIG_SCHED_DEBUG))
>> >+	struct autogroup *autogroup;
>> >+#endif
>> >
>> > };
>> >
>> >Kind,
>> >
>> >Jordi Pujol
>> 
>> Thanks Jordi, but my last attempted build, using only the last 2
>> patches that Mike posted on a fresh unpack of 2.6.36, couldn't get
>> past stage 2 of the modules build, it kept squawking about all the IR
>> control stuff that is not even configured to be built.
>
>No idea what's going on with that.  Maybe you should wait until I get
>the /proc display/tweak interface cobbled together and post a checked
>over patch instead of hasty WIP snapshot.

I have come to that conclusion of too.  But because I am interested in an 
improvement in this 'interactivity' of the desktop, I was willing to give 
even the WIP a try.  If what I report helps you, then my testing effort is 
not wasted.  The more eyes and different hdwe theory. ;-)

Thanks Mike.

>> I wonder how long it will take to get work this into mainline?
>
>If it goes in at all, it won't be before .38.

I was hoping sooner.  Some of us could use the help this seems to promise.

>> Along the same line, how does this compare to CK's bfs patch?
>
>Like apple vs orange.
>
And they both contain too much sugar for me.  Dammit.

>	-Mike


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Deliberation, n.:
	The act of examining one's bread to determine which side it is
	buttered on.
		-- Ambrose Bierce, "The Devil's Dictionary"
