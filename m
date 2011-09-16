Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1IPRar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:30:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab1IPRap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:30:45 -0400
Date: Fri, 16 Sep 2011 12:29:29 -0400
From: Dave Jones <davej@redhat.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Rudolf Marek <r.marek@assembler.cz>, lm-sensors@lm-sensors.org,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: Re: coretemp breaks lockdep. (MAX_LOCKDEP_ENTRIES too low!)
Message-ID: <20110916162929.GB2714@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Guenter Roeck <guenter.roeck@ericsson.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Rudolf Marek <r.marek@assembler.cz>, lm-sensors@lm-sensors.org,
	"R, Durgadoss" <durgadoss.r@intel.com>
References: <20110915193018.GA10256@redhat.com>
 <20110916160752.GA10978@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110916160752.GA10978@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 09:07:52AM -0700, Guenter Roeck wrote:
 > On Thu, Sep 15, 2011 at 03:30:18PM -0400, Dave Jones wrote:
 > > just had a user report this against rc6..
 > > 
 > > # while true; do rmmod coretemp; modprobe coretemp; done
 > > 
 > > 
 > > [15811.924167] BUG: MAX_LOCKDEP_ENTRIES too low!
 > > [15811.924171] turning off the locking correctness validator.
 > > [15811.924175] Pid: 10598, comm: modprobe Not tainted 3.1.0-rc6+ #5
 > > [15811.924178] Call Trace:
 > > [15811.924187]  [<ffffffff81081205>] ? up+0x39/0x3e
 > > [15811.924193]  [<ffffffff8108e556>] add_lock_to_list.constprop.22+0x45/0xa7
 > > [15811.924198]  [<ffffffff81090c05>] __lock_acquire+0xb7f/0xd0c
 > > [15811.924204]  [<ffffffff81091594>] ? mark_held_locks+0x6d/0x95
 > > [15811.924210]  [<ffffffff814e27d5>] ? __slab_alloc+0x41c/0x43d
 > > [15811.924216]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
 > > [15811.924221]  [<ffffffff81091295>] lock_acquire+0xf3/0x13e
 > > [15811.924225]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
 > > [15811.924230]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
 > > [15811.924236]  [<ffffffff814e96a3>] _raw_spin_lock+0x40/0x73
 > > [15811.924241]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
 > > [15811.924245]  [<ffffffff8127012e>] ? kobject_get+0x18/0x1f
 > > [15811.924250]  [<ffffffff812701d0>] kobject_add_internal+0x9b/0x18c
 > > [15811.924255]  [<ffffffff812705fa>] kobject_add+0x91/0xa2
 > > [15811.924260]  [<ffffffff814c5afd>] ? klist_init+0x33/0x46
 > > [15811.924265]  [<ffffffff81337bc3>] device_add+0xd5/0x576
 > > [15811.924271]  [<ffffffff81336ac3>] ? dev_set_name+0x41/0x43
 > > [15811.924277]  [<ffffffff8133b8f1>] platform_device_add+0x111/0x15b
 > > [15811.924283]  [<ffffffffa0606cbd>] get_core_online+0x9b/0x143 [coretemp]
 > > [15811.924290]  [<ffffffffa0050000>] ? 0xffffffffa004ffff
 > > [15811.924296]  [<ffffffffa005004b>] coretemp_init+0x4b/0x1000 [coretemp]
 > > [15811.924302]  [<ffffffffa0050000>] ? 0xffffffffa004ffff
 > > [15811.924308]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
 > > [15811.924313]  [<ffffffffa0050000>] ? 0xffffffffa004ffff
 > > [15811.924319]  [<ffffffff8109cacf>] sys_init_module+0x114/0x267
 > > [15811.924324]  [<ffffffff814f0202>] system_call_fastpath+0x16/0x1b
 > > 
 > > 
 > I have tried to reproduce the problem with lockdeb debugging enabled,
 > but I was unable to see it. Guess I must be missing something. 
 > 
 > Couple of questions:
 > 
 > What CPU and/or system was this seen with ? Output of /proc/cpuinfo might help.

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     L9600  @ 2.13GHz
stepping	: 10
cpu MHz		: 800.000
cache size	: 6144 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm ida dts tpr_shadow vnmi flexpriority
bogomips	: 4266.41
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     L9600  @ 2.13GHz
stepping	: 10
cpu MHz		: 2134.000
cache size	: 6144 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm ida dts tpr_shadow vnmi flexpriority
bogomips	: 4266.79
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

 > Can you send the configuration file used to build the kernel ?

User reported it using a fedora config. I reproduced it using a similar one..
http://codemonkey.org.uk/junk/coretempbug-config

 > How long does one have to run the loop ?

happened within a few seconds for me

 > What is the output of "sensors" with coretemp loaded ?


$ sensors
acpitz-virtual-0
Adapter: Virtual device
temp1:        +81.0°C  (crit = +100.0°C)
temp2:        +62.0°C  (crit = +100.0°C)
temp3:        +61.0°C  (crit = +100.0°C)

coretemp-isa-0000
Adapter: ISA adapter
Core 0:       +78.0°C  (high = +105.0°C, hyst =  +0.0°C)
                       (crit = +105.0°C)
Core 1:       +81.0°C  (high = +105.0°C, hyst =  +0.0°C)
                       (crit = +105.0°C)



