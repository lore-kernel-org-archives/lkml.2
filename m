Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab0HWJqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:46:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:40458 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0HWJqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:46:03 -0400
Message-ID: <4C72423E.3000402@kernel.org>
Date: Mon, 23 Aug 2010 11:41:18 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] workqueue: mark lock acquisition on worker_maybe_bind_and_lock()
References: <1282486783-4573-2-git-send-email-namhyung@gmail.com>
In-Reply-To: <1282486783-4573-2-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 Aug 2010 09:46:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2010 04:19 PM, Namhyung Kim wrote:
> worker_maybe_bind_and_lock() actually grabs gcwq->lock but was missing proper
> annotation. Add it. So this patch will remove following sparse warnings:
> 
>  kernel/workqueue.c:1214:13: warning: context imbalance in 'worker_maybe_bind_and_lock' - wrong count at exit
>  arch/x86/include/asm/irqflags.h:44:9: warning: context imbalance in 'worker_rebind_fn' - unexpected unlock
>  kernel/workqueue.c:1991:17: warning: context imbalance in 'rescuer_thread' - unexpected unlock
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

applied to wq#for-linus.  Thanks.

Also, please considering putting related patches into a thread.  For
short series, just chaining them is good enough (ie. patch n+1 is
reply to patch n).  For longer series, writing up a head message with
overall description, diffstat and other general info about the patch
series and making all patches reaplies to the head message is a good
idea.

Thanks.

-- 
tejun
