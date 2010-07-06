Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab0GFA1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:27:13 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46161 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab0GFA1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:27:12 -0400
X-AuditID: b753bd60-a6a3dba000006d9b-51-4c32785cfbd6
Message-ID: <4C327858.809@hitachi.com>
Date: Tue, 06 Jul 2010 09:27:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7 2.6.35-rc3-tip 11/11]  perf: perf interface for uprobes
References: <20100629183454.32537.63582.sendpatchset@localhost6.localdomain6> <20100629183704.32537.28871.sendpatchset@localhost6.localdomain6> <4C2C2ECC.5060700@hitachi.com> <4C2DCC9D.1020001@hitachi.com> <20100702112836.GC20680@linux.vnet.ibm.com>
In-Reply-To: <20100702112836.GC20680@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar Dronamraju wrote:
>> Masami Hiramatsu wrote:
>>> Srikar Dronamraju wrote:
>>>> perf: perf interface for uprobes
>>>>
>>>> Changelog from v4: Merged to 2.6.35-rc3-tip.
>>>>
>>>> Changelog from v3: (addressed comments from Masami Hiramatsu)
>>>> 	* Every process id has a different group name.
>>>> 	* event name starts with function name.
>>>> 	* If vaddr is specified, event name has vaddr appended
>>>> 	  along with function name, (this is to avoid subsequent probes
>>>> 	  using same event name.)
>>>> 	* warning if -p and --list options are used together.
>>>>
>>>> 	Also dso can either be a short name or absolute path.
>>>>
>>>> Enhances perf probe to accept pid and user vaddr.
>>>> Provides very basic support for uprobes.
>>> It's unsure what will happen if user sets a probe by line number...
>>> I'd like to suggest you if need_dwarf && uid, it should show an error message.
>>> But other parts are OK for me.
>> I've checked that perf probe was stopped by SEGV in convert_name_to_addr() with
>> below options.
>>
>> # perf probe -u 2403 hoge.c:100
> 
> It should have been perf probe -p 2403 hode.c:100 
> 
> However I have taken your comment and fixed that part of the code.
> So if it uprobe based probes and need_dwarf is set, it errors out.

Ah, that's great:)

Thank you,

> 
>> because pp->function == NULL.
>>
>> Thank you,

