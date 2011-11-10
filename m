Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1KJWCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 17:02:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59059 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab1KJWCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 17:02:08 -0500
MIME-Version: 1.0
X-Originating-IP: [197.177.249.200]
In-Reply-To: <20111020130041.GB1772@ghostprotocols.net>
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
 <20111019183848.GE2229@ghostprotocols.net> <4E9F1AA0.4010706@gmail.com>
 <20111019192011.GG2229@ghostprotocols.net> <4E9F4B50.1060207@gmail.com> <20111020130041.GB1772@ghostprotocols.net>
From: Brian Marete <marete@toshnix.com>
Date: Fri, 11 Nov 2011 01:01:47 +0300
Message-ID: <CAHVUoiSwem2r9J==gmHPfst3_0ZB5bd0ykf9cPUMdhZFaXC9EA@mail.gmail.com>
Subject: Re: [PATCH] perf top: fix crash on annotate request
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 20, 2011 at 4:00 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> I.e. the map_ip for this method is messing up things, what symbol is
> this? I.e. please provide:
>
> p *sym
> p *map

I have am experiencing the same segfault using perf from the latest
linus' tree. The gdb backtrace is below. Which patch fixes it? Or is
it already fixed in some git tree on kernel.org?

Thanks

Program received signal SIGSEGV, Segmentation fault.
0x000000000042e27e in symbol__inc_addr_samples (sym=0x1279e70, map=0x9677a0,
    evidx=0, addr=256544) at util/annotate.c:73
73		h->addr[offset]++;
#0  0x000000000042e27e in symbol__inc_addr_samples (sym=0x1279e70, map=
    0x9677a0, evidx=0, addr=256544) at util/annotate.c:73
#1  0x00000000004215e4 in record_precise_ip (he=0x1e7b260, counter=0,
    ip=256544) at builtin-top.c:223
#2  0x0000000000422ba1 in perf_event__process_sample (event=0x7ffff7ec4c60,
    evsel=0x837a10, sample=0x7fffffffe340, session=0x837e80)
    at builtin-top.c:801
#3  0x0000000000422c8c in perf_session__mmap_read_idx (self=0x837e80, idx=1)
    at builtin-top.c:825
#4  0x0000000000422d43 in perf_session__mmap_read (self=0x837e80)
    at builtin-top.c:839
#5  0x0000000000423295 in __cmd_top () at builtin-top.c:1003
#6  0x0000000000423940 in cmd_top (argc=0, argv=0x7fffffffe720, prefix=0x0)
    at builtin-top.c:1274
#7  0x000000000040ffdc in run_builtin (p=0x6a4bc8, argc=1, argv=0x7fffffffe720)
    at perf.c:286
#8  0x00000000004101af in handle_internal_command (argc=1, argv=0x7fffffffe720)
    at perf.c:358
#9  0x00000000004102b5 in run_argv (argcp=0x7fffffffe60c, argv=0x7fffffffe600)
    at perf.c:402
#10 0x00000000004104f8 in main (argc=1, argv=0x7fffffffe720) at perf.c:512

# Output of p *sym
$1 = {rb_node = {rb_parent_color = 19423281, rb_right = 0x0, rb_left = 0x0},
  start = 1124896, end = 1126163, namelen = 16, binding = 0 '\000',
  ignore = false, name = 0x1279e70 "1`(\001"}

# Output of p *map
$2 = {{rb_node = {rb_parent_color = 9861408, rb_right = 0x967860, rb_left =
    0x9676e0}, node = {next = 0x967920, prev = 0x967860}}, start = 4142972928,
  end = 4144365568, type = 0 '\000', referenced = true, priv = 0, pgoff = 0,
  map_ip = 0x44fc69 <map__map_ip>, unmap_ip = 0x44fc92 <map__unmap_ip>, dso =
    0x8e5490, groups = 0x964cd8}

--
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590
