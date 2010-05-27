Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab0E0Awm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 20:52:42 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:49128 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0E0Awl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 20:52:41 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005262044001.6349-100000@netrider.rowland.org>
References: <AANLkTikFwznonORd42piWZvBv3oqqSj9odC9Jaud8o3x@mail.gmail.com>
	<Pine.LNX.4.44L0.1005262044001.6349-100000@netrider.rowland.org>
Date: Wed, 26 May 2010 17:52:40 -0700
Message-ID: <AANLkTingAiO8dkwnInc993PTyA63rV-WRvBIRlB2ChXs@mail.gmail.com>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
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
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/26 Alan Stern <stern@rowland.harvard.edu>:
> On Wed, 26 May 2010, Arve Hjønnevåg wrote:
>
>> > I must be missing something.  In Arve's patch 1/8, if the system is in
>> > opportunistic suspend, and a wakeup event occurs but no suspend
>> > blockers get enabled by the handler, what causes the system to go back
>> > into suspend after the event is handled?  Isn't that a loop of some
>> > sort?
>> >
>>
>> Yes it is a loop. I think what you are missing is that it only loops
>> repeatedly if the driver that aborts suspend does not use a suspend
>> blocker.
>
> You mean "the driver that handles the wakeup event".  I was asking what
> happened if suspend succeeded and then a wakeup occurred.  But yes, if
> a suspend blocker is used then its release causes another suspend
> attempt, with no looping.
>
>> > And even if it isn't, so what?  What's wrong with looping behavior?
>>
>> It is a significant power drain.
>
> Not in the situation I was discussing.
>

If you meant it spend most of the time suspended, then I agree. It
only wastes power when a driver blocks suspend by returning an error
from its suspend hook and we are forced to loop doing no useful work.

-- 
Arve Hjønnevåg
