Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab0GFArt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:47:49 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35102 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0GFArs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:47:48 -0400
X-AuditID: b753bd60-a8840ba000006d9b-14-4c327d3108f4
Message-ID: <4C327D2F.4040807@hitachi.com>
Date: Tue, 06 Jul 2010 09:47:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Chase Douglas <chase.douglas@canonical.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -tip 0/4] perf-probe updates: string support, etc.
References: <20100519195717.2885.90799.stgit@localhost6.localdomain6> <56FC4434-EA6C-4A0C-A95B-3D7BE818774B@canonical.com> <20100705174450.GB23506@ghostprotocols.net>
In-Reply-To: <20100705174450.GB23506@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 05, 2010 at 10:30:47AM -0400, Chase Douglas escreveu:
>> On May 19, 2010, at 3:57 PM, Masami Hiramatsu wrote:
>>> Hi,
>>>
>>> Here is a series of patches which improves perf probe to
>>> add below features. I cleared some coding style issues.
>>>
>>> - String support, which enables dynamic events to trace string
>>>  variables instead of its address.
>>>
>>> - Fixed-index array entry support, which allows user to trace
>>>  an array entry with digit index, e.g. array[0].
>>>
>>> - Global/static variable support, which allows user to trace
>>>  global or static variables, as same as local one.
>>>
>>>
>>> TODOs (possible features):
>>>  - Support dynamic array-indexing (var[var2])
>>>  - Support force type-casting ((type)var)
>>>  - Show what deta-structure member is assigned to each argument.
>>>  - Better support for probes on modules
>>>  - More debugger like enhancements(%next, --disasm, etc.)
>>>
>>> Thank you,
>>>
>>> ---
>>>
>>> Masami Hiramatsu (4):
>>>      perf probe: Support static and global variables
>>>      perf probe: Support tracing an entry of array
>>>      perf probe: Support "string" type
>>>      tracing/kprobes: Support "string" type
>> What's the status of these patches? They seem very useful to me, but I
>> don't see them in Arnaldo's tree at git.kernel.org.
> 
> Thanks for reminding me about these ones, will look at them to get them
> in perf/core.

Thanks for picking it up. And I need to tell it to Sriker because this
will affect his uprobes patchset (ftrace part).
(Actually, my original plan was to update the patchset onto
 his uprobes patchset.)

Sriker, the 1st patch in this series will add many macros/functions
into trace_kprobe.c. This will directly affect your 8th patch of uprobes,
which splits fetch functions out from trace_kprobe.c.
Is that OK for you?

Thank you,

-- 
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
