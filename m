Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab1ABXFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 18:05:24 -0500
Received: from dm-mail02.mozilla.org ([63.245.208.176]:40742 "EHLO
	dm-mail02.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1ABXFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 18:05:23 -0500
X-Greylist: delayed 1474 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Jan 2011 18:05:23 EST
Message-ID: <4D20FEF0.5020206@mozilla.com>
Date: Sun, 02 Jan 2011 14:40:48 -0800
From: Taras Glek <tglek@mozilla.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0b9pre) Gecko/20101231 Thunderbird/3.3a2pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Measuring startup-time from userspace
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Does Linux provide a reasonable way to measure how long a process has 
existed for? The goal is to have a function that returns the number of 
milliseconds since process-creation.

We'd like to be able to have Firefox self-diagnose startup times. 
Unfortunately, it turns out that library loading time adds a lot to 
startup before application code runs, so a in-application timer would 
underestimate startup time.

It appears that the most precise solution is to read start time from 
/proc/self/stat. Unfortunately the time is in jiffies-since-startup and 
there don't seem to be any good counters to compare against (ie 
/proc/uptime doesn't provide enough resolution). So far the only 
workable solution seems to create a new thread/process. Then one can do 
(/proc/<newpid>/stat.starttime - /proc/self/stat.starttime) * 1000 / HZ
.

The question is, there way for a process to measure time-since-startup 
without horrible hacks like spawning a new processes?


Taras

ps. Perhaps /proc/timer_list contains enough info?
