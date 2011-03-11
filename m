Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab1CKDhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 22:37:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1CKDhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 22:37:24 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=VOOo5lHdzEUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Bn5KwNPcwBRWlNj5CmMA:9 a=Rsnjs4hIOn_U9iu9v4sA:7 a=XceaCiYZv_rpBZwn8heRVumpSrQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 04/15] ftrace: pack event structures.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        mrubin@google.com
In-Reply-To: <AANLkTikKYaxLi-3a-0bdsbQR3scFzhn0txktNd+QPVa3@mail.gmail.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-5-git-send-email-dhsharp@google.com>
	 <1299627003.20306.94.camel@gandalf.stny.rr.com>
	 <20110308.223951.193722389.davem@davemloft.net>
	 <1299683884.15854.154.camel@gandalf.stny.rr.com>
	 <AANLkTikKYaxLi-3a-0bdsbQR3scFzhn0txktNd+QPVa3@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 22:37:22 -0500
Message-ID: <1299814642.15854.994.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 15:21 -0800, David Sharp wrote:

> Yes, I think that should have the same effect. Of course the next time
> we come along and remove other useless fields like 'flags' and
> 'preempt_count', a similar condition could arise.
> 
> (Note I don't necessarily think that 'flags' and 'preempt_count' are
> useless; although I don't know what they're used for, or why they need
> to be in every entry. fwiw, we've taken trace_entry down to 4 bytes of
> {unsigned short type; unsigned short pid;}, and we even have plans to
> completely remove pid.)

The flags and preempt count are legacy from the latency-tracer. But they
do come in quite handy when debugging -rt code. I've gotten trace data
from customers that knowing if preemption is enabled or disable and
whether or not something happened in interrupt context was detrimental.

That said, I would love to figure out a nice way to make these optional.

-- Steve


