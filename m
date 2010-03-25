Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0CYIyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:54:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59770 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab0CYIyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:54:52 -0400
Message-ID: <4BAB2520.3080400@cn.fujitsu.com>
Date: Thu, 25 Mar 2010 16:56:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, zhiteng.huang@intel.com,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 3/3] perf events: Change perf parameter --pid to process-wide
 collection instead of thread-wide
References: <1268904666.2813.172.camel@localhost>	 <4BAB1881.8020500@cn.fujitsu.com> <1269506864.2078.75.camel@ymzhang.sh.intel.com>
In-Reply-To: <1269506864.2078.75.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Parameter --pid (or -p) of perf currently means a thread-wide collection.
>>> For exmaple, if a process whose id is 8888 has 10 threads, 'perf top -p 8888'
>>> just collects the main thread statistics. That's misleading. Users are
>>> used to attach a whole process when debugging a process by gdb. To follow
>>> normal usage style, the patch change --pid to process-wide collection and
>>> add --tid (-t) to mean a thread-wide collection.
>>>
>>> Usage example is:
>>> #perf top -p 8888
>>> #perf record -p 8888 -f sleep 10
>>> #perf stat -p 8888 -f sleep 10
>>> Above commands collect the statistics of all threads of process 8888.
>>>
>>> Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
>>>
>> Seems this patch causes seg faults:
>>
>> # ./perf sched record
>> Segmentation fault
>> # ./perf kmem record
>> Segmentation fault
>> # ./perf timechart record
>> Segmentation fault
> 
> Thanks for reporting it. Arnaldo, could you pick up below patch?
> Zefan, Could you try it?
> 

The fix works. Thanks!

> mmap_array[][][] is not reset to 0 after malloc. Below patch against
> tip/master of March 24th fixes it with a zalloc.
> 
> Reported-by:	Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by:	Zhang Yanmin <yanmin_zhang@linux.intel.com>
> 
