Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910Ab0GVUsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:48:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:58327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759758Ab0GVUpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:45:21 -0400
Message-ID: <4C48ADCE.3050707@kernel.org>
Date: Thu, 22 Jul 2010 22:45:02 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, swhiteho@redhat.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 5/7] gfs2: use workqueue instead of slow-work
References: <1279658102-20069-1-git-send-email-tj@kernel.org> <1279658102-20069-6-git-send-email-tj@kernel.org>
In-Reply-To: <1279658102-20069-6-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Jul 2010 20:45:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 10:35 PM, Tejun Heo wrote:
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

Steven, can you please review the change?

Thanks.

-- 
tejun
