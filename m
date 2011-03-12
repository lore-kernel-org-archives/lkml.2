Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1CLDTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 22:19:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39758 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab1CLDTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 22:19:21 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=PCBOxHqunuYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=jI3BtlD2OduDyyqymZ4A:9 a=_19wnQ7AVOMvU85J0HgA:7 a=SJumPSI6VrAsVx2DVhUnoqEsImwA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110312031435.890203189@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 11 Mar 2011 22:14:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/4] futex,plist: updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last December Lai sent out a series of 4 patches. But as it was close
to the holiday season and we were all trying to finish up our own
agendas for year end, they were dropped.

As I'm expunging my inbox, I rediscovered them. I applied and ran
various tests, and spent some time reviewing them as well.
I don't see anything wrong with them, but perhaps others might.

Please take a moment to look at them and feel free to pull them
in if you think they are fine. I based this branch off of
v2.6.38-rc8.

Darren Hart did Ack the first two.

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git

    branch: rt/tip/futex/devel


Lai Jiangshan (4):
      futex,plist: Pass the real head of the priority list to plist_del()
      futex,plist: Remove debug lock assignment from plist_node
      plist: Shrink struct plist_head
      plist: Add priority list test

----
 include/linux/plist.h |   47 +++++++++--------
 kernel/futex.c        |   40 ++++++++------
 lib/plist.c           |  135 +++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 162 insertions(+), 60 deletions(-)
