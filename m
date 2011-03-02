Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1CBVFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:05:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab1CBVFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:05:38 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>, jaxboe@fusionio.com, czoccolo@gmail.com,
        guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: cfq-iosched preempt issues
References: <20110302124341.GA23940@sli10-conroe.sh.intel.com>
	<20110302202118.GA2547@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 02 Mar 2011 16:05:30 -0500
In-Reply-To: <20110302202118.GA2547@redhat.com> (Vivek Goyal's message of
	"Wed, 2 Mar 2011 15:21:18 -0500")
Message-ID: <x49bp1t2pyd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Mar 02, 2011 at 08:43:41PM +0800, Shaohua Li wrote:
>> queue preemption is good for some workloads and not for others. With commit
>> f8ae6e3eb825, the impact is amplified. I currently have two issues with it:
>> 1. In a multi-threaded workload, each thread runs a random read/write (for
>> example, mmap write) with iodepth 1. I found the queue depth gets smaller
>> with commit f8ae6e3eb825. The reason is write gets preempted, so more threads
>> are waitting for write, and on the other hand, there are less threads doing
>> read. This will make the queue depth small, so performance drops a little.
>> So in this case, speed up write can speed up read too, but we can't detect
>> it.
>> 2. cfq_may_dispatch doesn't limit queue depth if the queue is the sole queue.
>> What about if there are two queues, one sync and one async? If the sync queue's
>> think time is small, we can treat it as the sole queue, because the sync queue
>> will preempt async queue, so we don't need care about the async queue's latency.
>> The issue exists before, but f8ae6e3eb825 amplifies it. Below is a patch for it.
>> 
>> Any idea?
>
> CFQ is already very complicated, lets try to keep it simple. Because it
> is complicated, making it hierarchical for cgroup becomes even harder.
>
> IIUC, you are saying that cfqd->busy_queues check is not sufficient as
> it takes async queues also in account.
>
> So we can keep another count say, cfqd->busy_sync_queues and if there
> are no busy_sync_queues, allow unlimited depth and that should be
> a really simple few lines change.

That covers workload 2, but what about 1?  I'm really not sure what the
workload there is.

Cheers,
Jeff
