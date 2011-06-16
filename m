Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1FPF75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 01:59:57 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44620 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab1FPF74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 01:59:56 -0400
X-AuditID: b753bd60-a0ac3ba000003bac-59-4df99bd9805e
X-AuditID: b753bd60-a0ac3ba000003bac-59-4df99bd9805e
Message-ID: <4DF99BD6.8000705@hitachi.com>
Date: Thu, 16 Jun 2011 14:59:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 20/22] 20: perf: perf interface for uprobes
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6> <20110607130216.28590.5724.sendpatchset@localhost6.localdomain6> <4DF20511.8000206@hitachi.com> <20110613084133.GA27130@linux.vnet.ibm.com> <4DF6FFD1.1080203@hitachi.com> <20110614115652.GA4952@linux.vnet.ibm.com>
In-Reply-To: <20110614115652.GA4952@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/14 20:56), Srikar Dronamraju wrote:
>>>> I think -u option should have a path of the target binary, as below
>>>>
>>>> # perf probe -u /bin/zsh -a zfree
>>>
>>> Will --uprobe work as the long name option for -u or do you suggest
>>> something else?
>>
>> Hmm, good question. Maybe we can use -x|--exec to define a uprobe event,
>> because there is no need to give an executable file for kprobes events.
>> # so that -x implies user space event on given execfile
>>
> 
> Okay, then lets stick with perf probe -x executable <function-name>
> then.

Thanks:-)

>> However, Maybe we'd better look this more carefully. Here, we have
>> a problem with listing userspace probes (I mean how perf probe can
>> list up the probes which is on a user app)
>>
>> Currently, it just ignores module name if a probe on a module.
>>   probe:fuse_do_open   (on fuse_do_open@ksrc/linux-2.6/fs/fuse/file.c with isdir)
>>
>> One possible solution is to show the module name right before the
>> symbol as same as the kernel does.
>>
>>   probe:fuse_do_open   (on fuse:fuse_do_open@ksrc/linux-2.6/fs/fuse/file.c with
>> isdir)
> 
> This looks better to me.

OK, this will be good for starting point. If someone complains,
we can switch to below format.

>> Another way is to show it more verbosely, like below.
>>
>>   probe:fuse_do_open   (at fuse_do_open@ksrc/linux-2.6/fs/fuse/file.c with isdir
>> on fuse)
>>   probe_zsh:zfree      (at 0x45400 on /bin/zsh)
>>
> 
> But I am okay with changing to this format too.
> 

Thanks!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
