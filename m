Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab1DHQd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:33:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56463 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752739Ab1DHQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:33:24 -0400
Date: Fri, 8 Apr 2011 12:33:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Endless print of uhci_result_common: failed with status 440000
In-Reply-To: <BANLkTinDT7kk8bi-TAqQAn0NoP1wiskWpQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104081232300.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011, Zdenek Kabelac wrote:

> Ok - I've disabled this config option - now kernel writes this:
> (when I keep bt device enabled)
> 
> usb 3-1: USB disconnect, device number 2
> btusb_bulk_complete: hci0 urb ffff88012b94ca50 failed to resubmit (19)
> btusb_intr_complete: hci0 urb ffff88012b94c000 failed to resubmit (19)
> btusb_bulk_complete: hci0 urb ffff88012b94c948 failed to resubmit (19)
> btusb_send_frame: hci0 urb ffff880113dd0528 submission failed
> ------------[ cut here ]------------
> WARNING: at lib/debugobjects.c:262 debug_print_object+0x7c/0x8d()
> Hardware name: 6464CTO
> ODEBUG: free active (active state 0) object type: timer_list hint:
> hci_cmd_timer+0x0/0x46 [bluetooth]
> Modules linked in: hidp ip6table_filter
> systemd[1]: Service bluetooth.target is not needed anymore. Stopping.
>  ip6_tables ebtable_nat ebtables xt_CHECKSUM iptable_mangle tun bridge
> ipv6 stp llc sunrpc rfcomm acpi_cpufreq freq_table mperf bnep
> xt_physdev ipt_MASQUERADE iptable_nat nf_nat snd_hda_codec_analog arc4
> iwl3945 snd_hda_intel snd_hda_codec snd_hwdep r852 snd_seq sm_common
> snd_seq_device microcode btusb nand iwl_legacy nand_ids r592 nand_ecc
> memstick mtd snd_pcm mac80211 i2c_i801 joydev iTCO_wdt bluetooth
> iTCO_vendor_support cfg80211 thinkpad_acpi e1000e snd_timer rfkill
> snd_page_alloc wmi snd soundcore virtio_net kvm_intel kvm uinput
> sdhci_pci yenta_socket sdhci mmc_core i915 drm_kms_helper drm
> i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
> Pid: 21, comm: khubd Not tainted 2.6.39-0.rc2.git0.0.fc16.x86_64 #1
> Call Trace:
>  [<ffffffff81056af8>] warn_slowpath_common+0x83/0x9b
>  [<ffffffff81056bb3>] warn_slowpath_fmt+0x46/0x48
>  [<ffffffff8125c173>] debug_print_object+0x7c/0x8d
>  [<ffffffffa023718c>] ? hci_send_acl+0x27c/0x27c [bluetooth]
>  [<ffffffff8125c961>] debug_check_no_obj_freed+0x96/0x175
>  [<ffffffffa02438e9>] ? bt_host_release+0x16/0x18 [bluetooth]
>  [<ffffffff811202ac>] slab_free_hook+0x6b/0x74
>  [<ffffffff811223a8>] kfree+0x8e/0xf2
>  [<ffffffffa02438e9>] bt_host_release+0x16/0x18 [bluetooth]
>  [<ffffffff813160da>] device_release+0x4c/0x81
>  [<ffffffff8124e89b>] kobject_release+0x11d/0x154
>  [<ffffffff8124e77e>] ? kobject_del+0x36/0x36
>  [<ffffffff8124fccf>] kref_put+0x43/0x4d
>  [<ffffffff8124e6e1>] kobject_put+0x45/0x49
>  [<ffffffff81315b1b>] put_device+0x17/0x19
>  [<ffffffffa02389a2>] hci_free_dev+0x26/0x2a [bluetooth]
>  [<ffffffffa0390cbb>] btusb_disconnect+0xbd/0xc6 [btusb]
>  [<ffffffff81378b18>] usb_unbind_interface+0x5c/0x124
>  [<ffffffff8131932e>] __device_release_driver+0x7c/0xd5
>  [<ffffffff813193ac>] device_release_driver+0x25/0x32
>  [<ffffffff81318edb>] bus_remove_device+0xc4/0xd4
>  [<ffffffff81316812>] device_del+0x13c/0x18a
>  [<ffffffff81376d6e>] usb_disable_device+0x8c/0x178
>  [<ffffffff8136f6d1>] usb_disconnect+0xd0/0x135
>  [<ffffffff813716ab>] hub_thread+0x741/0x119d
>  [<ffffffff81087164>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff810734fc>] ? __init_waitqueue_head+0x4b/0x4b
>  [<ffffffff81370f6a>] ? usb_remote_wakeup+0x64/0x64
>  [<ffffffff81072d8d>] kthread+0xa8/0xb0
>  [<ffffffff814c4ba4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff814bd254>] ? retint_restore_args+0x13/0x13
>  [<ffffffff81072ce5>] ? __init_kthread_worker+0x5a/0x5a
>  [<ffffffff814c4ba0>] ? gs_change+0x13/0x13
> ---[ end trace a7aecbf020e621f2 ]---
> PM: Syncing filesystems ... done.
> PM: Preparing system for mem sleep

That looks like a bug in bt_host_release() or hci_free_dev().

Alan Stern

