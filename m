Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1I2Bcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 21:32:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42299 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1I2Bcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 21:32:41 -0400
MIME-Version: 1.0
In-Reply-To: <201109282132.46887.rjw@sisk.pl>
References: <20110928145144.3d074db9aa9b6f858e0dc4fb@canb.auug.org.au>
	<201109281558.05289.rjw@sisk.pl>
	<CACVXFVMLBHu+CY1pgQnY04S_3iLN1z5S2vPiMdN6rsW=gBdWog@mail.gmail.com>
	<201109282132.46887.rjw@sisk.pl>
Date: Thu, 29 Sep 2011 09:32:39 +0800
Message-ID: <CACVXFVM6CjZacbbvn0VzM78SNDa6geHSw1dsrCL1bbTBU=pH1g@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pm tree
From: Ming Lei <ming.lei@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 3:32 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, September 28, 2011, Ming Lei wrote:
>> Hi,
>>
>> 2011/9/28 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Wednesday, September 28, 2011, Ming Lei wrote:
>> >> Hi Stephen and Rafael,
>> >>
>> >> Sorry, the attachment patch can fix the build failure, which is
>> >> caused by unset CONFIG_RUNTIME_PM.
>> >
>> > First off, that's CONFIG_PM_RUNTIME.  Second, why do you want to build
>> > rpm-traces.c at all if CONFIG_PM_RUNTIME is unset?
>> >
>>
>> Yes, you are right,  follows the correct fix:
>>
>> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
>> index 56bdab5..f49405f 100644
>> --- a/kernel/trace/Makefile
>> +++ b/kernel/trace/Makefile
>> @@ -53,7 +53,9 @@ endif
>>  obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
>>  obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
>>  obj-$(CONFIG_TRACEPOINTS) += power-traces.o
>> +ifeq ($(CONFIG_PM_RUNTIME),y)
>>  obj-$(CONFIG_TRACEPOINTS) += rpm-traces.o
>> +endif
>>  ifeq ($(CONFIG_TRACING),y)
>>  obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
>>  endif
>
> Well, this still is kind of ugly.  I'd prefer my patch sent in this thread.

Both are doable, :-)

But I don't think it is ugly, and this way is taken by BLOCK/PERF_EVENTS/
KGDB_KDB in kernel/trace/Makefile. Also this one is a simple fix and
don't introduce any new config option, which is unnecessary.


thanks,
--
Ming Lei
