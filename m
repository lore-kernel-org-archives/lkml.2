Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab2BNDIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:08:18 -0500
Received: from plane.gmane.org ([80.91.229.3]:50410 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab2BNDIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:08:15 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Date: Tue, 14 Feb 2012 12:07:57 +0900
Message-ID: <4F39D00D.2060206@gmail.com>
References: <1329184375-27911-1-git-send-email-acme@infradead.org> <4F39CBE0.6050806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Lin Ming <ming.m.lin@intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Roberto Agostino Vitillo <ravitillo@lbl.gov>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vweaver1@eecs.utk.edu>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
X-Gmane-NNTP-Posting-Host: 121.50.20.41
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
In-Reply-To: <4F39CBE0.6050806@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-02-14 오전 11:50, Namhyung Kim 쓴 글:
> Hello,
> 
> 2012-02-14 10:52 AM, Arnaldo Carvalho de Melo wrote:
>> The following changes since commit c98fdeaa92731308ed80386261fa2589addefa47:
>>
>> x86/sched/perf/AMD: Set sched_clock_stable (2012-02-07 13:12:08 +0100)
>>
>> are available in the git repository at:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-core-for-mingo
>>
>> for you to fetch changes up to 7e1ccd3804281fc0755eb726b654469c40a96d89:
>>
>> perf tools: cleanup initialization of attr->size (2012-02-13 23:35:04 -0200)
>>
>> ----------------------------------------------------------------
>> perf/core fixes and improvements.
>>
>> Signed-off-by: Arnaldo Carvalho de Melo<acme@redhat.com>
>>
> 
> I've got a following error during a simple test:
> 
> $ ./perf record -- sleep 1
> 
> Error: sys_perf_event_open() syscall returned with 22 (Invalid argument).
> /bin/dmesg may provide additional information.
> 
> Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> sleep: Terminated
> 
> 
> Any thoughts?
> 
> Thanks,
> Namhyung
> 

git bisect told me:

c4a7dca92bbb9881a5d678720f1d0c2153499749 is the first bad commit
commit c4a7dca92bbb9881a5d678720f1d0c2153499749
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Fri Feb 10 18:05:05 2012 +0100

    perf tools: Change perf_guest default back to false

    Setting perf_guest to true by default makes no sense because the perf
    subcommands can not setup guest symbol information and thus not process
    and guest samples. The only exception is perf-kvm which changes the
    perf_guest value on its own.  So change the default for perf_guest back
    to false.

    Cc: David Ahern <dsahern@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Jason Wang <jasowang@redhat.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/1328893505-4115-3-git-send-email-joerg.roedel@amd.com
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

:040000 040000 64d65944c9081dfd9ace65dbc19fca655cbdc708 4f0e86ab85314ba68f2295ae1e599f3bb5ab9484 M      tools


Thanks,
Namhyung


