Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469Ab1FWSJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:09:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886Ab1FWSJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:09:03 -0400
Date: Thu, 23 Jun 2011 14:08:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq-iosched: allow groups preemption for sync-noidle
 workloads
Message-ID: <20110623180854.GE20763@redhat.com>
References: <20110623162159.3192.87699.stgit@localhost6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623162159.3192.87699.stgit@localhost6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 08:21:59PM +0400, Konstantin Khlebnikov wrote:
> commit v2.6.32-102-g8682e1f "blkio: Provide some isolation between groups" break
> fast switching between task and journal-thread for very common write-fsync workload.
> cfq wait idle slice at each cfqq switch, if this task is from non-root blkio cgroup.
> 
> This patch move idling sync-noidle preempting check little bit upwards and update
> new service_tree->count check for case with two different groups.
> I do not quite understand what means these check for new_cfqq, but now it even works.
> 
> Without patch I got 49 iops and with this patch 798, for this trivial fio script:

Which filesystem you are using for these tests?

Vivek
