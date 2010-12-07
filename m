Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab0LGJtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:49:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:44649 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab0LGJtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:49:50 -0500
Message-ID: <4CFE0346.6090904@kernel.org>
Date: Tue, 07 Dec 2010 10:49:58 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 03/10] workqueue: It is likely that WORKER_NOT_RUNNING
 is true
References: <20101207015834.196176991@goodmis.org> <20101207021328.847976021@goodmis.org>
In-Reply-To: <20101207021328.847976021@goodmis.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 09:49:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven.

On 12/07/2010 02:58 AM, Steven Rostedt wrote:
> In worker_thread() we have:
> 
> 	worker_clr_flags(worker, WORKER_PREP);
> 
> 	[ do work stuff ]
> 
> 	worker_set_flags(worker, WORKER_PREP, false);
> 
> (that 'false' means not to wake up an idle worker)
> 
> The wq_worker_sleeping() is called from schedule when a worker thread
> is putting itself to sleep. Which happens most of the time outside
> of that [ do work stuff ].

Yeah, I was lost thinking about the busiest case where workers are
busy processing works consecutively.  Usually workers are of course
switching in and out of idle state all the time.

How about just dropping likely/unlikely?

Thanks.

-- 
tejun
