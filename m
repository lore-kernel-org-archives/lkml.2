Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2GIMTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:19:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17333 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab2GIMTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:19:42 -0400
Message-ID: <4FFACC4F.7010806@oracle.com>
Date: Mon, 09 Jul 2012 20:19:27 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: e1000-devel@lists.sf.net,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 82571EB: Detected Hardware Unit Hang
References: <4FFA9B96.6040901@oracle.com> <1341825677.3265.2330.camel@edumazet-glaptop>
In-Reply-To: <1341825677.3265.2330.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/12 17:21, Eric Dumazet wrote:
> On Mon, 2012-07-09 at 16:51 +0800, Joe Jin wrote:
>> Hi list,
>>
>> I'm seeing a Unit Hang even with the latest e1000e driver 2.0.0 when doing
>> scp test. this issue is easy do reproduced on SUN FIRE X2270 M2, just copy
>> a big file (>500M) from another server will hit it at once. 
>>
>> Would you please help on this?
>>
> 
> Its a known problem.
> 
> But apparently Intel guys are not very responsive, as they have another
> patch than the following :
> 
> http://permalink.gmane.org/gmane.linux.network/232669

Eris, 

Thanks for you reply, but seems this patch not help for me, 
applied the patch still hit the issue:

# dmesg
e1000e 0000:05:00.0: eth0: Detected Hardware Unit Hang:
  TDH                  <6f>
  TDT                  <7e>
  next_to_use          <7e>
  next_to_clean        <6e>
buffer_info[next_to_clean]:
  time_stamp           <fffd48dc>
  next_to_watch        <74>
  jiffies              <fffd5344>
  next_to_watch.status <0>
MAC Status             <80387>
PHY Status             <792d>
PHY 1000BASE-T Status  <3c00>
PHY Extended Status    <3000>
PCI Status             <10>
e1000e 0000:05:00.0: eth0: Detected Hardware Unit Hang:
  TDH                  <6f>
  TDT                  <7e>
  next_to_use          <7e>
  next_to_clean        <6e>
buffer_info[next_to_clean]:
  time_stamp           <fffd48dc>
  next_to_watch        <74>
  jiffies              <fffd5b14>
  next_to_watch.status <0>
MAC Status             <80387>
PHY Status             <792d>
PHY 1000BASE-T Status  <3c00>
PHY Extended Status    <3000>
PCI Status             <10>
e1000e 0000:05:00.0: eth0: Detected Hardware Unit Hang:
  TDH                  <6f>
  TDT                  <7e>
  next_to_use          <7e>
  next_to_clean        <6e>
buffer_info[next_to_clean]:
  time_stamp           <fffd48dc>
  next_to_watch        <74>
  jiffies              <fffd62e4>
  next_to_watch.status <0>
MAC Status             <80387>
PHY Status             <792d>
PHY 1000BASE-T Status  <3c00>
PHY Extended Status    <3000>
PCI Status             <10>
e1000e 0000:05:00.0: eth0: Detected Hardware Unit Hang:
  TDH                  <6f>
  TDT                  <7e>
  next_to_use          <7e>
  next_to_clean        <6e>
buffer_info[next_to_clean]:
  time_stamp           <fffd48dc>
  next_to_watch        <74>
  jiffies              <fffd6ab4>
  next_to_watch.status <0>
MAC Status             <80387>
PHY Status             <792d>
PHY 1000BASE-T Status  <3c00>
PHY Extended Status    <3000>
PCI Status             <10>
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x225/0x230()
Hardware name: SUN FIRE X2270 M2
NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0 timed out
Modules linked in: autofs4 hidp rfcomm bluetooth rfkill lockd sunrpc cpufreq_ondemand acpi_cpufreq mperf be2iscsi iscsi_boot_sysfs ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i libcxgbi cxgb3 mdio libiscsi_tcp libiscsi scsi_transport_iscsi video sbs sbshc acpi_pad acpi_ipmi ipmi_msghandler parport_pc lp parport e1000e(U) snd_seq_dummy snd_seq_oss snd_seq_midi_event igb snd_seq snd_seq_device serio_raw snd_pcm_oss snd_mixer_oss snd_pcm tpm_infineon snd_timer snd soundcore i7core_edac iTCO_wdt iTCO_vendor_support snd_page_alloc edac_core i2c_i801 ioatdma i2c_core pcspkr ghes dca hed dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod usb_storage sd_mod crc_t10dif sg ahci libahci ext3 jbd mbcache [last unloaded: microcode]
Pid: 0, comm: swapper Not tainted 2.6.39-200.24.1.el5uek #1
Call Trace:
 [<c07d9ac5>] ? dev_watchdog+0x225/0x230
 [<c045ba61>] warn_slowpath_common+0x81/0xa0
 [<c07d9ac5>] ? dev_watchdog+0x225/0x230
 [<c045bb23>] warn_slowpath_fmt+0x33/0x40
 [<c07d9ac5>] dev_watchdog+0x225/0x230
 [<c07d98a0>] ? dev_activate+0xb0/0xb0
 [<c0468e82>] call_timer_fn+0x32/0xf0
 [<c046a76d>] run_timer_softirq+0xed/0x1b0
 [<c07d98a0>] ? dev_activate+0xb0/0xb0
 [<c0461a81>] __do_softirq+0x91/0x1a0
 [<c04619f0>] ? local_bh_enable+0x80/0x80
 <IRQ>  [<c0462295>] ? irq_exit+0x95/0xa0
 [<c087f8b8>] ? smp_apic_timer_interrupt+0x38/0x42
 [<c08784f5>] ? apic_timer_interrupt+0x31/0x38
 [<c046007b>] ? do_exit+0x11b/0x370
 [<c065eae4>] ? intel_idle+0xa4/0x100
 [<c078d9b9>] ? cpuidle_idle_call+0xb9/0x1e0
 [<c0411d77>] ? cpu_idle+0x97/0xd0
 [<c085cbbd>] ? rest_init+0x5d/0x70
 [<c0b07a7a>] ? start_kernel+0x28a/0x340
 [<c0b074b0>] ? obsolete_checksetup+0xb0/0xb0
 [<c0b070a4>] ? i386_start_kernel+0x64/0xb0
---[ end trace 5d51553c2ad66677 ]---
e1000e 0000:05:00.0: eth0: Reset adapter
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx

Any idea?

Thanks,
Joe

> 
> 
> We only have to wait they push their alternative patch, eventually.
> 
> In the mean time, you can use Hiroaki SHIMODA patch, it works.
> 
> 
> 


