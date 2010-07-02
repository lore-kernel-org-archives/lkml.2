Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab0GBLeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 07:34:44 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46971 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab0GBLem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 07:34:42 -0400
Date: Fri, 2 Jul 2010 16:58:36 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7 2.6.35-rc3-tip 11/11]  perf: perf interface for
 uprobes
Message-ID: <20100702112836.GC20680@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100629183454.32537.63582.sendpatchset@localhost6.localdomain6>
 <20100629183704.32537.28871.sendpatchset@localhost6.localdomain6>
 <4C2C2ECC.5060700@hitachi.com>
 <4C2DCC9D.1020001@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C2DCC9D.1020001@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Masami Hiramatsu wrote:
> > Srikar Dronamraju wrote:
> >> perf: perf interface for uprobes
> >>
> >> Changelog from v4: Merged to 2.6.35-rc3-tip.
> >>
> >> Changelog from v3: (addressed comments from Masami Hiramatsu)
> >> 	* Every process id has a different group name.
> >> 	* event name starts with function name.
> >> 	* If vaddr is specified, event name has vaddr appended
> >> 	  along with function name, (this is to avoid subsequent probes
> >> 	  using same event name.)
> >> 	* warning if -p and --list options are used together.
> >>
> >> 	Also dso can either be a short name or absolute path.
> >>
> >> Enhances perf probe to accept pid and user vaddr.
> >> Provides very basic support for uprobes.
> > 
> > It's unsure what will happen if user sets a probe by line number...
> > I'd like to suggest you if need_dwarf && uid, it should show an error message.
> > But other parts are OK for me.
> 
> I've checked that perf probe was stopped by SEGV in convert_name_to_addr() with
> below options.
> 
> # perf probe -u 2403 hoge.c:100

It should have been perf probe -p 2403 hode.c:100 

However I have taken your comment and fixed that part of the code.
So if it uprobe based probes and need_dwarf is set, it errors out.

> 
> because pp->function == NULL.
> 
> Thank you,
