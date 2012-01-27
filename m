Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab2A0XUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 18:20:09 -0500
Received: from static-96-229-114-10.lsanca.fios.verizon.net ([96.229.114.10]:34922
	"EHLO mail.lorez.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2A0XUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 18:20:07 -0500
X-Greylist: delayed 1666 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jan 2012 18:20:07 EST
Message-ID: <4F232AA4.5070208@lorez.org>
Date: Fri, 27 Jan 2012 14:52:20 -0800
From: Bob Richmond <bob@lorez.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Real time clock update notification
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any kind of facility for a process that is blocking in any one 
of the event notification system calls (select/poll/epoll_wait) to be 
unblocked in the event that the realtime clock has been updated? For 
instance, say I want to fire off an event at the exact moment that the 
realtime clock flips to 2pm. I first query the realtime clock via 
clock_gettime(CLOCK_REALTIME), and know that in 3 hours, it will be 2pm 
and I want to unblock at that moment. So I block in epoll_wait for 3 hours.

Then ntpd decides that the rtc is way off, and updates the current time 
to 1:30, and I should now be unblocking 30 minutes from now. However, my 
process can't know that this occurred and I should requery the rtc to 
find out how long I need to sleep *now*. It looks like crond (which 
performs a similar task) just wakes itself up every 60 seconds, which 
isn't particularly ideal.

If this facility doesn't exist, I'm curious whether something like it 
would be feasible to introduce with minimal overhead. I'm unsure how 
often ntpd resets the rtc when clock skew is detected, and my process 
might be excessively notified whenever the time changes by a few 
milliseconds.
