Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0HPSpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:45:19 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:42431 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752414Ab0HPSpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:45:17 -0400
Date: Mon, 16 Aug 2010 14:45:15 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.36-rc1: WARNING when loading ehci-hcd module
Message-ID: <20100816184515.GA3247@elliptictech.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After installing 2.6.36-rc1, I found a call trace in my dmesg after
boot.  Traking it down a bit, it appears to happen when ehci-hcd is
loaded.  The log after running 'modprobe ehci-hcd' appended to this
mail.  This wasn't a problem in 2.6.35, but I don't have time to bisect
right now.

Now, I see the warning about how ehci should be loaded before uhci.  I
also see that this is apparently not a new message.  My configuration
has uhci built-in but ehci as a module.  If this is not a supported
configuration, probably some dependencies need to be fixed in the
Kconfig.

Other than the trace, there seems to be no problems related to ehci.

ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe9f8000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe9f2000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 6 ports detected
usb 2-1: USB disconnect, address 2
usb 2-2: USB disconnect, address 3
------------[ cut here ]------------
WARNING: at /scratch_space/linux-2.6/lib/kobject.c:595 kobject_put+0x2f/0x42()
Hardware name: Aspire X3810
kobject: '(null)' (ffff88013e02d898): is not initialized, yet kobject_put() is being called.
Modules linked in: ehci_hcd nfs nfs_acl bridge stp llc autofs4 nfsd lockd sunrpc exportfs ipv6 iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_hda_codec_intelhdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc ext2 evdev sr_mod cdrom loop tun acpi_cpufreq mperf e1000e
Pid: 256, comm: khubd Not tainted 2.6.36-rc1-00001-g6041d49 #17
Call Trace:
 [<ffffffff810329b8>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff81032a6b>] ? warn_slowpath_fmt+0x45/0x4a
 [<ffffffff812d389c>] ? notifier_call_chain+0x2e/0x5b
 [<ffffffff81132a70>] ? kobject_put+0x2f/0x42
 [<ffffffff8124e2a7>] ? usbhid_disconnect+0x2c/0x35
 [<ffffffff81222147>] ? usb_unbind_interface+0x45/0xc3
 [<ffffffff811f5e25>] ? __device_release_driver+0x65/0xb0
 [<ffffffff811f5f24>] ? device_release_driver+0x11/0x1a
 [<ffffffff811f532e>] ? bus_remove_device+0x9f/0xb4
 [<ffffffff811f39e4>] ? device_del+0x120/0x16a
 [<ffffffff812200e7>] ? usb_disable_device+0x6c/0xe0
 [<ffffffff8121bdb8>] ? usb_disconnect+0x77/0x109
 [<ffffffff8121c447>] ? hub_thread+0x428/0xd84
 [<ffffffff8104772f>] ? autoremove_wake_function+0x0/0x2a
 [<ffffffff8121c01f>] ? hub_thread+0x0/0xd84
 [<ffffffff8121c01f>] ? hub_thread+0x0/0xd84
 [<ffffffff8104733a>] ? kthread+0x7a/0x82
 [<ffffffff81003654>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810472c0>] ? kthread+0x0/0x82
 [<ffffffff81003650>] ? kernel_thread_helper+0x0/0x10
---[ end trace 1f9da30167172bba ]---

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
