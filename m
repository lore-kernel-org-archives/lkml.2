Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab1DLQWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:22:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32871 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab1DLQWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:22:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p1Gm8jQf373YPfr6u1oTsqi5Kv4ad1EsTjcy1MMOyli8z3u4VnByeIYUlbi7xdXbu+
         5Bifa0DdK8knHhacLXXxXWPoAe+CZ8LSIpBy2aSQ2/5heUXgbE4kK1Zg+Ee/ihwLbTlO
         qJIH/pDztWlwxHBLd+8zlcixIVyDyKJ1XO0CU=
Date: Tue, 12 Apr 2011 18:22:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: adding trace-cmd's plugins to perf
Message-ID: <20110412162245.GB2240@nowhere>
References: <4DA12905.2020806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA12905.2020806@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 09, 2011 at 09:50:29PM -0600, David Ahern wrote:
> Right now perf script cannot process kvm tracepoints:
> 
> perf record -e kvm:* -p 6446 -- sleep 5
> 
> perf script
>   Warning: Error: expected type 4 but read 7
>   Warning: Error: expected type 5 but read 0
>   Warning: failed to read event print fmt for kvm_apic
>   Warning: Error: expected type 4 but read 7
>   Warning: Error: expected type 5 but read 0
>   Warning: failed to read event print fmt for kvm_inj_exception
>   Fatal: bad op token {
> 
> trace-cmd can parse the events through the kvm plugin.
> 
> As I understand it trace-cmd and perf have a lot of similar code, so I
> would expect to be able to add the plugin capability to perf somewhat
> easily. However, that does not seem to be the right thing to do (copying
> yet more code between the two).
> 
> Before I invest a lot of time on this path I figured I should ask what
> the intentions (roadmap seems to be too formal a word ;-))

Hehe :)

> are about merging common code between the two commands. Also, trace-cmd and perf
> are in separate repositories so a shared lib is going to inconvenience
> one of the two.

So, we copied the tools/perf/util/trace-event-* files from trace-cmd to perf
a while go. Then both files took their own path, both pulling fixes/enhancement
from each others (probably more in the trace-cmd -> perf direction).

And perf is indeed a bit backward wrt parsing, because it lacks those plugins
for example. So now it would be nice to unify that in a common lib so that it
works well in both.

Steve proposed a shared tools/trace.so, that perf and trace-cmd could plug
into, I really would like to see that happening too.

I think Ingo had some reserves about this, due to potential versioning
and compatibility that such a dynamic lib would involve.

However, this seems to me a very important and necessary step to unify our
tools.
