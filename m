Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2J1XXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:23:51 -0400
Received: from hibox-130.abo.fi ([130.232.216.130]:43953 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab2J1XXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:23:50 -0400
X-Greylist: delayed 2635 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Oct 2012 19:23:50 EDT
Message-ID: <508DB432.2030208@hibox.fi>
Date: Mon, 29 Oct 2012 00:39:46 +0200
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121017 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Debugging system freezes on filesystem writes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a big problem with the system freezing and would appreciate any 
help on debugging this and pinpointing where exactly the problem is, so 
it could be fixed.

So, whenever I write to the disk the system comes to a crawl or freezes 
altogether. This happens even when the writing processes are running on 
nice '19' and ionice 'idle'. (E.g. a 10 second compile could freeze the 
system for several minutes, rendering the computer pretty much unusable 
for anything interesting.)

Here you can see a 20 second gap even in superhigh priority:
# nice -n -20 ionice -c1 iostat -t -m -d -x 1 > http://pastebin.com/j5qnh2VV

I'm currently running 3.5.0-17-lowlatency on the ZenBook UX31E, using 
the NOOP I/O scheduler on the SanDisk SSD U100. The chipset seems to be 
Intel QS67. I've had this same problem on 3.2.0 generic and lowlatency 
kernels.

The syslog says nothing relevant before/during/after these freezes.

Any ideas on finding the culprit?


Regards,
Marcus

