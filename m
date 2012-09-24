Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2IXKFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:05:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28846 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2IXKFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:05:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,474,1344182400"; 
   d="scan'208";a="5907207"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 00/10] workqueue: restructure flush_workqueue() and start all flusher at the same time
Date: Mon, 24 Sep 2012 18:07:02 +0800
Message-Id: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/24 18:05:27,
	Serialize complete at 2012/09/24 18:05:27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core patch is patch6, it makes all flusher can start and the same time
and allow us do more cleanup.

Only patch1 and patch6 change the behavior of the code.
All other patches do not change any behavior.

Lai Jiangshan (10):
  workqueue: always pass flush responsibility to next
  workqueue: remove unneeded check
  workqueue: remove while(true)
  workqueue: use nr_cwqs_to_flush array
  workqueue: add wq_dec_flusher_ref()
  workqueue: start all flusher at the same time
  workqueue: simplify flush_workqueue_prep_cwqs()
  workqueue: assign overflowed flushers's flush color when queued
  workqueue: remove flusher_overflow
  workqueue: remove wq->flush_color

 kernel/workqueue.c |  243 +++++++++++++++++++--------------------------------
 1 files changed, 91 insertions(+), 152 deletions(-)

-- 
1.7.4.4

