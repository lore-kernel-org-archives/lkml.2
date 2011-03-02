Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab1CBQRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:17:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab1CBQRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:17:52 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: jaxboe@fusionio.com, vgoyal@redhat.com, czoccolo@gmail.com,
        guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: cfq-iosched preempt issues
References: <20110302124341.GA23940@sli10-conroe.sh.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 02 Mar 2011 11:17:16 -0500
In-Reply-To: <20110302124341.GA23940@sli10-conroe.sh.intel.com> (Shaohua Li's
	message of "Wed, 2 Mar 2011 20:43:41 +0800")
Message-ID: <x49wrkh33ar.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> queue preemption is good for some workloads and not for others. With commit
> f8ae6e3eb825, the impact is amplified. I currently have two issues with it:
> 1. In a multi-threaded workload, each thread runs a random read/write (for
> example, mmap write) with iodepth 1. I found the queue depth gets smaller
> with commit f8ae6e3eb825. The reason is write gets preempted, so more threads
> are waitting for write, and on the other hand, there are less threads doing
> read. This will make the queue depth small, so performance drops a little.
> So in this case, speed up write can speed up read too, but we can't detect
> it.

I don't fully understand your workload.  What is the aio-stress or fio
command line/config file?

> 2. cfq_may_dispatch doesn't limit queue depth if the queue is the sole queue.
> What about if there are two queues, one sync and one async? If the sync queue's
> think time is small, we can treat it as the sole queue, because the sync queue
> will preempt async queue, so we don't need care about the async queue's latency.
> The issue exists before, but f8ae6e3eb825 amplifies it. Below is a patch for it.

I'm not sure I entirely agree with that reasoning.  Do you have real
workloads that are regressing due to this commit, or is it just these
cooked up benchmarks?

Cheers,
Jeff
