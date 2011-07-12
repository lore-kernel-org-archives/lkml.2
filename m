Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab1GLBiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 21:38:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:37459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab1GLBiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 21:38:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,517,1304319600"; 
   d="scan'208";a="26532980"
Subject: [PATCH v2 0/3]CFQ: add think time check for service tree and group
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 09:37:52 +0800
Message-ID: <1310434672.15392.283.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  Currently when the last queue of a service tree/group is empty, CFQ
doesn't expire the queue. This is to allow requests from the tree/group
come soon, so tree/group doesn't miss its share. But if the think time
is big, the assumption isn't correct. idling the queue is just wasting
bandwidth.

Originally I was hoping this can resolve Vivek's fsync issue, but it
doesn't. The fsync issue is caused by queue idling. But since think time
check only helps for think time above default queue idle time (8ms),
think time check doesn't help for the fsync issue.

On the other hand, think time check is still helpful for queues with
think time. I had test case in follow patches show throughput
improvement without sacrifice tree/group shares.

v1->v2:
1. addressed some good comments from Vivek
2. add more test to make sure the patches don't change behavior of
queues without think time.

Thanks,
Shaohua

