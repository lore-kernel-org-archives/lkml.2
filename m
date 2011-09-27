Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1I0W70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:59:26 -0400
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:47448 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1I0W7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:59:25 -0400
Message-ID: <4E82553A.5020906@genband.com>
Date: Tue, 27 Sep 2011 16:59:06 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG?] anyone aware of pagecache issues with 2.6.27?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2011 22:59:08.0047 (UTC) FILETIME=[100171F0:01CC7D69]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18412.002
X-TM-AS-Result: No--14.737700-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I realize this is a long shot, but I figure it's worth a try.

What we're seeing is that "cached" gets large (several gigs) and "free" 
gets small, and when we get into this state our system responsiveness 
starts dropping.  If I do "echo 3 > /proc/sys/vm/drop_caches", then it 
immediately frees up a couple gig of memory and things work as expected.

Based on the fact that memory is immediately reclaimable from the cache 
it appears that the bulk of the cache is clean pages.  This shouldn't 
have a major impact on memory allocation, but at least on this setup it 
does.  It seems like there is something not quite right about the 
mechanism that reclaims clean pages from the cache.  Is anyone aware of 
issues in this area for 2.6.27-vintage kernels?

Is there a way to limit how much memory gets used for the page cache? 
drop_caches seems to help, but it's a really big hammer.

System details:
2.6.27 kernel, x86-64, 8GB RAM, no swap.  Root is on a tmpfs filesystem, 
local disks are used for miscellaneous stuff including /var/log, we have 
some sizeable network-mounted filesystems. 
/proc/sys/vm/overcommit_memory is set to 2, with overcommit_ratio set to 
100.


Thanks,
Chris


-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
