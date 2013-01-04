Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3ADLLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 06:11:52 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63356 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3ADLLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 06:11:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	<20121126171539.GZ15971@htj.dyndns.org>
	<CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
Date: Fri, 4 Jan 2013 16:41:47 +0530
Message-ID: <CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 27 November 2012 10:49, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 26 November 2012 22:45, Tejun Heo <tj@kernel.org> wrote:
>> On Tue, Nov 06, 2012 at 04:08:45PM +0530, Viresh Kumar wrote:
>
>> I'm pretty skeptical about this.  queue_work() w/o explicit CPU
>> assignment has always guaranteed that the work item will be executed
>> on the same CPU.  I don't think there are too many users depending on
>> that but am not sure at all that there are none.  I asked you last
>> time that you would at the very least need to audit most users but it
>> doesn't seem like there has been any effort there.
>
> My bad. I completely missed/forgot that comment from your earlier mails.
> Will do it.

And this is the first thing i did this year :)

So there are almost 1200 files which are using: queue_work, queue_delayed_work,
schedule_work, schedule_delayed_work or schedule_on_each_cpu

Obviously i can't try to understand all of them :) , and so i tried to
search two
strings in them: "cpu" or "processor_id". So, this would catch every
file of these 1200
odd files which use some variables/comment/code with cpu or smp_processor_id or
raw_processor_id, etc..

I got around 650 files with these two searches.. Then i went into
these files to see if
there is anything noticeable, which may break due to this patch...

I got a list of files where cpu/processor_id strings are found, which
may break with
this patch (still can't guarantee as i don't have knowledge of these drivers)...

- arch/powerpc/mm/numa.c
- arch/s390/appldata/appldata_base.c
- arch/s390/kernel/time.c
- arch/s390/kernel/topology.c
- arch/s390/oprofile/hwsampler.c
- arch/x86/kernel/cpu/mcheck/mce.c
- arch/x86/kernel/tsc.c
- arch/x86/kvm/x86.c
- block/blk-core.c
- block/blk-throttle.c
- block/blk-genhd.c
- crypto/cryptd.c
- drivers/base/power/domain.c
- drivers/cpufreq/cpufreq.c
- drivers/hv/vmbus_drv.c
- drivers/infiniband/hw/qib/qib_iba7322.c and
drivers/infiniband/hw/qib/qib_init.c
- drivers/md/dm-crypt.c
- drivers/md/md.c
- drivers/net/ethernet/sfc/efx.c
- drivers/net/ethernet/tile/tilepro.c
- drivers/net/team/team_mode_loadbalance.c
- drivers/oprofile/cpu_buffer.c
- drivers/s390/kvm/kvm_virtio.c
- drivers/scsi/fcoe/fcoe.c
- drivers/tty/sysrq.c
- drivers/xen/pcpu.c
- fs/file.c, file_table.c, fs/fscache/object.c
- include/linux/stop_machine.h, kernel/stop_machine.c
- mm/percpu.c
- mm/slab.c
- mm/vmstat.c
- net/core/flow.c
- net/iucv/iucv.c

I am not sure what to do now :) , can you assist ?
