Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652Ab2CTQAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:00:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab2CTQAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:00:52 -0400
Date: Tue, 20 Mar 2012 12:00:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] block: remove ioc_*_changed()
Message-ID: <20120320160043.GD17071@redhat.com>
References: <1332195059-2750-1-git-send-email-tj@kernel.org>
 <20120320155118.GC17071@redhat.com>
 <20120320155358.GB5684@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320155358.GB5684@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 08:53:58AM -0700, Tejun Heo wrote:
> On Tue, Mar 20, 2012 at 11:51:18AM -0400, Vivek Goyal wrote:
> > So this patch still breaks cic->cfqq association in asynchronous
> > manner, when new request comes in. So it will still not solve the
> > problem I reported where after doing IO a task changes cgroup and
> > tries to delete the old cgroup and hangs forever as cic->cfqq is still
> > holding a reference to cgroup?
> 
> That one is gonna have to be fixed from cgroup side.  I already posted
> a RFC patchset (you were cc'd there, I think).  At the moment, the
> blocking thing is memcg's ->pre_destroy() usage.  I'll ping memcg
> people once more and if modification there isn't feasible, will
> implement a workaround in cgroup core.

Ok, now I remember that patchset. So the idea is to delete the cgroup and
drop the creation reference. Internal blkcg object might still be around
and will freed when all the references are gone. Makes sense. Thanks.

Vivek
