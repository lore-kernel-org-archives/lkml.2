Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2CIPUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:20:46 -0500
Received: from claranet-outbound-smtp03.uk.clara.net ([195.8.89.36]:33854 "EHLO
	claranet-outbound-smtp03.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757172Ab2CIPUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:20:43 -0500
X-Greylist: delayed 2563 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2012 10:20:43 EST
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: x86@kernel.org
Subject: udelay minimum delay guarantee and maximum supported delay?
Date: Fri, 9 Mar 2012 14:37:50 +0000
User-Agent: KMail/1.13.7 (Linux/3.1.0-90.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203091437.50996.tvrtko.ursulin@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I was debugging some weird driver behaviour under 3.3.0-rc6+ (amd64) and 
eventually I got to discovering udelay's driver is issuing are occasionally 
short. That results in random hardware behaviour, but that is beside the 
point.

Driver in question wants to delay for 500us at a time, which is not a terribly 
nice thing to do, but putting that aside and talking more in general I would 
have three questions:

1. Are 500us udelays supposed to work? (I know they are not recommended and 
I'll fix that.)
2. Should udelay guarantee it won't delay by less than the time asked?
3. Is ktime_get() considered accurate enough to measure how long udelay 
actually delayed? (Empirical evidence suggests it is, because hardware 
weirdness correlates perfectly with occurences of these short udelays.)

If answers to all are yes then we might have a bug here.

Because I am seeing udelay(500) (_occasionally_) being short, and that by 
delaying for some duration between 0us (yep) and 491us.

As far as I can see this box is using TSC delay and CPU (Intel(R) Core(TM) 
i5-2400S CPU @ 2.50GH) exposes the constant_tsc flag:

 [    1.717050] Refined TSC clocksource calibration: 2494.334 MHz.
 [    1.717054] Switching to clocksource tsc

Am I missing something and what are your opinions?

Thanks,

Tvrtko
