Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1FITws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:52:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab1FITwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:52:45 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vPU38LsHwLEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pbyijn5QWa-fUyiTCW8A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2] trace: Set __GFP_NORETRY flag for ring buffer
 allocating process
From: Steven Rostedt <rostedt@goodmis.org>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, vnagarnaik@google.com,
        mingo@redhat.com, fweisbec@gmail.com, mrubin@google.com,
        dhsharp@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1106091237580.11607@chino.kir.corp.google.com>
References: <1307490088-8612-1-git-send-email-vnagarnaik@google.com>
	 <1307491302-9236-1-git-send-email-vnagarnaik@google.com>
	 <4DF0B097.7010805@jp.fujitsu.com>
	 <1307621668.9218.37.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1106091237580.11607@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 09 Jun 2011 15:52:42 -0400
Message-ID: <1307649162.9218.41.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 12:42 -0700, David Rientjes wrote:

> It would only happen if there was an antagonist that stole the reclaimed 
> pages before your __GFP_NORETRY allocation could allocate them, resulting 
> in the system being oom again as it was before reclaim occurred.  Without 
> __GFP_NORETRY, we'd automatically retry these allocations in a loop until 
> we found the memory since they are order-0, so the only side effect would 
> be an increased latency in the allocation.  I think if we still end up oom 
> after reclaiming memory that was allocated by another thread that we 
> probably don't want to be expanding the ring buffer and, thus, I see no 
> problem with just failing.

Agreed, which is why I already pushed the patch.

-- Steve


