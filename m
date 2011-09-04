Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1IDDFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 23:05:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:58851 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab1IDDFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 23:05:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,326,1312182000"; 
   d="scan'208";a="45382843"
Date: Sun, 4 Sep 2011 11:05:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jaxboe@fusionio.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm: Add comment explaining task state setting in
 bdi_forker_thread()
Message-ID: <20110904030551.GB16361@localhost>
References: <1315004059-9844-1-git-send-email-jack@suse.cz>
 <1315004059-9844-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315004059-9844-3-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -401,6 +401,13 @@ static int bdi_forker_thread(void *ptr)
>  		}
>  
>  		spin_lock_bh(&bdi_lock);
> +		/*
> +		 * In the following loop we are going to check whether we have
> +		 * some work to do without any synchronization with tasks
> +		 * waking us up to do work for them. So we have to set task
> +		 * state already here so that we don't miss wakeups coming

s/already/early/ ?

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

> +		 * after we verify some condition.
> +		 */
>  		set_current_state(TASK_INTERRUPTIBLE);
>  
>  		list_for_each_entry(bdi, &bdi_list, bdi_list) {
> -- 
> 1.7.1
