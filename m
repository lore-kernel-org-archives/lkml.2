Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0GLSVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 14:21:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48885 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab0GLSVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:21:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6041"; a="47235389"
X-IronPort-AV: E=Sophos;i="4.55,188,1278313200"; 
   d="scan'208";a="82192039"
Message-ID: <4C3B5D68.5010809@qualcomm.com>
Date: Mon, 12 Jul 2010 11:22:32 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkml20100708@newton.leun.net" <lkml20100708@newton.leun.net>
Subject: Re: Fw: sysfs bug when using tun with network namespaces
References: <20100709132919.7871bee6@xenia.leun.net>
In-Reply-To: <20100709132919.7871bee6@xenia.leun.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

On 07/09/2010 04:29 AM, Michael Leun wrote:
> Hello,
>
>> # tunctl -u ml -t tap1
>
> works as expected, but
>
>> # unshare -n /bin/bash
>> # tunctl -u ml -t tap1

Thanks for forwarding this report. I'll take a look and try to reproduce 
and fix it when I get a chance.

Max




>
> Jul  8 18:03:59 doris kernel: ------------[ cut here ]------------
> Jul  8 18:03:59 doris kernel: kernel BUG at fs/sysfs/file.c:540!
> Jul  8 18:03:59 doris kernel: invalid opcode: 0000 [#1] PREEMPT SMP
> Jul  8 18:03:59 doris kernel: last sysfs
> file: /sys/devices/virtual/misc/tun/dev Jul  8 18:03:59 doris kernel:
> Modules linked in: tun snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device
> vboxnetadp vboxnetflt vboxdrv ipv6 cpufreq_conservative
> cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq
> speedstep_lib freq_table ipt_REJECT ipt_LOG xt_limit xt_recent xt_state
> xt_tcpudp iptable_mangle iptable_nat iptable_filter nf_nat_ftp nf_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack
> ip_tables x_tables fuse nls_utf8 loop snd_hda_codec_realtek arc4
> snd_hda_intel ecb snd_hda_codec iwlagn snd_pcm iwlcore snd_timer
> mac80211 snd cfg80211 soundcore intel_agp video usb_storage agpgart
> i2c_i801 rfkill snd_page_alloc output button battery ac joydev sg evdev
> tg3 edd ext4 jbd2 crc16 sha256_generic aes_i586 aes_generic cbc
> dm_crypt linear rtc_cmos uhci_hcd rtc_core rtc_lib sd_mod crc_t10dif
> ehci_hcd usbcore dm_snapshot dm_mod fan processor thermal [last
> unloaded: tun] Jul  8 18:03:59 doris kernel: Jul  8 18:03:59 doris
> kernel: Pid: 4320, comm: tunctl Not tainted 2.6.34.1 #3
> Kuril                           /40684JG Jul  8 18:03:59 doris kernel:
> EIP: 0060:[<c03129e1>] EFLAGS: 00010246 CPU: 0 Jul  8 18:03:59 doris
> kernel: EIP is at sysfs_create_file+0x21/0x30 Jul  8 18:03:59 doris
> kernel: EAX: 00000000 EBX: f66a73c0 ECX: f66a72bc EDX: f81587b4 Jul  8
> 18:03:59 doris kernel: ESI: 00000000 EDI: f67a7f00 EBP: f68ade90 ESP:
> f68ade90 Jul  8 18:03:59 doris kernel: DS: 007b ES: 007b FS: 00d8 GS:
> 00e0 SS: 0068 Jul  8 18:03:59 doris kernel: Process tunctl (pid: 4320,
> ti=f68ac000 task=f66e8f40 task.ti=f68ac000)
> Jul  8 18:03:59 doris kernel: Stack:
> Jul  8 18:03:59 doris kernel: f68ade98 c03e6da3 f68adf00 f8157fe0
> f8158700 f48496c0 00000001 f66a7000
> Jul  8 18:03:59 doris kernel:<0>  f6b63c00 bfe0fafc f68aded0 00000000
> 00000000 000000ca b777a000 c1fbcca0
> Jul  8 18:03:59 doris kernel:<0>  356e7574 00000000 00000000 00000000
> 00001001 00000000 00000000 00000000
> Jul  8 18:03:59 doris kernel: Call Trace:
> Jul  8 18:03:59 doris kernel: [<c03e6da3>] ?
> device_create_file+0x13/0x20 Jul  8 18:03:59 doris kernel:
> [<f8157fe0>] ? tun_chr_ioctl+0x820/0xa26 [tun] Jul  8 18:03:59 doris
> kernel: [<c02cd91d>] ? vfs_ioctl+0x2d/0xc0 Jul  8 18:03:59 doris
> kernel: [<f81577c0>] ? tun_chr_ioctl+0x0/0xa26 [tun] Jul  8 18:03:59
> doris kernel: [<c02cdafa>] ? do_vfs_ioctl+0x6a/0x5a0 Jul  8 18:03:59
> doris kernel: [<c021fc10>] ? do_page_fault+0x0/0x370 Jul  8 18:03:59
> doris kernel: [<c021fdc4>] ? do_page_fault+0x1b4/0x370 Jul  8 18:03:59
> doris kernel: [<c02d5b8a>] ? alloc_fd+0xba/0x100 Jul  8 18:03:59 doris
> kernel: [<c02ca976>] ? putname+0x26/0x40 Jul  8 18:03:59 doris kernel:
> [<c02be80e>] ? do_sys_open+0xee/0x110 Jul  8 18:03:59 doris kernel:
> [<c02ce08f>] ? sys_ioctl+0x5f/0x80 Jul  8 18:03:59 doris kernel:
> [<c02be899>] ? sys_open+0x29/0x40 Jul  8 18:03:59 doris kernel:
> [<c0202e13>] ? sysenter_do_call+0x12/0x22 Jul  8 18:03:59 doris kernel:
> Code: 00 00 00 00 8d bf 00 00 00 00 55 85 c0 89 e5 74 1a 8b 40 18 85 d2
> 74 13 85 c0 74 0f b9 02 00 00 00 e8 34 ff ff ff c9 8d 76 00 c3<0f>  0b
> eb fe 8d 74 26 00 8d bc 27 00 00 00 00 55 89 e5 57 31 ff Jul  8
> 18:03:59 doris kernel: EIP: [<c03129e1>] sysfs_create_file+0x21/0x30
> SS:ESP 0068:f68ade90 Jul  8 18:03:59 doris kernel: ---[ end trace
> 3ce86c182470888c ]---
>
>
> No vmlinux specified,
> assuming /lib/modules/2.6.34.1/build/vmlinux
>   c03129c3:      89 e5                   mov    %esp,%ebp           |
> %esp = f68ade90
>   c03129c5:      74 1a                   je     c03129e1
> <sysfs_create_file+0x21>
>   c03129c7:      8b 40 18                mov    0x18(%eax),%eax
>   c03129ca:      85 d2                   test   %edx,%edx           |
> %edx =>  f81587b4
>   c03129cc:      74 13                   je     c03129e1
> <sysfs_create_file+0x21>  c03129ce:      85 c0                   test
> %eax,%eax           |  %eax =>  0 c03129d0:      74 0f
> je     c03129e1<sysfs_create_file+0x21>  c03129d2:      b9 02 00 00
> 00          mov    $0x2,%ecx           |  %ecx =>  f66a72bc
>   c03129d7:      e8 34 ff ff ff          call   c0312910<sysfs_add_file>
>   c03129dc:      c9                      leave
>   c03129dd:      8d 76 00                lea    0x0(%esi),%esi      |
> %esi =>  0 c03129e0:      c3                      ret
> *c03129e1:      0f 0b                   ud2a<--- faulting
> instruction c03129e3:      eb fe                   jmp    c03129e3
> <sysfs_create_file+0x23>  c03129e5:      8d 74 26 00             lea
> 0x0(%esi,%eiz,1),%esi c03129e9:      8d bc 27 00 00 00 00    lea
> 0x0(%edi,%eiz,1),%edi
>
>   c03129f0<sysfs_create_files>:
>   c03129f0:      55                      push   %ebp
>   c03129f1:      89 e5                   mov    %esp,%ebp
>   c03129f3:      57                      push   %edi
>   c03129f4:      31 ff                   xor    %edi,%edi
>   c03129f6:      56                      push   %esi
>   c03129f7:      89 d6                   mov    %edx,%esi
>   c03129f9:      53                      push   %ebx
>   c03129fa:      31 db                   xor    %ebx,%ebx
>   c03129fc:      83 ec 04                sub    $0x4,%esp
>   c03129ff:      89 45 f0                mov    %eax,-0x10(%ebp)
>   c0312a02:      8b 12                   mov    (%edx),%edx
>   c0312a04:      85 d2                   test   %edx,%edx
>   c0312a06:      74 3b                   je     c0312a43
>   <sysfs_create_files+0x53>  c0312a08:      90                      nop
>   c0312a09:      8d b4 26 00 00 00 00    lea    0x0(%esi,%eiz,1),%esi
>   c0312a10:      8b 45 f0                mov    -0x10(%ebp),%eax
>   c0312a13:      e8 a8 ff ff ff          call   c03129c0
>   <sysfs_create_file>
>

