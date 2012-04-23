Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2DWK5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:57:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab2DWK5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:57:39 -0400
Date: Mon, 23 Apr 2012 12:57:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        David Ahern <dsahern@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [BUG] perf stat: useless output for raw events with new event
 parser
Message-ID: <20120423105726.GD1720@m.brq.redhat.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 12:45:34PM +0200, Stephane Eranian wrote:
> Hi,
> 
> With the new event parser, one can express raw events field by field:
> 
> $ perf stat -e cpu/event=0x3c,umask=0x0/,cpu/event=0xc5,umask=0x0/ noploop 1
> 
> The problem with this is that the output of perf stat becomes useless:
> 
> $ perf stat -e cpu/event=0x3c,umask=0x0/,cpu/event=0xc5,umask=0x0/ noploop 1
> noploop for 1 seconds
> 
>  Performance counter stats for 'noploop 1':
> 
>         2395038678 pmu
>             10787 pmu
>                        ^^^^^^
>        1.000802603 seconds time elapsed
> 
> We lose the event names or encoding completely. Now for all events
> expressed via this
> new syntax , all we see is 'pmu'. That is pretty useless. It is hard
> to decrypt the results
> without some serious scripting.
> 
> Not sure how to solve this given how the parser works. This looks like
> a regression to me.

I dont think thats regression, since you use new way to express an event.
Please check my answer in the other reply to Peter.

thanks,
jirka
