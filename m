Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab2EPBki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:40:38 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42608 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab2EPBkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:40:36 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-a6-4fb30587e71e
From: Namhyung Kim <namhyung.kim@lge.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Perf events warning..
References: <CA+55aFzNQqa9nuhZUog-+B0SfU6ip_QSt73R=2Du=M2ua1cFBA@mail.gmail.com>
	<1337034048.27020.137.camel@laptop>
	<CA+55aFxHw_SOX7fvcwskwP0qvLwyeXxTFjk589pnQtmYevhvpw@mail.gmail.com>
	<1337078996.27694.26.camel@twins> <4FB2755F.9020606@gmail.com>
	<1337095700.27694.76.camel@twins> <4FB27841.9040301@gmail.com>
Date: Wed, 16 May 2012 10:38:33 +0900
In-Reply-To: <4FB27841.9040301@gmail.com> (David Ahern's message of "Tue, 15
	May 2012 09:37:37 -0600")
Message-ID: <87aa18ewh2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 15 May 2012 09:37:37 -0600, David Ahern wrote:
> :-) Right, KVM and the vPMU added in 3.3. That said, it is recognized
> as a Nehalem and perf walks the Nehalem events path.
>
> So if VM based WARNING is not to your liking, here's a baremetal version:
>
> [   84.388495] ------------[ cut here ]------------
> [   84.388554] WARNING: at
> /opt/sw/ahern/kernels/kernel-2.6.git/arch/x86/kernel/cpu/perf_event.c:1054
> x86_pmu_start+0xdc/0x110()
> [   84.388613] Hardware name: ProLiant DL380 G6
> [   84.388663] Modules linked in: nfs fscache bridge stp llc
> ipt_MASQUERADE iptable_nat nf_nat xt_physdev nf_conntrack_ipv4
> nf_defrag_ipv4 xt_state nf_conntrack xt_multiport nfsd lockd nfs_acl
> auth_rpcgss sunrpc coretemp ipmi_si ipmi_msghandler bnx2 i7core_edac
> edac_core hpilo hpwdt acpi_power_meter crc32c_intel microcode iTCO_wdt
> iTCO_vendor_support vhost_net pcspkr macvtap macvlan tun virtio_net
> kvm_intel kvm usb_storage hpsa radeon ttm drm_kms_helper drm
> i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
> [   84.390624] Pid: 1806, comm: find Not tainted 3.4.0-rc7+ #1
> [   84.390671] Call Trace:
> [   84.390719]  [<ffffffff810579df>] warn_slowpath_common+0x7f/0xc0
> [   84.390769]  [<ffffffff81057a3a>] warn_slowpath_null+0x1a/0x20
> [   84.390831]  [<ffffffff8102546c>] x86_pmu_start+0xdc/0x110
> [   84.390880]  [<ffffffff81025b22>] x86_pmu_enable+0x212/0x270
> [   84.390996]  [<ffffffff81116496>] perf_event_context_sched_in+0xe6/0x100
> [   84.391113]  [<ffffffff811180b3>] perf_event_comm+0x103/0x2b0
> [   84.391232]  [<ffffffff81186732>] set_task_comm+0x72/0xe0
> [   84.391361]  [<ffffffff81186e0b>] setup_new_exec+0x8b/0x240
> [   84.391480]  [<ffffffff811ceca7>] load_elf_binary+0x3e7/0x19a0
> [   84.391600]  [<ffffffff81145ac2>] ? get_user_pages+0x52/0x60
> [   84.391716]  [<ffffffff81184af8>] ? get_user_arg_ptr+0x38/0x80
> [   84.391833]  [<ffffffff81184f9e>] search_binary_handler+0xee/0x340
> [   84.391963]  [<ffffffff811ce8c0>] ? load_elf_library+0x230/0x230
> [   84.392080]  [<ffffffff81186bef>] do_execve_common+0x36f/0x410
> [   84.392196]  [<ffffffff81186cca>] do_execve+0x3a/0x40
> [   84.392328]  [<ffffffff8101d4a7>] sys_execve+0x47/0x70
> [   84.392445]  [<ffffffff816002ec>] stub_execve+0x6c/0xc0
> [   84.392558] ---[ end trace 78e50a201158fd5d ]---
>
>
> Though this one is an HP server with the lovely:
>
> [    0.143910] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem
> events, Broken BIOS detected, complain to your hardware vendor.
> [    0.144351] [Firmware Bug]: the BIOS has corrupted hw-PMU resources
> (MSR 38d is 330)
> [    0.144627] Intel PMU driver.
> [    0.144777] CPU erratum AAJ80 worked around
>
> David

I got a similar warning on my SNB (i7-3930K) desktop.

Thanks,
Namhyung
