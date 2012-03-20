Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2CTPyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:54:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59826 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965076Ab2CTPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:54:07 -0400
Date: Tue, 20 Mar 2012 08:53:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] block: remove ioc_*_changed()
Message-ID: <20120320155358.GB5684@google.com>
References: <1332195059-2750-1-git-send-email-tj@kernel.org>
 <20120320155118.GC17071@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320155118.GC17071@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 11:51:18AM -0400, Vivek Goyal wrote:
> So this patch still breaks cic->cfqq association in asynchronous
> manner, when new request comes in. So it will still not solve the
> problem I reported where after doing IO a task changes cgroup and
> tries to delete the old cgroup and hangs forever as cic->cfqq is still
> holding a reference to cgroup?

That one is gonna have to be fixed from cgroup side.  I already posted
a RFC patchset (you were cc'd there, I think).  At the moment, the
blocking thing is memcg's ->pre_destroy() usage.  I'll ping memcg
people once more and if modification there isn't feasible, will
implement a workaround in cgroup core.

Thanks.

-- 
tejun
