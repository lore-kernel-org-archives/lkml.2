Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1JQX1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:27:41 -0400
Received: from mail.lang.hm ([64.81.33.126]:46875 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab1JQX1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:27:40 -0400
Date: Mon, 17 Oct 2011 16:27:39 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: timer slack
Message-ID: <alpine.DEB.2.02.1110171613530.28233@asgard.lang.hm>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apologies for breaking threading, but I missed the messages on this 
thread, but wanted to comment after seeing the article on LWN

I don't believe that the idea of 'fix the apps' is reasonable. The apps 
are not the right places to put the fixes for a number of reasons.

First:

even if the apps do all properly put themselves into an appropiate 
'background/inactive' status, there are sitll a number of reasons for apps 
to wake up on a periodic basis to do things

check for alarms

check battery life

sample some real-world value (including location)

check for new mail

etc

these things are all scheduled by each app indepndantly of each other, and 
as a result, each one is likely to cause a separate wakeup event. If the 
timer slack was lengthened to 60 seconds it is far more likely that all 
such wakeups could be processed at once.


Second:

the appropriate amount of delay is not fixed for each application, it can 
depend on a lot of different conditions, for example:

is the device on external power, and external screen, etc (aka acting as a 
desktop replacement)?

if the device on battery power?

is the battery <10% (where the user may want to delay wakeups much longer, 
accepting things being less up to date in exchange for stretching the 
remaining battery life)

these sorts of policies should not be put into each application, but this 
fits very nicely with a system-wide power management tool (that already 
decides when to dim the screen, pause the system, hibernate, power down 
completely, etc)


the assumption from the discussion seems to be that all apps on a system 
will be in the same cgroup and therefor follow the same rules. nothing 
says that this must be the case. I could easily see having multiple groups 
for different purposes (alarms vs background data sync tasks for example)


All of this is completely separate from the argument that trying to get 
every programmer in the world to fix their application is a lost cause.

remember that not every application programmer is planning for their 
application to run on a power constrained device.

not every application programmer is planning for their application to run 
on Linux (at least not to the point of being willing to put linux-specific 
system calls and power management features in it)

don't assume that all applications that run on mobile devices are going to 
be ones written with that as their primary focus. With today's available 
systems this is usually the case, but it does not need to be.


Personally, I strongly suspect that agressive timer slack with userspace 
management could get power savings similar to (or better than) what 
android gets from userspace wakelocks. Today there isn't a good way to try 
this, I would love to have something like this available to test and see 
if I am right.

David Lang
