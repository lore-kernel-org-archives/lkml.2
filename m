Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1HBAwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 20:52:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:27520 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab1HBAwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 20:52:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,303,1309762800"; 
   d="scan'208";a="34449940"
Date: Mon, 1 Aug 2011 17:52:06 -0700
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        rientjes@google.com
Subject: Revert needed: udev spewing warnons on common systems in 3.0
Message-ID: <20110802005206.GA3832@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you please revert 

commit be8f684d73d8d916847e996bf69cef14352872c6
Author: David Rientjes <rientjes@google.com>
Date:   Mon Jul 25 17:12:18 2011 -0700

    oom: make deprecated use of oom_adj more verbose

    /proc/pid/oom_adj is deprecated and scheduled for removal in August 2012
    according to Documentation/feature-removal-schedule.txt.


This makes most of my test systems (suse 11.1, 11.2) spew scary WARN_ONs
on every boot. GNOME then also complains. While it doesn't cause actual 
misfunction it scares me every time I boot and other people who can't
read git logs like me will be unnecessary scared.

Also the warning is completely useless: noone will be "fixing"
udev on old distributions.

IMHO that's not acceptable to break common user land like this.
Linux is supposed to be binary compatible and this patch is not
in this spirit.

Actually removing the file later should be still fine, but 
not printing out these scary messages.

I propose to revert this misguided patch for stable and 3.1

Thanks,

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
