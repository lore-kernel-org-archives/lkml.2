Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab2ISRbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:31:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52963 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab2ISRbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:31:32 -0400
Date: Wed, 19 Sep 2012 10:31:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] workqueue: Keep activate-order equals to
 queue_work()-order
Message-ID: <20120919173128.GJ8474@google.com>
References: <1347957414-6692-1-git-send-email-laijs@cn.fujitsu.com>
 <1347957414-6692-2-git-send-email-laijs@cn.fujitsu.com>
 <20120918170519.GB8474@google.com>
 <505996F8.1020506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505996F8.1020506@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Sep 19, 2012 at 05:57:12PM +0800, Lai Jiangshan wrote:
> (disorder of execution is OK for current WQ. because we can launch new worker
> to execute the next work if the previous one is waiting something)
> 
> But I concern activate-order, not execution order. A non-delayed work
> may delay a delayed work for ever, and if a non-delayed work needs something
> which will be produced by delayed one, the two work may wait each other.
> 
> {
> a subsystem queues a work to release resource.
> and them
> a subsystem queues a work to use the resource.
> }
> Is this behavior acceptable?

Even on workqueues with a rescuer, forward progress is not guaranteed
if there are more than one co-dependent work items.  workqueue doesn't
guarantee anything regarding activation or execution order and any
user which depends on that is broken.

In general, I think it's a bad idea to give that kind of guarantee and
encourage such usages which can lead to extremely subtle breakages
which cannot be detected in any automated way - we don't have any way
to mark dependencies among work items.

Thanks.

-- 
tejun
