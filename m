Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2KZUTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:19:04 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46701 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab2KZUS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:18:59 -0500
MIME-Version: 1.0
In-Reply-To: <20121126105839.GC963@stefanha-thinkpad.redhat.com>
References: <CAK3+h2xLLnP03+cP=-aSf=xmiEuZ-RFhxP1DoeO9Hs8ksoX6zw@mail.gmail.com>
	<20121123072941.GH22787@stefanha-thinkpad.hitronhub.home>
	<CAK3+h2xBwtzbO15fJUZprv7AyEnqr3CHoa+z_7zY0qSwp5g5aQ@mail.gmail.com>
	<20121126105839.GC963@stefanha-thinkpad.redhat.com>
Date: Mon, 26 Nov 2012 12:18:58 -0800
Message-ID: <CAK3+h2w5d4QRQpocsR23pQTH3xuPdZYOk=fOe47gf1DVE+53Sg@mail.gmail.com>
Subject: Re: KVM Disk i/o or VM activities causes soft lockup?
From: Vincent Li <vincent.mc.li@gmail.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 2:58 AM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Fri, Nov 23, 2012 at 10:34:16AM -0800, Vincent Li wrote:
>> On Thu, Nov 22, 2012 at 11:29 PM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
>> > On Wed, Nov 21, 2012 at 03:36:50PM -0800, Vincent Li wrote:
>> >> We have users running on redhat based distro (Kernel
>> >> 2.6.32-131.21.1.el6.x86_64 ) with kvm, when customer made cron job
>> >> script to copy large files between kvm guest or some other user space
>> >> program leads to disk i/o or VM activities, users get following soft
>> >> lockup message from console:
>> >>
>> >> Nov 17 13:44:46 slot1/luipaard100a err kernel: BUG: soft lockup -
>> >> CPU#4 stuck for 61s! [qemu-kvm:6795]
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel: Modules linked in:
>> >> ebt_vlan nls_utf8 isofs ebtable_filter ebtables 8021q garp bridge stp
>> >> llc ipt_REJECT iptable_filter xt_NOTRACK nf_conntrack iptable_raw
>> >> ip_tables loop ext2 binfmt_misc hed womdict(U) vnic(U) parport_pc lp
>> >> parport predis(U) lasthop(U) ipv6 toggler vhost_net tun kvm_intel kvm
>> >> jiffies(U) sysstats hrsleep i2c_dev datastor(U) linux_user_bde(P)(U)
>> >> linux_kernel_bde(P)(U) tg3 libphy serio_raw i2c_i801 i2c_core ehci_hcd
>> >> raid1 raid0 virtio_pci virtio_blk virtio virtio_ring mvsas libsas
>> >> scsi_transport_sas mptspi mptscsih mptbase scsi_transport_spi 3w_9xxx
>> >> sata_svw(U) ahci serverworks sata_sil ata_piix libata sd_mod
>> >> crc_t10dif amd74xx piix ide_gd_mod ide_core dm_snapshot dm_mirror
>> >> dm_region_hash dm_log dm_mod ext3 jbd mbcache
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel: Pid: 6795, comm:
>> >> qemu-kvm Tainted: P           ----------------
>> >> 2.6.32-131.21.1.el6.f5.x86_64 #1
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel: Call Trace:
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel: <IRQ>
>> >> [<ffffffff81084f95>] ? get_timestamp+0x9/0xf
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff810855d6>] ? watchdog_timer_fn+0x130/0x178
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff81059f11>] ? __run_hrtimer+0xa3/0xff
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff8105a188>] ? hrtimer_interrupt+0xe6/0x190
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff8105a14b>] ? hrtimer_interrupt+0xa9/0x190
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff8101e5a9>] ? hpet_interrupt_handler+0x26/0x2d
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff8105a26f>] ? hrtimer_peek_ahead_timers+0x9/0xd
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff81044fcc>] ? __do_softirq+0xc5/0x17a
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff81003adc>] ? call_softirq+0x1c/0x28
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff8100506b>] ? do_softirq+0x31/0x66
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff81003673>] ? call_function_interrupt+0x13/0x20
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel: <EOI>
>> >> [<ffffffffa0219986>] ? vmx_get_msr+0x0/0x123 [kvm_intel]
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffffa01d11c0>] ? kvm_arch_vcpu_ioctl_run+0x80e/0xaf1 [kvm]
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffffa01d11b4>] ? kvm_arch_vcpu_ioctl_run+0x802/0xaf1 [kvm]
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff8114e59b>] ? inode_has_perm+0x65/0x72
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffffa01c77f5>] ? kvm_vcpu_ioctl+0xf2/0x5ba [kvm]
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff8114e642>] ? file_has_perm+0x9a/0xac
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff810f9ec2>] ? vfs_ioctl+0x21/0x6b
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff810fa406>] ? do_vfs_ioctl+0x487/0x4da
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff810fa4aa>] ? sys_ioctl+0x51/0x70
>> >> Nov 17 13:44:46 slot1/luipaard100a warning kernel:
>> >> [<ffffffff810029d1>] ? system_call_fastpath+0x3c/0x41
>> >
>> > This soft lockup is report on the host?
>> >
>> > Stefan
>>
>> Yes, it is on host. we just recommend users not doing large file
>> copying, just wondering if there is potential kernel bug. it seems the
>> softlockup backtrace pointing to hrtimer and softirq. my naive
>> knowledge is that the watchdog thread is on top of hrtimer which is on
>> top of softirq.
>
> Since the soft lockup detector is firing on the host, this seems like a
> hardware/driver problem.  Have you ever had soft lockups running non-KVM
> workloads on this host?
>
> Stefan

this soft lockup only triggers when running KVM, also users used
another script in cron job to restart 4 kvm instance every 5 mintues (
insane to me) that also causing tons of softlock up message during the
kvm instance startup . we have already told customer stop doing that
and the softlockup message disappear.

Vincent
