Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab1DLSfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:35:46 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52930 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322Ab1DLSfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Ld+GHVVcx4Ra8bBs4XtUgk/2PeXsakoIjVuXhQKaBJlhiTLmxj8ivQS9txqwumKo+N
         QsLHLRw/cWIqv6xO0WlHFRn/xMkMJGbPW8p7pYH1nmo0kwKw9L++ikPeMri2d9F4LHEt
         nZeLn5dDbAX1Y+5Gzm9l47iNBMiBb7eGH0oZE=
Date: Tue, 12 Apr 2011 15:35:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: adding trace-cmd's plugins to perf
Message-ID: <20110412183536.GA20452@ghostprotocols.net>
References: <4DA12905.2020806@gmail.com>
 <20110412162245.GB2240@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412162245.GB2240@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Apr 12, 2011 at 06:22:47PM +0200, Frederic Weisbecker escreveu:
> On Sat, Apr 09, 2011 at 09:50:29PM -0600, David Ahern wrote:
> > Right now perf script cannot process kvm tracepoints:
> > 
> > perf record -e kvm:* -p 6446 -- sleep 5
> > 
> > perf script
> >   Warning: Error: expected type 4 but read 7

> > are about merging common code between the two commands. Also, trace-cmd and perf
> > are in separate repositories so a shared lib is going to inconvenience
> > one of the two.
> 
> So, we copied the tools/perf/util/trace-event-* files from trace-cmd to perf
> a while go. Then both files took their own path, both pulling fixes/enhancement
> from each others (probably more in the trace-cmd -> perf direction).
> 
> And perf is indeed a bit backward wrt parsing, because it lacks those plugins
> for example. So now it would be nice to unify that in a common lib so that it
> works well in both.
> 
> Steve proposed a shared tools/trace.so, that perf and trace-cmd could plug
> into, I really would like to see that happening too.
> 
> I think Ingo had some reserves about this, due to potential versioning
> and compatibility that such a dynamic lib would involve.

So we don't commit to an ABI for a while, just linking with it, changing
users when changing the ABI.

I encourage David to go and add the bits of trace-cmd he needs for
support the plugins he wants used in perf on tools/lib/ and make perf
use it.

That way we again reduce the differences between the codebases, or at least
reduce the feature gap.

- Arnaldo
