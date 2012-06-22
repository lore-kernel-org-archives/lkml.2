Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707Ab2FVUmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 16:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab2FVUmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 16:42:13 -0400
Date: Fri, 22 Jun 2012 16:42:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120622204207.GA22063@redhat.com>
References: <CAKA=qzak6N-6oHVjDozJ6KLMSWXEgzZf1xaC_1cgnoaUCyw8Ag@mail.gmail.com>
 <CAKA=qzaHJ0OcbvtT-mwKBUBvzPkxE4r-bW6gDvicKhoQeyFWEg@mail.gmail.com>
 <20120308234016.GA925@redhat.com>
 <CAKA=qzbsL9UVYLZ3=hoT-1jfp=v=_Sr=h+YeHu0qAA=Ko_7P6w@mail.gmail.com>
 <CAKA=qzbqoK5_3GXM8DZhbQ5cTU=DTg5DFFJ+46OrD7y=XrMLTg@mail.gmail.com>
 <20120621203217.GC14095@redhat.com>
 <CAKA=qzYmh8DD7J__WWDyX_2fFQbSx+M=k4ttqRTD3M8nao-WVg@mail.gmail.com>
 <20120622141211.GB18409@redhat.com>
 <CAKA=qzYYK5KUNsZ1C7Z7BEkqo-7uvn=HYr0N9KLPaLt9ut+MDQ@mail.gmail.com>
 <CAKA=qzY+u64vVZmbiH4zp_Fij2zejQBFUSNENKF=PZBT0G7xrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzY+u64vVZmbiH4zp_Fij2zejQBFUSNENKF=PZBT0G7xrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 03:22:01PM -0500, Josh Hunt wrote:

[..]
> It looks like my statement about busy_queues isn't entirely accurate.
> I'm seeing this later on in the trace:

Yes it is being called some times. But it is interesting to see that in
the instance you pasted in last mail, we did not see "schedule_dispatch"
message.  Are you sure that other requests were queued at that point of
time and there were busy_queues? You can try printing cfqd->rq_queued
to verify that.

Also put some message in cfq_select_queue() to see why it did not select
a new queue before the stall.

Thanks
Vivek
