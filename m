Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab1FIMOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:14:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48480 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab1FIMOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:14:31 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vPU38LsHwLEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=K6KS5I2C0cWZuo8TJn0A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2] trace: Set __GFP_NORETRY flag for ring buffer
 allocating process
From: Steven Rostedt <rostedt@goodmis.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: vnagarnaik@google.com, mingo@redhat.com, fweisbec@gmail.com,
        mrubin@google.com, dhsharp@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <4DF0B097.7010805@jp.fujitsu.com>
References: <1307490088-8612-1-git-send-email-vnagarnaik@google.com>
	 <1307491302-9236-1-git-send-email-vnagarnaik@google.com>
	 <4DF0B097.7010805@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 09 Jun 2011 08:14:28 -0400
Message-ID: <1307621668.9218.37.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 20:37 +0900, KOSAKI Motohiro wrote:

> Unfortunately, __GFP_NORETRY is racy and don't work as expected.
> If free memory is not enough, the thread may start to reclaim and
> another thread can steal the reclaimed memory. And thread0 don't retry.
> 
> Then, thread0's alloc page may fail even though system have enough reclaimable
> memory.
> 
>         thread0                                        thread1
>         ---------------------------------------------------------------
>         alloc_pages()
>            get_page_from_freelist() -> fail
>            try_to_free_pages()
>                                                     alloc_pages()
>                                                        get_page_from_freelist() -> success
>            get_page_from_freelist() -> fail again
> 
> I think this is mm issue, and afaik, Minchan and some developers are
> working on fixing it. but _now_ your patch doesn't work.

Have you seen this fail in practice?

I'm not too concern if it only triggers when memory is tight. But if it
is triggering on normal cases, then that worries me.

Thanks,

-- Steve


