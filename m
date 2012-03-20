Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671Ab2CTPvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:51:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab2CTPvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:51:24 -0400
Date: Tue, 20 Mar 2012 11:51:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] block: remove ioc_*_changed()
Message-ID: <20120320155118.GC17071@redhat.com>
References: <1332195059-2750-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332195059-2750-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 03:10:55PM -0700, Tejun Heo wrote:
> Hello, guys.
> 
> The changed notification used by cfq is rather odd.  cfq caches the
> associated cfqqs per cic and uses the changed notification to expire
> those lookup caches.
> 
> The explicit notification mechanism might make sense if determining
> whether the current cache is up-to-date is difficult or expensive;
> however, that isn't the case here.  Determining whether ioprio or
> cgroup has changed is straight-forward and inexpensive.
> 
> This patchset updates cfq to so that it remembers the current ioprio
> and blkcg in the cic and determines whether cfqq's need to be reset
> without using the changed notification and drops the changed
> notification code.

Hi Tejun,

So this patch still breaks cic->cfqq association in asynchronous
manner, when new request comes in. So it will still not solve the
problem I reported where after doing IO a task changes cgroup and
tries to delete the old cgroup and hangs forever as cic->cfqq is still
holding a reference to cgroup?

Thanks
Vivek
