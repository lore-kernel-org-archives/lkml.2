Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2DWKtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:49:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:50588 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2DWKtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:49:06 -0400
Message-ID: <1335178132.28150.117.camel@twins>
Subject: Re: [BUG] perf stat: useless output for raw events with new event
 parser
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        David Ahern <dsahern@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Mon, 23 Apr 2012 12:48:52 +0200
In-Reply-To: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 12:45 +0200, Stephane Eranian wrote:
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

Yeah, I already complained about that.. Jolsa proposed adding a name=
parameter so you could explicitly name your events. I think I've seen a
patch adding that, but can't atm seem to locate it.

Jiri?
