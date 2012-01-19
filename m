Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2ASLMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:12:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab2ASLL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:11:59 -0500
Date: Thu, 19 Jan 2012 06:11:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] elevator: make elevator_init_fn() return 0/-errno
Message-ID: <20120119111151.GC2649@redhat.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326935490-11827-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 05:11:22PM -0800, Tejun Heo wrote:
> elevator_ops->elevator_init_fn() has a weird return value.  It returns
> a void * which the caller should assign to q->elevator->elevator_data
> and %NULL return denotes init failure.
> 
> Update such that it returns integer 0/-errno and sets elevator_data
> directly as necessary.
> 

kmalloc() does the same thing. returning pointer means success and null
means failure.

Also elevator initialization might not necessarily mean that you are
the active elevator. So cfq_init_queue() assuming that I am the active
elevator and setting up q->elevator->elevator_data sounds odd to me.

Personally, I liked previous interface better. But, let me read rest of
the patches and see how you have made use of it to do more cleanup.

Thanks
Vivek
