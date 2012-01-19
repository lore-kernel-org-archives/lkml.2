Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab2ASP6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:58:50 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62386 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2ASP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:58:49 -0500
Date: Thu, 19 Jan 2012 07:58:44 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] blkcg: obtaining blkg should be enclosed inside
 rcu_read_lock()
Message-ID: <20120119155844.GE5198@google.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-2-git-send-email-tj@kernel.org>
 <20120119100729.GA2649@redhat.com>
 <20120119153938.GA5198@google.com>
 <20120119155445.GB10908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119155445.GB10908@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 10:54:45AM -0500, Vivek Goyal wrote:
> > No, no matter whatever synchronization scheme is in use, the code is
> > seriously screwed up if it's doing something like,
> > 
> > 	lock();
> > 	a = lookup();
> > 	unlock();
> > 	return a;
> > 
> > You should *NEVER* be doing that.
> 
> I guess ioc_lookup_icq() is doing something similar. We call it under
> queue lock. Take rcu lock inside for sanity of radix tree and then 
> release rcu lock and return icq.

Yeap, it is.  We should be using rcu_dereference_check() there too.

Thanks.

-- 
tejun
