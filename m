Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0GLN0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 09:26:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:58355 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0GLN0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 09:26:06 -0400
Date: Mon, 12 Jul 2010 21:23:47 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
        oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH] workqueue: fix locking in retry path of
 maybe_create_worker()
Message-ID: <20100712132347.GA19305@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
 <1277759063-24607-28-git-send-email-tj@kernel.org>
 <20100709091138.GA7304@windriver.com>
 <4C3AD7FE.2050702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4C3AD7FE.2050702@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 12 Jul 2010 13:23:49.0624 (UTC) FILETIME=[76D69780:01CB21C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 10:53:18AM +0200, Tejun Heo wrote:
> maybe_create_worker() mismanaged locking when worker creation fails
> and it has to retry.  Fix locking and simplify lock manipulation.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Yong Zhang <yong.zhang@windriver.com>
> ---
> Heh, that was stupid.  Thanks a lot for spotting it.  I simplified
> things a bit there as there's no reason to repeatedly lock and unlock
> there.  Does this look good to you?

Yeah, this is better.

Thanks,
Yong
