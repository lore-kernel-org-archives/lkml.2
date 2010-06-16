Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab0FPML6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 08:11:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:36505 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab0FPML5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 08:11:57 -0400
Message-ID: <4C18BF40.40607@kernel.org>
Date: Wed, 16 Jun 2010 14:10:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org> <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 12:10:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/15/2010 09:43 PM, Daniel Walker wrote:
> I noticed that you removed the RT workqueue since it's no longer used,
> but it's possible that a user can raise the priority of a given work
> queue thread into real time priorities. So with single threaded, and
> multithreaded workqueues specific to certain areas of the kernel the
> user would have a greater ability to control priorities of those areas.
> 
> It looks like with your patches it would remove that level of
> flexability effectively making all the work item the same priority with
> no ability to raise or lower .. Is that accurate ?

Yes, that is.  With new cmwq, a wq can't assume association with
specific kthread and thus can't use wq as simple frontend to kthreads,
but if somebody wants dedicated kthreads instead of shared ones in
units of work, [s]he should be using kthread.

wq does provide nicer tools for synchronization but in general I don't
think using kthread is too hard and there aren't too many cases
anyway.  If there are many users && kthread is difficult to use
directly, we can definitely write up a wrapping layer tho.  But I
really think using wq as wrapper around kthreads and manipulating
worker thread directly is an abusement.

Thanks.

-- 
tejun
