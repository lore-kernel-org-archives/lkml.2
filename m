Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab0GWKQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:16:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab0GWKQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:16:18 -0400
Subject: Re: [PATCH 5/7] gfs2: use workqueue instead of slow-work
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, airlied@linux.ie, dri-devel@lists.freedesktop.org
In-Reply-To: <1279658102-20069-6-git-send-email-tj@kernel.org>
References: <1279658102-20069-1-git-send-email-tj@kernel.org>
	 <1279658102-20069-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 23 Jul 2010 11:20:57 +0100
Message-ID: <1279880457.2465.15.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2010-07-20 at 22:35 +0200, Tejun Heo wrote:
> Workqueue can now handle high concurrency.  Convert gfs to use
> workqueue instead of slow-work.
> 
> * Steven pointed out that recovery path might be run from allocation
>   path and thus requires forward progress guarantee without memory
>   allocation.  Create and use gfs_recovery_wq with rescuer.  Please
>   note that forward progress wasn't guaranteed with slow-work.
> 
> * Updated to use non-reentrant workqueue.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

I'm assuming that you'll push this along with the workqueue changes?
Probably easier than pushing it through my tree,

Steve.


