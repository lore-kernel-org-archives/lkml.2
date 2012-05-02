Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2EBLOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 07:14:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50434 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2EBLOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 07:14:34 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
Date: Wed, 2 May 2012 13:14:33 +0200
Message-ID: <CABPqkBThAMr2p+9fzYboJsZCwP9hwpD5UZ8Y2tJkZOMG4Odvrg@mail.gmail.com>
Subject: Re: [BUG] perf stat: useless output for raw events with new event parser
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        David Ahern <dsahern@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I will try to experiment with: cpu/event=INST_RETIRED:ANY:c=1/
But for now with libpfm4 as it is. Then will try to come up with an
external file format that encapsulates what I already have in the
C-table. There is more than just what the hardware exports. You
have to encode certain constraints, e.g., how umasks can be
combined. I don't even use the same format for all arch. On
X86 the AMD and Intel formats are different.


On Mon, Apr 23, 2012 at 12:45 PM, Stephane Eranian <eranian@google.com> wrote:
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
>  Performance counter stats for 'noploop 1':
>
>        2395038678 pmu
>            10787 pmu
>                       ^^^^^^
>       1.000802603 seconds time elapsed
>
> We lose the event names or encoding completely. Now for all events
> expressed via this
> new syntax , all we see is 'pmu'. That is pretty useless. It is hard
> to decrypt the results
> without some serious scripting.
>
> Not sure how to solve this given how the parser works. This looks like
> a regression to me.
