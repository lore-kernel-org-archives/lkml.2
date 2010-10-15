Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0JONyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:54:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:35721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702Ab0JONyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:54:04 -0400
Message-ID: <4CB85CF0.1040900@kernel.org>
Date: Fri, 15 Oct 2010 15:53:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] oprofile: don't use flush_scheduled_work()
References: <4CB85C4C.6080806@kernel.org>
In-Reply-To: <4CB85C4C.6080806@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 13:53:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2010 03:51 PM, Tejun Heo wrote:
> flush_scheduled_work() is deprecated and scheduled to be removed.
> sync_stop() currently cancels cpu_buffer works inside buffer_mutex and
> flushes the system workqueue outside.  Instead, split end_cpu_work()
> into two parts - stopping further work enqueues and flushing works -
> and do the former inside buffer_mutex and latter outside.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Ooh, BTW, the global symbols in cpu_buffer seem a bit too generic.  I
don't think oprofile should be defining alloc/free_cpu_buffers() and
start/end/flush_cpu_work().  Maybe it would be a good idea to add op_
prefix to them?

Thanks.

-- 
tejun
