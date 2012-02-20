Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2BTSBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 13:01:15 -0500
Received: from mx2.netapp.com ([216.240.18.37]:15936 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab2BTSBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 13:01:13 -0500
X-IronPort-AV: E=Sophos;i="4.73,452,1325491200"; 
   d="scan'208";a="627043717"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Chris Rankin <rankincj@yahoo.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] NFS dereferenced NULL pointer with 3.2.6 kernel.
Thread-Topic: [OOPS] NFS dereferenced NULL pointer with 3.2.6 kernel.
Thread-Index: AQHM7/mRZhm0NQEJPk2Gnfrz97aHsQ==
Date: Mon, 20 Feb 2012 18:00:44 +0000
Message-ID: <1329760844.2834.1.camel@lade.trondhjem.org>
References: <4F4194C4.40104@yahoo.com>
In-Reply-To: <4F4194C4.40104@yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6BAE63C19FB094C809BF4BD36ABA1A8@tahoe.netapp.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 20 Feb 2012 18:00:45.0868 (UTC) FILETIME=[91C936C0:01CCEFF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1KI1JAa013977

On Mon, 2012-02-20 at 00:33 +0000, Chris Rankin wrote:
> Hi,
> 
> My 3.2.6 (x86, 32 bit) kernel oopsed last night while pulling a file across an 
> NFS mount:
> 
> BUG: unable to handle kernel NULL pointer dereference at   (null)
> IP: [<c107a333>] page_address+0x7/0xa4
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: nfs fuse cpufreq_ondemand p4_clockmod speedstep_lib bnep 
> bluetooth rfkill crc16 ip6t_LOG ipt_LOG nf_conntrack_ipv6 xt_tcpudp 
> nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack max6650 
> ip6table_filter iptable_filter ip6_tables ip_tables x_tables dm_mirror 
> dm_region_hash dm_log dm_mod snd_emu10k1_synth snd_emux_synth snd_seq_virmidi 
> snd_seq_midi_event snd_seq_midi_emul snd_emu10k1 snd_ac97_codec snd_usb_audio 
> ac97_bus snd_seq snd_pcm snd_timer snd_page_alloc snd_util_mem uvcvideo 
> snd_hwdep snd_usbmidi_lib snd_rawmidi snd_seq_device joydev snd usbhid psmouse 
> ppdev videodev parport_pc floppy parport sg firewire_ohci firewire_core pcspkr 
> dcdbas crc_itu_t soundcore serio_raw processor i2c_i801 binfmt_misc nfsd lockd 
> nfs_acl auth_rpcgss sunrpc exportfs uinput ipv6 ext3 jbd mbcache sr_mod sd_mod 
> cdrom sata_sil pata_acpi uhci_hcd ata_piix libata ehci_hcd e1000 scsi_mod 
> usbcore usb_common button radeon intel_agp intel_gtt ttm drm_kms_helper drm 
> agpgart backlight i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect [last unloaded: 
> scsi_wait_scan]
> 
> Pid: 3403, comm: mv Not tainted 3.2.6 #1 Dell Computer Corporation Precision 
> WorkStation 650    /0F1262
> EIP: 0060:[<c107a333>] EFLAGS: 00210206 CPU: 1
> EIP is at page_address+0x7/0xa4
> EAX: 00000000 EBX: f247fde8 ECX: f43df1e4 EDX: 00000038
> ESI: f247fccc EDI: 0000000e EBP: 00000000 ESP: f247fc74
>   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process mv (pid: 3403, ti=f247e000 task=f55c3b00 task.ti=f247e000)
> Stack:
>   f43df1e4 f247fde8 f247fccc 0000000e f2b79c00 f91d006f 00000000 00001000
>   f247fc98 00000000 00000002 f43df074 00000000 00000000 0000006e 00000000
>   f54d8400 f2b79c00 00000000 f91d0008 f84d25ff f43df020 f43df0ac f2b79c04
> Call Trace:
>   [<f91d006f>] ? nfs4_xdr_enc_getacl+0x67/0x86 [nfs]
>   [<f91d0008>] ? nfs4_xdr_enc_fs_locations+0x87/0x87 [nfs]
>   [<f84d25ff>] ? rpcauth_wrap_req+0x72/0x7c [sunrpc]
>   [<f84cc3ef>] ? call_transmit+0x172/0x1dd [sunrpc]
>   [<f84d182e>] ? __rpc_execute+0x59/0x216 [sunrpc]
>   [<c1021a61>] ? add_preempt_count+0x88/0x8a
>   [<c1039936>] ? wake_up_bit+0xb/0x16
>   [<f84cc71b>] ? rpc_run_task+0x57/0x5c [sunrpc]
>   [<f84cc7fb>] ? rpc_call_sync+0x3a/0x54 [sunrpc]
>   [<f91c9164>] ? __nfs4_get_acl_uncached+0x15d/0x1ed [nfs]
>   [<f91cb43a>] ? nfs4_xattr_get_nfs4_acl+0xdf/0x10c [nfs]
>   [<c10abaee>] ? generic_getxattr+0x3b/0x43
>   [<c10abab3>] ? xattr_resolve_name+0x4b/0x4b
>   [<c10abeb1>] ? vfs_getxattr+0x74/0x7b
>   [<c10abf2c>] ? getxattr+0x74/0xc5
>   [<c109fd8c>] ? path_openat+0x2bb/0x2d0
>   [<c107d0b7>] ? handle_pte_fault+0x23b/0x5fc
>   [<c109fe4a>] ? do_filp_open+0x23/0x5c
>   [<c109d1dc>] ? getname_flags+0x20/0xf1
>   [<c1021948>] ? get_parent_ip+0x8/0x19
>   [<c1021948>] ? get_parent_ip+0x8/0x19
>   [<c10219cd>] ? sub_preempt_count+0x74/0x80
>   [<c1021948>] ? get_parent_ip+0x8/0x19
>   [<c1021a61>] ? add_preempt_count+0x88/0x8a
>   [<c1094ede>] ? do_sys_open+0x161/0x16b
>   [<c1094ede>] ? do_sys_open+0x161/0x16b
>   [<c10ac041>] ? listxattr+0x80/0x88
>   [<c10ac5a8>] ? sys_fgetxattr+0x42/0x5a
>   [<c1219b8c>] ? sysenter_do_call+0x12/0x22
> Code: eb 05 bb ea ff ff ff 89 d8 83 c4 20 5b 5e 5f 5d c3 8b 6c 24 18 f7 44 24 44 
> 00 00 01 00 74 86 31 db eb c5 90 55 57 56 53 51 89 c5 <8b> 00 c1 e8 1e c1 e0 0a 
> 05 80 33 2f c1 2b 80 8c 03 00 00 3d 00
> EIP: [<c107a333>] page_address+0x7/0xa4 SS:ESP 0068:f247fc74
> CR2: 0000000000000000
> 
> The remote host was also running 3.2.6, but was x86_64. (I've not had any 
> trouble copying NFS files between two 32 bit 3.2.6 kernels, which is why I'm 
> thinking that the remote host being x86_64 might be significant.)
> 
> For the record, the file was actually copied successfully. After I'd rebooted, I 
> confirmed that the SHA1 sums matched. The "mv" operation obviously failed before 
> the remote copy could be deleted.

It's a known bug. There is a fix at

http://git.linux-nfs.org/?p=trondmy/nfs-2.6.git;a=commit;h=331818f1c468a24e581aedcbe52af799366a9dfe

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
