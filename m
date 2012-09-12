Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2ILINz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:13:55 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53565 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2ILINu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:13:50 -0400
Message-ID: <50504439.3050700@suse.cz>
Date: Wed, 12 Sep 2012 10:13:45 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: qemu-kvm loops after kernel udpate
References: <504F7ED8.1030702@suse.cz> <20120911190303.GA3626@amt.cnet> <504F93F1.2060005@suse.cz> <50504299.2050205@redhat.com>
In-Reply-To: <50504299.2050205@redhat.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 10:06 AM, Avi Kivity wrote:
> On 09/11/2012 10:41 PM, Jiri Slaby wrote:
>> On 09/11/2012 09:03 PM, Marcelo Tosatti wrote:
>>> On Tue, Sep 11, 2012 at 08:11:36PM +0200, Jiri Slaby wrote:
>>>> Hi,
>>>>
>>>> it looks like an update from next-20120824 to next-20120910 makes kvm
>>>> defunct. When I try to run qemu, it loops forever without printing
>>>> anything on the monitor.
>>>>
>>>> -no-kvm makes it indeed work.
>>>>
>>>> Cmdline I use:
>>>> qemu-kvm -k en-us -usbdevice tablet -balloon virtio -hda IMAGE -smp 2 -m
>>>> 1000M -net user -net nic,model=e1000 -usb -serial pty
>>>>
>>>> Before I start investigating further, like biscection, is this a known
>>>> issue already and fix available somewhere?
>>>
>>> Its not a known issue. 'info registers' (for both vcpus) and
>>> 'x /20i $eip' might help track it down. 
>>
>> I don't think it's in a state with something loaded.
>>
>> (qemu) cpu 0
>> (qemu) info registers
>> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000623
>> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
>> EIP=0000fff0 EFL=00010002 [-------] CPL=3 II=0 A20=1 SMM=0 HLT=0
>> ES =0000 00000000 0000ffff 00009300
>> CS =f000 000f0000 0000ffff 0000f300
> 
> This is before the first instruction is executed.
> 
> You're on an Intel host, yes?

Yes.

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz
stepping        : 11
microcode       : 0xba
...
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts nopl aperfmperf pni
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm lahf_lm
dtherm tpr_shadow vnmi flexpriority

>  Please provide the output of vmxcap
> (http://goo.gl/c5lUO),

pin-based controls
  External interrupt exiting               yes
  NMI exiting                              yes
  Virtual NMIs                             yes
  Activate VMX-preemption timer            no
primary processor-based controls
  Interrupt window exiting                 yes
  Use TSC offsetting                       yes
  HLT exiting                              yes
  INVLPG exiting                           yes
  MWAIT exiting                            yes
  RDPMC exiting                            yes
  RDTSC exiting                            yes
  CR3-load exiting                         forced
  CR3-store exiting                        forced
  CR8-load exiting                         yes
  CR8-store exiting                        yes
  Use TPR shadow                           yes
  NMI-window exiting                       yes
  MOV-DR exiting                           yes
  Unconditional I/O exiting                yes
  Use I/O bitmaps                          yes
  Monitor trap flag                        no
  Use MSR bitmaps                          yes
  MONITOR exiting                          yes
  PAUSE exiting                            yes
  Activate secondary control               yes
secondary processor-based controls
  Virtualize APIC accesses                 yes
  Enable EPT                               no
  Descriptor-table exiting                 no
  Virtualize x2APIC mode                   no
  Enable VPID                              no
  WBINVD exiting                           no
  Unrestricted guest                       no
  PAUSE-loop exiting                       no
  RDRAND exiting                           no
  Enable INVPCID                           no
  Enable VM functions                      no
VM-Exit controls
  Save debug controls                      forced
  Host address-space size                  yes
  Load IA32_PERF_GLOBAL_CTRL               no
  Acknowledge interrupt on exit            yes
  Save IA32_PAT                            no
  Load IA32_PAT                            no
  Save IA32_EFER                           no
  Load IA32_EFER                           no
  Save VMX-preemption timer value          no
VM-Entry controls
  Load debug controls                      forced
  IA-64 mode guest                         yes
  Entry to SMM                             yes
  Deactivate dual-monitor treatment        yes
  Load IA32_PERF_GLOBAL_CTRL               no
  Load IA32_PAT                            no
  Load IA32_EFER                           no
Miscellaneous data
  VMX-preemption timer scale (log2)        0
  Store EFER.LMA into IA-32e mode guest control no
  HLT activity state                       yes
  Shutdown activity state                  yes
  Wait-for-SIPI activity state             yes
  Number of CR3-target values              4
  MSR-load/store count recommenation       0
  IA32_SMM_MONITOR_CTL[2] can be set to 1  no
  MSEG revision identifier                 0
VPID and EPT capabilities
  Execute-only EPT translations            no
  Page-walk length 4                       no
  Paging-structure memory type UC          no
  Paging-structure memory type WB          no
  2MB EPT pages                            no
  1GB EPT pages                            no
  INVEPT supported                         no
  EPT accessed and dirty flags             no
  Single-context INVEPT                    no
  All-context INVEPT                       no
  INVVPID supported                        no
  Individual-address INVVPID               no
  Single-context INVVPID                   no
  All-context INVVPID                      no
  Single-context-retaining-globals INVVPID no
VM Functions
  EPTP Switching                           no

> and a snapshot of kvm_stat while the guest is hung.

kvm statistics

 exits                                      6778198  615942
 host_state_reload                             1988     187
 irq_exits                                     1523     138
 mmu_cache_miss                                   4       0
 fpu_reload                                       1       0

thanks,
-- 
js
suse labs
