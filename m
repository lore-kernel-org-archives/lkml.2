Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab0ETLZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:25:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0ETLZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:25:10 -0400
Message-ID: <4BF51B0A.1050901@redhat.com>
Date: Thu, 20 May 2010 07:20:42 -0400
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
Organization: RedHat
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: RFC: dirty_ratio back to 40%
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've seen multiple performance regressions linked to the lower(20%)
dirty_ratio.  When performing enough IO to overwhelm the background  
flush daemons the percent of dirty pagecache memory quickly climbs 
to the new/lower dirty_ratio value of 20%.  At that point all writing 
processes are forced to stop and write dirty pagecache pages back to disk.  
This causes performance regressions in several benchmarks as well as causing
a noticeable overall sluggishness.  We all know that the dirty_ratio is
an integrity vs performance trade-off but the file system journaling
will cover any devastating effects in the event of a system crash.

Increasing the dirty_ratio to 40% will regain the performance loss seen
in several benchmarks.  Whats everyone think about this???





------------------------------------------------------------------------

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ef27e73..645a462 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -78,7 +78,7 @@ int vm_highmem_is_dirtyable;
 /*
  * The generator of dirty data starts writeback at this percentage
  */
-int vm_dirty_ratio = 20;
+int vm_dirty_ratio = 40;
 
 /*
  * vm_dirty_bytes starts at 0 (disabled) so that it is a function of

