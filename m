Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935594Ab1JFADp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 20:03:45 -0400
Received: from bfs011.mtl1.boxfabric.com ([74.117.141.19]:49456 "EHLO
	bfs011.mtl1.boxfabric.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935554Ab1JFADo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 20:03:44 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Oct 2011 20:03:44 EDT
X-Originating-IP: 173.35.101.49
Message-ID: <4E8CEECF.4050008@mark.mielke.cc>
Date: Wed, 05 Oct 2011 19:57:03 -0400
From: Mark Mielke <mark@mark.mielke.cc>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Appropriate use of sync() from user space?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

Quick summary: We have a vendor who is claiming that it is required for 
their userspace program to execute sync(), and I am looking for some 
sort of authoritative document or person to refer them to that will 
state that this belief is incorrect and/or that this architecture is not 
acceptable in a Unix environment.

I checked Google and the archives and didn't find anything appropriate. 
Unfortunately, the word "sync" is very popular. :-)

We have users who have been experiencing 3 to 5 minutes "freezes" for a 
particular command which often times out and fails. I traced this down 
from the commercial userspace program (IBM Rational ClearCase / 
"cleartool mkview") that they are executing to a backend "view_server" 
process (also IBM Rational ClearCase) that is running sync() as a means 
of synchronizing their database to disk before proceeding, and VMware 
using a "large" memory mapped file to back it's virtual "RAM". The 
sync() for my computer normally completes in 7 to 8 seconds. The sync() 
for some of our users is taking 5 minutes or longer. This can be 
demonstrated simply by typing "time sync" from the command line at 
intervals. The time itself is relevant because if it finishes before a 
timeout elapses - the operation works (albeit slowly). If the timeout 
elapses, the operation fails.

The vendor stated that sync() is integral to their synchronization 
process to ensure all files reach disk before they are accessed, and 
that this is not a defect in their product. We have a work around - run 
"sync" before calling their command, and this generally avoids the failures.

I think the use of sync() in this regard is a hack. According to POSIX.1 
and the Linux man pages, it seems clear to me that sync() does not 
guarantee data integrity (bytes guaranteed to have reached disk) - and 
it also seems clear that forcing all system data to flush out in 
response to a minor command is over kill. Like cutting down the forest 
to harvest fruit from a single tree.

I'm wondering what you think.

Thanks!

-- 
Mark Mielke<mark@mielke.cc>

