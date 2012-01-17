Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2AQVsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:48:41 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38691 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2AQVsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:48:39 -0500
Date: Tue, 17 Jan 2012 13:48:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Kernel crash in icq_free_icq_rcu
Message-ID: <20120117214834.GD26207@google.com>
References: <20120117201823.GD19223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117201823.GD19223@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 03:18:23PM -0500, Vivek Goyal wrote:
> Hi Tejun,
> 
> With latest linus kernel, I see following crash. I was running some
> scripts which create cgroups and launch fio jobs in those groups. In
> a separate window I wrote a script to change the IO scheduler on the
> device in a loop while IO was happening on the device. After few
> seconds I see following. So far I tried it twice and reproduced it
> both the times in first few seconds.

Does the following patch make any difference?

diff --git a/block/elevator.c b/block/elevator.c
index 91e18f8..b5a94ed 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -105,6 +105,7 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (bio_integrity(bio) != blk_integrity_rq(rq))
 		return 0;
 
+	return 0;
 	if (!elv_iosched_allow_merge(rq, bio))
 		return 0;
 
