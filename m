Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab2FVOQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:16:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966Ab2FVOQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:16:02 -0400
Date: Fri, 22 Jun 2012 10:15:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Rakesh Iyer <rni@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josh Hunt <joshhunt00@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Chad Talbott <ctalbott@google.com>
Subject: Re: multi-second application stall in open()
Message-ID: <20120622141556.GC18409@redhat.com>
References: <CAKA=qzak6N-6oHVjDozJ6KLMSWXEgzZf1xaC_1cgnoaUCyw8Ag@mail.gmail.com>
 <CAKA=qzaHJ0OcbvtT-mwKBUBvzPkxE4r-bW6gDvicKhoQeyFWEg@mail.gmail.com>
 <20120308234016.GA925@redhat.com>
 <CAKA=qzbsL9UVYLZ3=hoT-1jfp=v=_Sr=h+YeHu0qAA=Ko_7P6w@mail.gmail.com>
 <CAKA=qzbqoK5_3GXM8DZhbQ5cTU=DTg5DFFJ+46OrD7y=XrMLTg@mail.gmail.com>
 <20120621203217.GC14095@redhat.com>
 <20120621203615.GE4642@google.com>
 <CAKA=qzaFRubzvyjJQzgThRLsxLDc8NMdZy6WVZMFrF7ohsyjHw@mail.gmail.com>
 <20120621213235.GF4642@google.com>
 <CAOT6A4-a49wLHcQepUxJCDxOxfnSTEWa72OweLsmrea85OyrCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOT6A4-a49wLHcQepUxJCDxOxfnSTEWa72OweLsmrea85OyrCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 02:45:56PM -0700, Rakesh Iyer wrote:
> Hello,
> 
> I coded up the watchdog and dropped it in but never did get the time to go
> looking for evidence of stalls so no confirmed evidence of what the cause
> was.
> 
> Chad and I did manage to stare at the code long and hard and sort of
> convince ourselves that cfq_cfqq_wait_busy & associated logic could be the
> cause of the stall (strictly in my opinion - that logic can be fully be
> fully folded into the idling logic, but that's a discussion for another
> day).

Rakesh, so in your watchdog code you just kicked the queue? I am wondering
how does that help. In the sense, that we did do cfq_schedule_dispatch
here which will run the queue and CFQ did not find any pending requests to dispatch. So even if we kick the queue later, CFQ will not find any requests to
dispatch until and unless something changes in the mean time.

So I am not sure if it is same issue as you were facing.

Thanks
Vivek
