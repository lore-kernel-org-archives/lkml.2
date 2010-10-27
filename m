Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0J0HKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:10:20 -0400
Received: from szxga04-in.huawei.com ([119.145.14.67]:37490 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab0J0HKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:10:17 -0400
Date: Wed, 27 Oct 2010 15:10:04 +0800
From: marui <m00150988@huawei.com>
Subject: Re: [PATCH] fix oops in usbserial_cleanup function
To: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        zihan@huawei.com, wangyeqi@huawei.com
Message-id: <00a801cb75a5$faf0a680$ba260b0a@china.huawei.com>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
X-Priority: 3
X-MSMail-priority: Normal
References: <fadccdfb103f0.103f0fadccdfb@huawei.com>
 <Pine.LNX.4.44L0.1010151009050.1603-100000@iolanthe.rowland.org>
 <20101015190913.GA8098@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
I happend to the following bug:
bug report:
   a. Install huawei datacard dashboard on OpenSUSE 11.3
   b. Plug in huawei datacard into OpenSUSE 11.3 which kernel verison is 2.6.34
   c. After the dashboard has detected the device, I  pull out the usb datacard.
   d. close datashboard,then kernel panic will happen in usbserial_cleanup function and there are oops log as following:

I find when pull out the usb datacard, then close dashboard without shutdowning the usb serial port.
the oops will be happened.
I want to know what happened in this process. 
I know my patch will leak memory, But I don't have any other better solution.
Would you mind giving me a hand?
thanks a lot.

Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999650] serial_cleanup start--------------
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999651] serial_cleanup - port 5
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999653] destroy_serial - (null)
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999654] return_serial
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999671] BUG: unable to handle kernel NULL pointer dereference at (null)
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999675] IP: [<(null)>] (null)
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999677] *pdpt = 0000000032b21001 *pde = 0000000000000000 
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999680] Oops: 0010 [#1] PREEMPT SMP 
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999683] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.3/usb5/devnum
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999686] Modules linked in: option usbserial ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter ip6_tables x_tables fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep sr_mod snd_pcm iTCO_wdt iTCO_vendor_support floppy cdrom sg i2c_i801 pcspkr snd_timer sky2 snd soundcore snd_page_alloc i915 drm_kms_helper intel_agp drm i2c_algo_bit button video fan processor ata_generic thermal thermal_sys [last unloaded: option]
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999722] 
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999725] Pid: 10, comm: events/1 Tainted: G  R        2.6.34-12-desktop #1 To be filled by O.E.M./FFFFFFFFFF
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999727] EIP: 0060:[<00000000>] EFLAGS: 00010202 CPU: 1
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999730] EIP is at 0x0
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999732] EAX: f39f0ec0 EBX: f39f0ef4 ECX: 00000005 EDX: f7b569c0
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999734] ESI: f39f0ec0 EDI: f39f0ef4 EBP: f40e2e00 ESP: f40e5f10
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999735]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999737] Process events/1 (pid: 10, ti=f40e4000 task=f40e2e00 task.ti=f40e4000)
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999739] Stack:
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999740]  fb877b40 fb87aefd fb87ab80 00000000 f39f0ef4 fb877ac0 e02d2928 c03f351a
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999744] <0> f39f0ec0 f39f0ef8 fb877e93 fb87aeaa fb87aab8 00000005 e02d2800 e3951c80
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999749] <0> c0476fa7 c1488980 e02d2928 c0476f80 c025cde9 f40e309c e4f4a357 000005db
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999754] Call Trace:
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999756] Inexact backtrace:
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999757] 
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999762]  [<fb877b40>] ? destroy_serial+0x80/0xd0 [usbserial]
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999765]  [<fb877ac0>] ? destroy_serial+0x0/0xd0 [usbserial]
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999770]  [<c03f351a>] ? kref_put+0x2a/0x60
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999773]  [<fb877e93>] ? serial_cleanup+0x73/0xc0 [usbserial]
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999777]  [<c0476fa7>] ? release_one_tty+0x27/0xb0
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999779]  [<c0476f80>] ? release_one_tty+0x0/0xb0
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999783]  [<c025cde9>] ? run_workqueue+0x79/0x170
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999786]  [<c025cf63>] ? worker_thread+0x83/0xe0
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999789]  [<c0260140>] ? autoremove_wake_function+0x0/0x40
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999791]  [<c025cee0>] ? worker_thread+0x0/0xe0
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999793]  [<c025fd34>] ? kthread+0x74/0x80
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999795]  [<c025fcc0>] ? kthread+0x0/0x80
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999799]  [<c0203826>] ? kernel_thread_helper+0x6/0x10
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999800] Code:  Bad EIP value.
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999803] EIP: [<00000000>] 0x0 SS:ESP 0068:f40e5f10
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999809] CR2: 0000000000000000
Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999812] ---[ end trace 6f0d5616c481e9c5 ]---
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109270] ------------[ cut here ]------------
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109280] WARNING: at /usr/src/packages/BUILD/kernel-desktop-2.6.34/linux-2.6.34/kernel/workqueue.c:485 flush_cpu_workqueue+0xb9/0xc0()
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109282] Hardware name: FFFFFFFFFF
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109283] Modules linked in: option usbserial ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter ip6_tables x_tables fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep sr_mod snd_pcm iTCO_wdt iTCO_vendor_support floppy cdrom sg i2c_i801 pcspkr snd_timer sky2 snd soundcore snd_page_alloc i915 drm_kms_helper intel_agp drm i2c_algo_bit button video fan processor ata_generic thermal thermal_sys [last unloaded: option]
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109332] Pid: 10288, comm: gdm-simple-slav Tainted: G  R   D    2.6.34-12-desktop #1
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109334] Call Trace:
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109345]  [<c02065c3>] try_stack_unwind+0x173/0x190
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109349]  [<c02051cf>] dump_trace+0x3f/0xe0
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109352]  [<c020662b>] show_trace_log_lvl+0x4b/0x60
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109355]  [<c0206658>] show_trace+0x18/0x20
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109360]  [<c064d690>] dump_stack+0x6d/0x72
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109364]  [<c024430e>] warn_slowpath_common+0x6e/0xb0
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109367]  [<c0244363>] warn_slowpath_null+0x13/0x20
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109370]  [<c025c2f9>] flush_cpu_workqueue+0xb9/0xc0
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109374]  [<c025c60e>] flush_workqueue+0x2e/0x50
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109378]  [<c047e9f3>] tty_ldisc_release+0x23/0x60
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109382]  [<c04787b9>] tty_release+0x379/0x5b0
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109388]  [<c02feaa7>] __fput+0xc7/0x1d0
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109392]  [<c02fb259>] filp_close+0x49/0x70
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109395]  [<c02fb2ed>] sys_close+0x6d/0xc0
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109398]  [<c020324c>] sysenter_do_call+0x12/0x22
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109406]  [<ffffe424>] 0xffffe424
Oct 27 00:20:54 linux-mec9 kernel: [ 6486.109407] ---[ end trace 6f0d5616c481e9c6 ]---

----- Original Message ----- 
From: "Greg KH" <greg@kroah.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: <m00150988@huawei.com>; "USB list" <linux-usb@vger.kernel.org>; "Kernel development list" <linux-kernel@vger.kernel.org>; <zihan@huawei.com>; "Lin Lei" <Lin.Lei@huawei.com>; "Franko Fang" <huananhu@huawei.com>; <wangyeqi@huawei.com>
Sent: Saturday, October 16, 2010 3:09 AM
Subject: Re: [PATCH] fix oops in usbserial_cleanup function;


> On Fri, Oct 15, 2010 at 10:15:34AM -0400, Alan Stern wrote:
>> On Fri, 15 Oct 2010 m00150988@huawei.com wrote:
>> 
>> > From:ma rui <m00150988@huawei.com>
>> > 1. I find this bug on OpenSUSE 11.3 which kernel version is 2.6.34, but the latest kernel version 2.6.36-rc7 aslo have this bug. This patch is based on
>> > the kernel of 2.6.36-rc7
>> > 2. bug report:
>> >    a. Install huawei datacard dashboard on OpenSUSE 11.3
>> >    b. Plug in huawei datacard into OpenSUSE 11.3 which kernel version is 2.6.36-rc7
>> >    c. After the dashboard has detected the device, I pull out the usb datacard
>> >    d. Close dashboard,then kernel panic will happen in usbserial_clean function


>> > 
>> > Yes, the datacard exit without close the port. 
>> > 
>> > But after the dashboard connect internet with hauwei datacard, then Hibernate/resume, the bug will happen too.
>> > Do you have any other good idea to resolve this bug,or please apply my patch,thanks. :)
>> > 
>> > 
>> > Signed-off-by: ma rui <m00150988@huawei.com>
>> > 
>> > 
>> > diff -uprN -X linux-2.6.36-rc7_orig/Documentation/dontdiff linux-2.6.36-rc7_orig/drivers/usb/serial/usb-serial.c linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c
>> > --- linux-2.6.36-rc7_orig/drivers/usb/serial/usb-serial.c 2010-10-06 16:39:52.000000000 -0400
>> > +++ linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c 2010-10-15 01:57:36.000000000 -0400
>> > @@ -328,6 +328,16 @@ static void serial_cleanup(struct tty_st
>> >  /* The console is magical.  Do not hang up the console hardware
>> >  * or there will be tears.
>> >  */
>> > + if (NULL == port)
>> > + return;
>> > + mutex_lock(&port->serial->disc_mutex);
>> > + if (port->serial->disconnected) {
>> > + return_serial(port->serial);
>> > + mutex_unlock(&port->serial->disc_mutex);
>> > + return;
>> > + }
>> > + mutex_unlock(&port->serial->disc_mutex);
>> > +
>> >  if (port->port.console)
>> >  return;
>> 
>> This patch is clearly wrong, since it skips some of the actions that 
>> should be taken by serial_cleanup even if the port is already 
>> disconnected.
>> 
>> Besides, the main point of the patch is to avoid problems when 
>> port = tty->driver_data turns out to be NULL.  But the only place where 
>> tty->driver_data is set to NULL is further below in this same function!  
>> So the problems should never arise.
>> 
>> If they do arise, it indicates there's a bug somewhere else.  That 
>> other bug can't be fixed by changing this function.
> 
> Yeah, I agree.
> 
> Ma, what is the full oops message that you are seeing here when you
> remove the device?  And does userspace still have the device open at
> that time?  I'm guessing so as it sounds like the oops happens when the
> port is then closed.  I can't duplicate that problem here.
> 
> thanks,
> 
> greg k-h
