Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab0EMVBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:01:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759412Ab0EMVBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:01:46 -0400
Message-ID: <4BEC6883.4090205@redhat.com>
Date: Thu, 13 May 2010 17:00:51 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: perf: relative path to source for perf probe?
References: <AANLkTins2yCK-rvmdaaSQoBum4haHLhPx34EeJDg21Gg@mail.gmail.com>
In-Reply-To: <AANLkTins2yCK-rvmdaaSQoBum4haHLhPx34EeJDg21Gg@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chase Douglas wrote:
> I'm trying to play with perf probe to insert trace events into a
> running kernel, but I haven't found a way to specify relative
> pathnames. For example, our build machines for Ubuntu build the kernel
> inside /build/buildd/linux-2.6.34. If I want to use perf probe, it
> seems I need to ensure the source exists in exactly the same location
> on my machine.

Right, perf-probe currently doesn't support relative *source* path option.
It just uses a source code path information in dwarf. I need to dig it more
into dwarf, especially kernel debuginfo has those information.

That could be a good improvement idea for perf probe (adding -s option?).

> Compare this to gdb, where I can put the source at
> /home/cndougla/perf/build/buildd/linux-2.6.34 and specify a relative
> path for sources of /home/cndougla/perf using the dir command. I have
> read the perf code and I have not found any way to do this. I would be
> interested in adding support for this as a cmd line option, but I'm
> not very familiar with the rest of perf. Is this functionality
> specific to perf-probe? Should this be in some logic in util/ or in
> builtin-probe.c?

Both of it. Adding -s option handling code to builtin-probe.c and
actual path modifying code in show_line_range()@util/probe-event.c.
(I assume you'd like to use -L option)

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
