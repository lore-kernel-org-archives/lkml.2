Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1GLMPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 08:15:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab1GLMPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 08:15:15 -0400
Date: Tue, 12 Jul 2011 08:15:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v2 0/3]CFQ: add think time check for service tree and
 group
Message-ID: <20110712121513.GB1293@redhat.com>
References: <1310434672.15392.283.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310434672.15392.283.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 09:37:52AM +0800, Shaohua Li wrote:
> Hi,
>   Currently when the last queue of a service tree/group is empty, CFQ
> doesn't expire the queue. This is to allow requests from the tree/group
> come soon, so tree/group doesn't miss its share. But if the think time
> is big, the assumption isn't correct. idling the queue is just wasting
> bandwidth.
> 
> Originally I was hoping this can resolve Vivek's fsync issue, but it
> doesn't. The fsync issue is caused by queue idling. But since think time
> check only helps for think time above default queue idle time (8ms),
> think time check doesn't help for the fsync issue.
> 
> On the other hand, think time check is still helpful for queues with
> think time. I had test case in follow patches show throughput
> improvement without sacrifice tree/group shares.
> 
> v1->v2:
> 1. addressed some good comments from Vivek
> 2. add more test to make sure the patches don't change behavior of
> queues without think time.

This patch series looks good to me. Thanks Shaohua. We still shall have
to do something about fsync issue though in groups.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
