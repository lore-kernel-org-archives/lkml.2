Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab2BQSQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:16:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50813 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab2BQSQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:16:39 -0500
Date: Fri, 17 Feb 2012 10:16:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] blkcg: drop unnecessary RCU locking
Message-ID: <20120217181634.GD29414@google.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-3-git-send-email-tj@kernel.org>
 <20120217164749.GC26620@redhat.com>
 <20120217171113.GB26575@google.com>
 <20120217172857.GD26620@redhat.com>
 <20120217174304.GC29414@google.com>
 <20120217180800.GE26620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217180800.GE26620@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 01:08:00PM -0500, Vivek Goyal wrote:
> > Modifying blkgs require both blkcg and queue locks,
> > so read access can be done holding any lock.
> 
> This is the point I am not getting. How blkg_lookup() is safe just
> under queue lock. What stops freeing up blkg associated with other
> queues. I thought caller needs to hold rcu_read_lock() also to
> make sure it can safely compare blkg->q == q and return the blkg
> belonging to the queue in question.

Ooh, you're right.  I got confused.  We should be holding either blkcg
lock or rcu_read_lock() across blkg_lookup().  Will update.

Thanks.

-- 
tejun
