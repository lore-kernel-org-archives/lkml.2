Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2BQRLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:11:22 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37193 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab2BQRLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:11:19 -0500
Date: Fri, 17 Feb 2012 09:11:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] blkcg: drop unnecessary RCU locking
Message-ID: <20120217171113.GB26575@google.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-3-git-send-email-tj@kernel.org>
 <20120217164749.GC26620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217164749.GC26620@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 11:47:49AM -0500, Vivek Goyal wrote:
> So now in some cases we call blkg_lookup_create() with both queue and rcu
> read lock held (cfq_lookup_create_cfqg()) and in this case hold only queue
> lock.

So, this should be okay.  It's currently not because blkg_alloc() is
broken due to percpu allocation but other than that calling both w/
and w/o RCU read lock should be fine.

> blkg_lookup_create() calls blkg_lookup() which expects a rcu_read_lock()
> to be held and we will be travesing that list without rcu_read_lock()
> held. Isn't that a problem?

No, why would it be a problem?

> We might be examining a blkg belonging to a different queue and it
> might be being freed parallely.

How?

Thanks.

-- 
tejun
