Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab2IFQvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:51:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64677 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884Ab2IFQvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:51:50 -0400
Date: Thu, 6 Sep 2012 09:51:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11 V5] workqueue: Add @bind arguement back without
 change any thing
Message-ID: <20120906165145.GE29092@google.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
 <1346841475-4422-6-git-send-email-laijs@cn.fujitsu.com>
 <20120905194908.GC13737@google.com>
 <5047F686.5010207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5047F686.5010207@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Thu, Sep 06, 2012 at 09:04:06AM +0800, Lai Jiangshan wrote:
> > This doesn't change anything.  You're just moving the test to the
> > caller with comments there explaining how it won't change even if
> > gcwq->lock is released.  It seems more confusing to me.  The flag is
> > still protected by manager_mutex.  How is this an improvement?
> > 
> 
> Some other bit of gcwq->flags is accessed(modified) without manager_mutex.
> making gcwq->flags be accessed only form gcwq->lock C.S. will help the reviewer.
> 
> I don't like adding special things/code when not-absolutely-required.

I really fail to see this.  The flag has to stay stable while
manage_mutex is held no matter where you test it.  It doesn't make any
it any more readable whether you test it inside gcwq->lock with the
comment saying "this won't change while manager_mutex is held" or just
test it while manager_mutex is held.  It is a synchronization oddity
no matter what and as long as it's well documented, I don't really see
the point in the change.

Thanks.

-- 
tejun
