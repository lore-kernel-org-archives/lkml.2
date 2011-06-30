Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1F3A0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 20:26:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4050 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1F3A0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 20:26:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=pq4krO27a+vSS5jaiDpyv4QfSEmcPKkdzkwTmmAFgiFdOmXtzrdfT41bEbb+9OMKF
	CZfqeqHopyCexM+Qr5HjA==
MIME-Version: 1.0
In-Reply-To: <1309330546.14604.97.camel@debian>
References: <1308797024.23204.95.camel@debian> <1308819748.1022.69.camel@twins>
 <1308876099.23204.124.camel@debian> <1309219329.14604.11.camel@debian>
 <1309273180.6701.213.camel@twins> <BANLkTi=KvKZtjFuDNxfKKAxysWUw4CiJecG8wnckYPvv9BzNrA@mail.gmail.com>
 <CAOM-RdPBc2kcWDtUvTDe9PqQMq=u5qcEprDbC9guVi+wX+9bRg@mail.gmail.com>
 <1309317764.14604.92.camel@debian> <1309330546.14604.97.camel@debian>
From: Nikhil Rao <ncrao@google.com>
Date: Wed, 29 Jun 2011 17:26:12 -0700
Message-ID: <CAOM-RdP3PiZTzS3+RQ4aorH8r8hDhgsst-LLb1BrbZ4y07vi0w@mail.gmail.com>
Subject: Re: power increase issue on light load
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 11:55 PM, Alex,Shi <alex.shi@intel.com> wrote:
>> > - Would it be possible to get a "perf sched" trace on these two kernels?
>
> I tried the 'perf sched record' and then 'perf sched trace' as usage
> show. but in fact, the 'perf sched' doesn't support 'trace' command now.

I believe this was renamed to "perf script" in
133dc4c39c57eeef2577ca5b4ed24765b7a78ce2.

> since the 'perf sched record' is using 'perf record -e sched:xxx' to do
> record. I used 'perf record' directly. The follow info collected in 300'
> on my NHM-EP for benchmark bltk-office.
>
> [alexs@lkp-ne01 ~]$ grep -e Events.*sched
> linux-2.6/perf-report-3.0.0-rc5
> # Events: 11K sched:sched_wakeup
> # Events: 1K sched:sched_wakeup_new
> # Events: 24K sched:sched_switch
> # Events: 3K sched:sched_migrate_task
> # Events: 851  sched:sched_process_free
> # Events: 1K sched:sched_process_exit
> # Events: 1K sched:sched_process_wait
> # Events: 1K sched:sched_process_fork
> # Events: 12K sched:sched_stat_wait
> # Events: 9K sched:sched_stat_sleep
> # Events: 452  sched:sched_stat_iowait
> # Events: 16K sched:sched_stat_runtime
> [alexs@lkp-ne01 ~]$
> [alexs@lkp-ne01 ~]$
> [alexs@lkp-ne01 ~]$ grep -e
> Events.*sched /mnt/linux-2.6.39/perf-report-2.6.39
> # Events: 5K sched:sched_wakeup
> # Events: 615  sched:sched_wakeup_new
> # Events: 11K sched:sched_switch
> # Events: 2K sched:sched_migrate_task
> # Events: 541  sched:sched_process_free
> # Events: 692  sched:sched_process_exit
> # Events: 1K sched:sched_process_wait
> # Events: 615  sched:sched_process_fork
> # Events: 6K sched:sched_stat_wait
> # Events: 4K sched:sched_stat_sleep
> # Events: 178  sched:sched_stat_iowait
> # Events: 9K sched:sched_stat_runtime
>
>

Thanks for the data but these raw counts are not very useful. Can you
please send either the binary file or the ascii trace output for the
two kernels? Also -- a 300s trace might be too much; about 30s should
be sufficient.

-Thanks,
Nikhil
