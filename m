Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab0DSQBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:01:23 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:47830 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab0DSQBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=kveGEuAkBDvD7z8bxi8OINU+1pj7IiFggdcAQLm3G4Bl4VO6B2DTz/kiYK70vMiUS8
         UvBS9b9HfPLGAAX+iWZmAJzzzRM0/VfiCxnohRM1plgOBJAPuoD1nm3LF97PbY3Kch7R
         0nExoEhojc9OrczmMHmPn7GIENz1BW+UGezk8=
Date: Mon, 19 Apr 2010 17:59:50 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.33.2 BUG at exit.c:1027!
Message-ID: <20100419155950.GA14795@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I seem to have some strange luck triggering obscure errors lately and no clue how to fix 
them:(

The problem occurs when compiling kernels so system load is pretty high and high system load seems
essential to repeat. Pretty easilly repeatable (after reboot) in my case. 

It might be something with smsdvb (Siano TV card) which was used in both sessions. Also I have
played with sensors configuration yesterday so the 
   "last sysfs file: /sys/devices/platform/coretemp.1/temp1_label"
might be somehow relevant.

Apr 19 12:06:31 localhost kernel: [11272.310332] kernel BUG at /home/rz/rpmbuild/kernels/linux-2.6.33/kernel/exit.c:1027!
Apr 19 12:06:31 localhost kernel: [11272.310335] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
Apr 19 12:06:31 localhost kernel: [11272.310339] last sysfs file: /sys/devices/platform/coretemp.1/temp1_label
Apr 19 12:06:31 localhost kernel: [11272.310342] Modules linked in: ppp_deflate ppp_async crc_ccitt ppp_generic slhc smsdvb dvb_core smsusb smsmdtv fuse i915 drm_kms_helper drm i2c_algo_bit video output nfsd lockd nfs_acl auth_rpcgss exportfs bridge stp llc bnep sco l2cap bluetooth autofs4 coretemp w83627ehf hwmon_vid hwmon nls_utf8 isofs tun sunrpc xt_multiport nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables ipv6 binfmt_misc loop dm_multipath uinput deflate zlib_deflate ctr twofish twofish_common camellia serpent blowfish cast5 des_generic xcbc rmd160 sha512_generic crypto_null snd_hda_codec_realtek rt2500usb arc4 snd_hda_intel snd_hda_codec ecb snd_seq_dummy snd_seq_oss snd_seq_midi_event rt73usb snd_seq crc_itu_t snd_usb_audio snd_pcm_oss rt2x00usb rt2x00lib snd_hwdep snd_mixer_oss snd_usb_lib snd_pcm mac80211 snd_rawmidi iTCO_wdt iTCO_vendor_support snd_seq_device cfg80211 snd_timer snd intel_agp rfkill soundcore uvcvideo option i2c_i801 agpgar
Apr 19 12:06:31 localhost kernel: t snd_page_alloc led_class psmouse ppdev videodev usbserial v4l1_compat parport_pc r8169 parport i2c_core serio_raw pcspkr mii processor thermal rtc_cmos button ata_generic pata_acpi sha256_generic cbc aes_i586 aes_generic dm_crypt dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ehci_hcd [last unloaded: microcode]
Apr 19 12:06:31 localhost kernel: [11272.310463] 
Apr 19 12:06:31 localhost kernel: [11272.310466] Pid: 6789, comm: gcc Not tainted 2.6.33.2v1 #3 945GCM-S/To Be Filled By O.E.M.
Apr 19 12:06:31 localhost kernel: [11272.310469] EIP: 0060:[<c0438781>] EFLAGS: 00210246 CPU: 1
Apr 19 12:06:31 localhost kernel: [11272.310475] EIP is at do_exit+0x5c7/0x5d5
Apr 19 12:06:31 localhost kernel: [11272.310478] EAX: f6596000 EBX: 00000012 ECX: f4f1c8ec EDX: 00000004
Apr 19 12:06:31 localhost kernel: [11272.310480] ESI: f6597d48 EDI: f4f1c8c0 EBP: f6597f8c ESP: f6597f58
Apr 19 12:06:31 localhost kernel: [11272.310483]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Apr 19 12:06:31 localhost kernel: [11272.310486] Process gcc (pid: 6789, ti=f6596000 task=f4f1c8c0 task.ti=f6596000)
Apr 19 12:06:31 localhost kernel: [11272.310488] Stack:
Apr 19 12:06:31 localhost kernel: [11272.310489]  f6597f74 00000001 f6597f88 f4f1cae4 f4f1cae4 f7040000 f4f1c8b8 f6597f74
Apr 19 12:06:31 localhost kernel: [11272.310496] <0> f6597f74 000000fc f2bef700 f4f1c8c0 00000000 f6597fa4 c04387f1 00000000
Apr 19 12:06:31 localhost kernel: [11272.310503] <0> 00000000 00000000 42a29274 f6597fac c0438827 f6596000 c0738295 00000000
Apr 19 12:06:31 localhost kernel: [11272.310511] Call Trace:
Apr 19 12:06:31 localhost kernel: [11272.310515]  [<c04387f1>] ? do_group_exit+0x62/0x85
Apr 19 12:06:31 localhost kernel: [11272.310518]  [<c0438827>] ? sys_exit_group+0x13/0x17
Apr 19 12:06:31 localhost kernel: [11272.310523]  [<c0738295>] ? syscall_call+0x7/0xb
Apr 19 12:06:31 localhost kernel: [11272.310525] Code: 08 83 bf 78 09 00 00 00 74 07 89 f8 e8 2f 9e 16 00 8b 87 4c 0a 00 00 85 c0 74 05 e8 9c 95 09 00 c7 07 40 00 00 00 e8 68 d5 2f 00 <0f> 0b eb fe bb fe ff ff ff e9 64 ff ff ff 55 89 e5 57 89 c7 56 
Apr 19 12:06:31 localhost kernel: [11272.310566] EIP: [<c0438781>] do_exit+0x5c7/0x5d5 SS:ESP 0068:f6597f58
Apr 19 12:06:31 localhost kernel: [11272.310572] ---[ end trace c53b6d5ea4dccdf1 ]---
Apr 19 12:06:31 localhost kernel: [11272.310575] Fixing recursive fault but reboot is needed!

#####################################
#####################################

Apr 19 16:33:26 localhost kernel: [ 2852.712761] kernel BUG at /home/rz/rpmbuild/kernels/linux-2.6.33/kernel/exit.c:1027!
Apr 19 16:33:26 localhost kernel: [ 2852.712764] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
Apr 19 16:33:26 localhost kernel: [ 2852.712768] last sysfs file: /sys/devices/platform/coretemp.1/temp1_label
Apr 19 16:33:26 localhost kernel: [ 2852.712771] Modules linked in: smsdvb dvb_core smsusb smsmdtv rfcomm fuse i915 drm_kms_helper drm i2c_algo_bit video output nfsd lockd nfs_acl auth_rpcgss exportfs bridge stp llc bnep sco l2cap bluetooth autofs4 coretemp w83627ehf hwmon_vid hwmon nls_utf8 isofs tun sunrpc xt_multiport nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables ipv6 binfmt_misc loop dm_multipath uinput deflate zlib_deflate ctr twofish twofish_common camellia serpent blowfish cast5 des_generic xcbc rmd160 sha512_generic rt2500usb snd_hda_codec_realtek arc4 crypto_null ecb snd_hda_intel snd_hda_codec snd_usb_audio snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq rt73usb crc_itu_t snd_pcm_oss rt2x00usb snd_mixer_oss rt2x00lib snd_pcm snd_hwdep intel_agp snd_usb_lib snd_rawmidi mac80211 iTCO_wdt snd_seq_device snd_timer iTCO_vendor_support snd agpgart option uvcvideo psmouse i2c_i801 cfg80211 usbserial led_class ppdev parport_pc snd_page_all
Apr 19 16:33:26 localhost kernel: oc videodev parport v4l1_compat r8169 soundcore serio_raw rfkill pcspkr i2c_core rtc_cmos mii processor button thermal ata_generic pata_acpi sha256_generic cbc aes_i586 aes_generic dm_crypt dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ehci_hcd [last unloaded: microcode]
Apr 19 16:33:26 localhost kernel: [ 2852.712890] 
Apr 19 16:33:26 localhost kernel: [ 2852.712894] Pid: 5461, comm: objcopy Not tainted 2.6.33.2v1 #3 945GCM-S/To Be Filled By O.E.M.
Apr 19 16:33:26 localhost kernel: [ 2852.712897] EIP: 0060:[<c0438781>] EFLAGS: 00210246 CPU: 1
Apr 19 16:33:26 localhost kernel: [ 2852.712903] EIP is at do_exit+0x5c7/0x5d5
Apr 19 16:33:26 localhost kernel: [ 2852.712905] EAX: de490000 EBX: 00000012 ECX: e8aa002c EDX: 00000004
Apr 19 16:33:26 localhost kernel: [ 2852.712908] ESI: de491d48 EDI: e8aa0000 EBP: de491f8c ESP: de491f58
Apr 19 16:33:26 localhost kernel: [ 2852.712910]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Apr 19 16:33:26 localhost kernel: [ 2852.712913] Process objcopy (pid: 5461, ti=de490000 task=e8aa0000 task.ti=de490000)
Apr 19 16:33:26 localhost kernel: [ 2852.712915] Stack:
Apr 19 16:33:26 localhost kernel: [ 2852.712917]  de491f74 00000001 de491f88 e8aa0224 e8aa0224 f7040000 e8a9fff8 de491f74
Apr 19 16:33:26 localhost kernel: [ 2852.712923] <0> de491f74 000000fc f1a0c500 e8aa0000 00000000 de491fa4 c04387f1 42a2c0d0
Apr 19 16:33:26 localhost kernel: [ 2852.712930] <0> 00000000 00000000 42a29274 de491fac c0438827 de490000 c0738295 00000000
Apr 19 16:33:26 localhost kernel: [ 2852.712938] Call Trace:
Apr 19 16:33:26 localhost kernel: [ 2852.712942]  [<c04387f1>] ? do_group_exit+0x62/0x85
Apr 19 16:33:26 localhost kernel: [ 2852.712945]  [<c0438827>] ? sys_exit_group+0x13/0x17
Apr 19 16:33:26 localhost kernel: [ 2852.712950]  [<c0738295>] ? syscall_call+0x7/0xb
Apr 19 16:33:26 localhost kernel: [ 2852.712952] Code: 08 83 bf 78 09 00 00 00 74 07 89 f8 e8 2f 9e 16 00 8b 87 4c 0a 00 00 85 c0 74 05 e8 9c 95 09 00 c7 07 40 00 00 00 e8 68 d5 2f 00 <0f> 0b eb fe bb fe ff ff ff e9 64 ff ff ff 55 89 e5 57 89 c7 56 
Apr 19 16:33:26 localhost kernel: [ 2852.712993] EIP: [<c0438781>] do_exit+0x5c7/0x5d5 SS:ESP 0068:de491f58
Apr 19 16:33:26 localhost kernel: [ 2852.713000] ---[ end trace 6a7af16f59928a8f ]---
Apr 19 16:33:26 localhost kernel: [ 2852.713002] Fixing recursive fault but reboot is needed!

Richard

##################################

Apr 19 15:46:49 localhost kernel: [    0.000000] Linux version 2.6.33.2v1 (rz@rz) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #3 SMP Thu Apr 8 14:27:58 CEST 2010
Apr 19 15:46:49 localhost kernel: [    0.000000] BIOS-provided physical RAM map:
Apr 19 15:46:49 localhost kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Apr 19 15:46:49 localhost kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Apr 19 15:46:49 localhost kernel: [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
Apr 19 15:46:49 localhost kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7b0000 (usable)
Apr 19 15:46:49 localhost kernel: [    0.000000]  BIOS-e820: 000000007f7b0000 - 000000007f7c0000 (ACPI data)
Apr 19 15:46:49 localhost kernel: [    0.000000]  BIOS-e820: 000000007f7c0000 - 000000007f7f0000 (ACPI NVS)
Apr 19 15:46:49 localhost kernel: [    0.000000]  BIOS-e820: 000000007f7f0000 - 000000007f800000 (reserved)
Apr 19 15:46:49 localhost kernel: [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
Apr 19 15:46:49 localhost kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Apr 19 15:46:49 localhost kernel: [    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
Apr 19 15:46:49 localhost kernel: [    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
Apr 19 15:46:49 localhost kernel: [    0.000000] DMI present.
Apr 19 15:46:49 localhost kernel: [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
Apr 19 15:46:49 localhost kernel: [    0.000000] last_pfn = 0x7f7b0 max_arch_pfn = 0x100000
Apr 19 15:46:49 localhost kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Apr 19 15:46:49 localhost kernel: [    0.000000] found SMP MP-table at [c00ff780] ff780
Apr 19 15:46:49 localhost kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
Apr 19 15:46:49 localhost kernel: [    0.000000] RAMDISK: 37c03000 - 37feff4d
Apr 19 15:46:49 localhost kernel: [    0.000000] Allocated new RAMDISK: 00f3a000 - 01326f4d
Apr 19 15:46:49 localhost kernel: [    0.000000] Move RAMDISK from 0000000037c03000 - 0000000037feff4c to 00f3a000 - 01326f4c
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: RSDP 000fa4f0 00014 (v00 ACPIAM)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: RSDT 7f7b0000 00040 (v01 A_M_I  OEMRSDT  11000817 MSFT 00000097)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: FACP 7f7b0200 00084 (v02 A M I  OEMFACP  12000601 MSFT 00000097)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: DSDT 7f7b0440 0424C (v01  AS154 AS154101 00000101 INTL 02002026)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: FACS 7f7c0000 00040
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: APIC 7f7b0390 0006C (v01 A_M_I  OEMAPIC  11000817 MSFT 00000097)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: MCFG 7f7b0400 0003C (v01 A_M_I  OEMMCFG  11000817 MSFT 00000097)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: OEMB 7f7c0040 00046 (v01 A_M_I  AMI_OEM  11000817 MSFT 00000097)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: AAFT 7f7b4690 00027 (v01 A_M_I  OEMAAFT  11000817 MSFT 00000097)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: HPET 7f7b46c0 00038 (v01 A_M_I  OEMHPET  11000817 MSFT 00000097)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: SSDT 7f7c09b0 00A7C (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
Apr 19 15:46:49 localhost kernel: [    0.000000] 1151MB HIGHMEM available.
Apr 19 15:46:49 localhost kernel: [    0.000000] 887MB LOWMEM available.
Apr 19 15:46:49 localhost kernel: [    0.000000]   mapped low ram: 0 - 377fe000
Apr 19 15:46:49 localhost kernel: [    0.000000]   low ram: 0 - 377fe000
Apr 19 15:46:49 localhost kernel: [    0.000000]   node 0 low ram: 00000000 - 377fe000
Apr 19 15:46:49 localhost kernel: [    0.000000]   node 0 bootmap 00015000 - 0001bf00
Apr 19 15:46:49 localhost kernel: [    0.000000] (14 early reservations) ==> bootmem [0000000000 - 00377fe000]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #2 [0000400000 - 0000f33afc]    TEXT DATA BSS ==> [0000400000 - 0000f33afc]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #3 [0000f34000 - 0000f3912f]              BRK ==> [0000f34000 - 0000f3912f]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #4 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #5 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #6 [000009fc00 - 00000e0000]    BIOS reserved ==> [000009fc00 - 00000e0000]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #7 [00000e0144 - 00000ff780]    BIOS reserved ==> [00000e0144 - 00000ff780]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #8 [00000e0000 - 00000e0144]     MP-table mpc ==> [00000e0000 - 00000e0144]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #9 [0000010000 - 0000011000]       TRAMPOLINE ==> [0000010000 - 0000011000]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #10 [0000011000 - 0000015000]      ACPI WAKEUP ==> [0000011000 - 0000015000]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #11 [0000100000 - 00001d9000]          PGTABLE ==> [0000100000 - 00001d9000]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #12 [0000f3a000 - 0001326f4d]      NEW RAMDISK ==> [0000f3a000 - 0001326f4d]
Apr 19 15:46:49 localhost kernel: [    0.000000]   #13 [0000015000 - 000001c000]          BOOTMAP ==> [0000015000 - 000001c000]
Apr 19 15:46:49 localhost kernel: [    0.000000] Zone PFN ranges:
Apr 19 15:46:49 localhost kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Apr 19 15:46:49 localhost kernel: [    0.000000]   Normal   0x00001000 -> 0x000377fe
Apr 19 15:46:49 localhost kernel: [    0.000000]   HighMem  0x000377fe -> 0x0007f7b0
Apr 19 15:46:49 localhost kernel: [    0.000000] Movable zone start PFN for each node
Apr 19 15:46:49 localhost kernel: [    0.000000] early_node_map[2] active PFN ranges
Apr 19 15:46:49 localhost kernel: [    0.000000]     0: 0x00000010 -> 0x0000009f
Apr 19 15:46:49 localhost kernel: [    0.000000]     0: 0x00000100 -> 0x0007f7b0
Apr 19 15:46:49 localhost kernel: [    0.000000] Using APIC driver default
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x808
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Apr 19 15:46:49 localhost kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Apr 19 15:46:49 localhost kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Apr 19 15:46:49 localhost kernel: [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
Apr 19 15:46:49 localhost kernel: [    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
Apr 19 15:46:49 localhost kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Apr 19 15:46:49 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
Apr 19 15:46:49 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Apr 19 15:46:49 localhost kernel: [    0.000000] Allocating PCI resources starting at 7f800000 (gap: 7f800000:7f500000)
Apr 19 15:46:49 localhost kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
Apr 19 15:46:49 localhost kernel: [    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
Apr 19 15:46:49 localhost kernel: [    0.000000] PERCPU: Embedded 14 pages/cpu @c2400000 s35160 r0 d22184 u1048576
Apr 19 15:46:49 localhost kernel: [    0.000000] pcpu-alloc: s35160 r0 d22184 u1048576 alloc=1*4194304
Apr 19 15:46:49 localhost kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3 
Apr 19 15:46:49 localhost kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517967
Apr 19 15:46:49 localhost kernel: [    0.000000] Kernel command line: ro root=/dev/mapper/luks-945154b7-c0e5-40b1-8947-25673735c9c0 no_console_suspend
Apr 19 15:46:49 localhost kernel: [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
Apr 19 15:46:49 localhost kernel: [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Apr 19 15:46:49 localhost kernel: [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Apr 19 15:46:49 localhost kernel: [    0.000000] Enabling fast FPU save and restore... done.
Apr 19 15:46:49 localhost kernel: [    0.000000] Enabling unmasked SIMD FPU exception support... done.
Apr 19 15:46:49 localhost kernel: [    0.000000] Initializing CPU#0
Apr 19 15:46:49 localhost kernel: [    0.000000] allocated 10442880 bytes of page_cgroup
Apr 19 15:46:49 localhost kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Apr 19 15:46:49 localhost kernel: [    0.000000] Initializing HighMem for node 0 (000377fe:0007f7b0)
Apr 19 15:46:49 localhost kernel: [    0.000000] Memory: 2042944k/2088640k available (3315k kernel code, 44060k reserved, 2149k data, 404k init, 1179336k highmem)
Apr 19 15:46:49 localhost kernel: [    0.000000] virtual kernel memory layout:
Apr 19 15:46:49 localhost kernel: [    0.000000]     fixmap  : 0xfff6a000 - 0xfffff000   ( 596 kB)
Apr 19 15:46:49 localhost kernel: [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Apr 19 15:46:49 localhost kernel: [    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
Apr 19 15:46:49 localhost kernel: [    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
Apr 19 15:46:49 localhost kernel: [    0.000000]       .init : 0xc0957000 - 0xc09bc000   ( 404 kB)
Apr 19 15:46:49 localhost kernel: [    0.000000]       .data : 0xc073ce0e - 0xc095629c   (2149 kB)
Apr 19 15:46:49 localhost kernel: [    0.000000]       .text : 0xc0400000 - 0xc073ce0e   (3315 kB)
Apr 19 15:46:49 localhost kernel: [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Apr 19 15:46:49 localhost kernel: [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Apr 19 15:46:49 localhost kernel: [    0.000000] Hierarchical RCU implementation.
Apr 19 15:46:49 localhost kernel: [    0.000000] RCU-based detection of stalled CPUs is enabled.
Apr 19 15:46:49 localhost kernel: [    0.000000] NR_IRQS:384
Apr 19 15:46:49 localhost kernel: [    0.000000] Console: colour VGA+ 80x25
Apr 19 15:46:49 localhost kernel: [    0.000000] console [tty0] enabled
Apr 19 15:46:49 localhost kernel: [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Apr 19 15:46:49 localhost kernel: [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
Apr 19 15:46:49 localhost kernel: [    0.000000] ... MAX_LOCK_DEPTH:          48
Apr 19 15:46:49 localhost kernel: [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
Apr 19 15:46:49 localhost kernel: [    0.000000] ... CLASSHASH_SIZE:          4096
Apr 19 15:46:49 localhost kernel: [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
Apr 19 15:46:49 localhost kernel: [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
Apr 19 15:46:49 localhost kernel: [    0.000000] ... CHAINHASH_SIZE:          16384
Apr 19 15:46:49 localhost kernel: [    0.000000]  memory used by lock dependency info: 3567 kB
Apr 19 15:46:49 localhost kernel: [    0.000000]  per task-struct memory footprint: 1152 bytes
Apr 19 15:46:49 localhost kernel: [    0.000000] Fast TSC calibration using PIT
Apr 19 15:46:49 localhost kernel: [    0.000000] Detected 2493.098 MHz processor.
Apr 19 15:46:49 localhost kernel: [    0.001011] Calibrating delay loop (skipped), value calculated using timer frequency.. 4986.19 BogoMIPS (lpj=2493098)
Apr 19 15:46:49 localhost kernel: [    0.001210] Security Framework initialized
Apr 19 15:46:49 localhost kernel: [    0.001299] SELinux:  Initializing.
Apr 19 15:46:49 localhost kernel: [    0.001439] Mount-cache hash table entries: 512
Apr 19 15:46:49 localhost kernel: [    0.002782] Initializing cgroup subsys ns
Apr 19 15:46:49 localhost kernel: [    0.002868] Initializing cgroup subsys cpuacct
Apr 19 15:46:49 localhost kernel: [    0.002956] Initializing cgroup subsys memory
Apr 19 15:46:49 localhost kernel: [    0.003032] Initializing cgroup subsys devices
Apr 19 15:46:49 localhost kernel: [    0.003115] Initializing cgroup subsys freezer
Apr 19 15:46:49 localhost kernel: [    0.003247] CPU: Physical Processor ID: 0
Apr 19 15:46:49 localhost kernel: [    0.003329] CPU: Processor Core ID: 0
Apr 19 15:46:49 localhost kernel: [    0.003414] mce: CPU supports 6 MCE banks
Apr 19 15:46:49 localhost kernel: [    0.003503] CPU0: Thermal monitoring enabled (TM2)
Apr 19 15:46:49 localhost kernel: [    0.003588] using mwait in idle threads.
Apr 19 15:46:49 localhost kernel: [    0.003675] Performance Events: Core2 events, Intel PMU driver.
Apr 19 15:46:49 localhost kernel: [    0.003812] ... version:                2
Apr 19 15:46:49 localhost kernel: [    0.003894] ... bit width:              40
Apr 19 15:46:49 localhost kernel: [    0.004004] ... generic registers:      2
Apr 19 15:46:49 localhost kernel: [    0.004086] ... value mask:             000000ffffffffff
Apr 19 15:46:49 localhost kernel: [    0.004170] ... max period:             000000007fffffff
Apr 19 15:46:49 localhost kernel: [    0.004253] ... fixed-purpose events:   3
Apr 19 15:46:49 localhost kernel: [    0.004335] ... event mask:             0000000700000003
Apr 19 15:46:49 localhost kernel: [    0.004420] Checking 'hlt' instruction... OK.
Apr 19 15:46:49 localhost kernel: [    0.009400] ACPI: Core revision 20091214
Apr 19 15:46:49 localhost kernel: [    0.018154] Enabling APIC mode:  Flat.  Using 1 I/O APICs
Apr 19 15:46:49 localhost kernel: [    0.018573] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Apr 19 15:46:49 localhost kernel: [    0.028756] CPU0: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 06
Apr 19 15:46:49 localhost kernel: [    0.028999] lockdep: fixing up alternatives.
Apr 19 15:46:49 localhost kernel: [    0.028999] Booting Node   0, Processors  #1
Apr 19 15:46:49 localhost kernel: [    0.001999] Initializing CPU#1
Apr 19 15:46:49 localhost kernel: [    0.100070] Brought up 2 CPUs
Apr 19 15:46:49 localhost kernel: [    0.100312] Total of 2 processors activated (9972.22 BogoMIPS).
Apr 19 15:46:49 localhost kernel: [    0.102129] regulator: core version 0.5
Apr 19 15:46:49 localhost kernel: [    0.102165] Time: 13:45:54  Date: 04/19/10
Apr 19 15:46:49 localhost kernel: [    0.102194] NET: Registered protocol family 16
Apr 19 15:46:49 localhost kernel: [    0.103203] ACPI: bus type pci registered
Apr 19 15:46:49 localhost kernel: [    0.104064] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Apr 19 15:46:49 localhost kernel: [    0.104193] PCI: Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub with MMCONFIG support
Apr 19 15:46:49 localhost kernel: [    0.105051] PCI: not using MMCONFIG
Apr 19 15:46:49 localhost kernel: [    0.105295] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
Apr 19 15:46:49 localhost kernel: [    0.105380] PCI: Using configuration type 1 for base access
Apr 19 15:46:49 localhost kernel: [    0.111067] bio: create slab <bio-0> at 0
Apr 19 15:46:49 localhost kernel: [    0.120361] ACPI: Executed 1 blocks of module-level executable AML code
Apr 19 15:46:49 localhost kernel: [    0.126906] ACPI: Interpreter enabled
Apr 19 15:46:49 localhost kernel: [    0.126995] ACPI: (supports S0 S1 S3 S4 S5)
Apr 19 15:46:49 localhost kernel: [    0.127205] ACPI: Using IOAPIC for interrupt routing
Apr 19 15:46:49 localhost kernel: [    0.141074] ACPI Warning: Incorrect checksum in table [OEMB] - 85, should be 80 (20091214/tbutils-314)
Apr 19 15:46:49 localhost kernel: [    0.141513] ACPI: No dock devices found.
Apr 19 15:46:49 localhost kernel: [    0.142064] ACPI: PCI Root Bridge [PCI0] (0000:00)
Apr 19 15:46:49 localhost kernel: [    0.142235] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
Apr 19 15:46:49 localhost kernel: [    0.143614] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
Apr 19 15:46:49 localhost kernel: [    0.143758] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
Apr 19 15:46:49 localhost kernel: [    0.143848] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0280 (mask 00ff)
Apr 19 15:46:49 localhost kernel: [    0.144312] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
Apr 19 15:46:49 localhost kernel: [    0.146095] pci 0000:00:1c.1: PCI bridge to [bus 01-01]
Apr 19 15:46:49 localhost kernel: [    0.146255] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
Apr 19 15:46:49 localhost kernel: [    0.160144] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Apr 19 15:46:49 localhost kernel: [    0.160584] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
Apr 19 15:46:49 localhost kernel: [    0.161117] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
Apr 19 15:46:49 localhost kernel: [    0.161556] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Apr 19 15:46:49 localhost kernel: [    0.162016] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Apr 19 15:46:49 localhost kernel: [    0.162552] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Apr 19 15:46:49 localhost kernel: [    0.163095] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Apr 19 15:46:49 localhost kernel: [    0.163631] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 *15)
Apr 19 15:46:49 localhost kernel: [    0.164181] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Apr 19 15:46:49 localhost kernel: [    0.164217] vgaarb: loaded
Apr 19 15:46:49 localhost kernel: [    0.165054] SCSI subsystem initialized
Apr 19 15:46:49 localhost kernel: [    0.165164] usbcore: registered new interface driver usbfs
Apr 19 15:46:49 localhost kernel: [    0.165164] usbcore: registered new interface driver hub
Apr 19 15:46:49 localhost kernel: [    0.165164] usbcore: registered new device driver usb
Apr 19 15:46:49 localhost kernel: [    0.166077] PCI: Using ACPI for IRQ routing
Apr 19 15:46:49 localhost kernel: [    0.166258] NetLabel: Initializing
Apr 19 15:46:49 localhost kernel: [    0.166258] NetLabel:  domain hash size = 128
Apr 19 15:46:49 localhost kernel: [    0.166303] NetLabel:  protocols = UNLABELED CIPSOv4
Apr 19 15:46:49 localhost kernel: [    0.167049] NetLabel:  unlabeled traffic allowed by default
Apr 19 15:46:49 localhost kernel: [    0.167137] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Apr 19 15:46:49 localhost kernel: [    0.167226] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Apr 19 15:46:49 localhost kernel: [    0.167390] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Apr 19 15:46:49 localhost kernel: [    0.170113] Switching to clocksource tsc
Apr 19 15:46:49 localhost kernel: [    0.177514] pnp: PnP ACPI init
Apr 19 15:46:49 localhost kernel: [    0.177628] ACPI: bus type pnp registered
Apr 19 15:46:49 localhost kernel: [    0.183930] pnp: PnP ACPI: found 18 devices
Apr 19 15:46:49 localhost kernel: [    0.184014] ACPI: ACPI bus type pnp unregistered
Apr 19 15:46:49 localhost kernel: [    0.184113] system 00:01: [mem 0xfed13000-0xfed19fff] has been reserved
Apr 19 15:46:49 localhost kernel: [    0.184209] system 00:07: [io  0x04d0-0x04d1] has been reserved
Apr 19 15:46:49 localhost kernel: [    0.184294] system 00:07: [io  0x0800-0x087f] has been reserved
Apr 19 15:46:49 localhost kernel: [    0.184382] system 00:07: [io  0x0480-0x04bf] has been reserved
Apr 19 15:46:49 localhost kernel: [    0.184465] system 00:07: [io  0x0900-0x090f] has been reserved
Apr 19 15:46:49 localhost kernel: [    0.184552] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
Apr 19 15:46:49 localhost kernel: [    0.184659] system 00:07: [mem 0xfed20000-0xfed8ffff] has been reserved
Apr 19 15:46:49 localhost kernel: [    0.184754] system 00:0a: [mem 0xffc00000-0xfff7ffff] has been reserved
Apr 19 15:46:49 localhost kernel: [    0.184846] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
Apr 19 15:46:49 localhost kernel: [    0.184933] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
Apr 19 15:46:49 localhost kernel: [    0.185027] system 00:0f: [io  0x0290-0x029f] has been reserved
Apr 19 15:46:49 localhost kernel: [    0.185118] system 00:10: [mem 0xe0000000-0xefffffff] has been reserved
Apr 19 15:46:49 localhost kernel: [    0.185210] system 00:11: [mem 0x00000000-0x0009ffff] could not be reserved
Apr 19 15:46:49 localhost kernel: [    0.185297] system 00:11: [mem 0x000c0000-0x000cffff] could not be reserved
Apr 19 15:46:49 localhost kernel: [    0.185383] system 00:11: [mem 0x000e0000-0x000fffff] could not be reserved
Apr 19 15:46:49 localhost kernel: [    0.185470] system 00:11: [mem 0x00100000-0x7f7fffff] could not be reserved
Apr 19 15:46:49 localhost kernel: [    0.221136] pci 0000:00:1c.0: BAR 8: assigned [mem 0x80000000-0x803fffff]
Apr 19 15:46:49 localhost kernel: [    0.221220] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
Apr 19 15:46:49 localhost kernel: [    0.221302] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
Apr 19 15:46:49 localhost kernel: [    0.221385] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
Apr 19 15:46:49 localhost kernel: [    0.221470] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x803fffff]
Apr 19 15:46:49 localhost kernel: [    0.221555] pci 0000:00:1c.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
Apr 19 15:46:49 localhost kernel: [    0.221769] pci 0000:00:1c.1: PCI bridge to [bus 01-01]
Apr 19 15:46:49 localhost kernel: [    0.221851] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
Apr 19 15:46:49 localhost kernel: [    0.221939] pci 0000:00:1c.1:   bridge window [mem 0xfeb00000-0xfebfffff]
Apr 19 15:46:49 localhost kernel: [    0.222027] pci 0000:00:1c.1:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
Apr 19 15:46:49 localhost kernel: [    0.222176] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
Apr 19 15:46:49 localhost kernel: [    0.222259] pci 0000:00:1e.0:   bridge window [io  disabled]
Apr 19 15:46:49 localhost kernel: [    0.222346] pci 0000:00:1e.0:   bridge window [mem disabled]
Apr 19 15:46:49 localhost kernel: [    0.222433] pci 0000:00:1e.0:   bridge window [mem pref disabled]
Apr 19 15:46:49 localhost kernel: [    0.222530] pci 0000:00:1c.0: enabling device (0106 -> 0107)
Apr 19 15:46:49 localhost kernel: [    0.222629] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Apr 19 15:46:49 localhost kernel: [    0.222730] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Apr 19 15:46:49 localhost kernel: [    0.222882] NET: Registered protocol family 2
Apr 19 15:46:49 localhost kernel: [    0.223078] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Apr 19 15:46:49 localhost kernel: [    0.223455] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Apr 19 15:46:49 localhost kernel: [    0.224225] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
Apr 19 15:46:49 localhost kernel: [    0.228916] TCP: Hash tables configured (established 131072 bind 65536)
Apr 19 15:46:49 localhost kernel: [    0.229072] TCP reno registered
Apr 19 15:46:49 localhost kernel: [    0.229174] UDP hash table entries: 512 (order: 3, 40960 bytes)
Apr 19 15:46:49 localhost kernel: [    0.229341] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
Apr 19 15:46:49 localhost kernel: [    0.229732] NET: Registered protocol family 1
Apr 19 15:46:49 localhost kernel: [    0.230248] Trying to unpack rootfs image as initramfs...
Apr 19 15:46:49 localhost kernel: [    0.331471] debug: unmapping init memory c0f3a000..c1327000
Apr 19 15:46:49 localhost kernel: [    0.333587] audit: initializing netlink socket (disabled)
Apr 19 15:46:49 localhost kernel: [    0.333708] type=2000 audit(1271684753.333:1): initialized
Apr 19 15:46:49 localhost kernel: [    0.341067] highmem bounce pool size: 64 pages
Apr 19 15:46:49 localhost kernel: [    0.341154] HugeTLB registered 4 MB page size, pre-allocated 0 pages
Apr 19 15:46:49 localhost kernel: [    0.346695] VFS: Disk quotas dquot_6.5.2
Apr 19 15:46:49 localhost kernel: [    0.346884] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Apr 19 15:46:49 localhost kernel: [    0.348669] msgmni has been set to 1689
Apr 19 15:46:49 localhost kernel: [    0.349782] alg: No test for stdrng (krng)
Apr 19 15:46:49 localhost kernel: [    0.350042] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Apr 19 15:46:49 localhost kernel: [    0.350192] io scheduler noop registered
Apr 19 15:46:49 localhost kernel: [    0.350271] io scheduler deadline registered
Apr 19 15:46:49 localhost kernel: [    0.350471] io scheduler cfq registered (default)
Apr 19 15:46:49 localhost kernel: [    0.351627] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Apr 19 15:46:49 localhost kernel: [    0.358550] Non-volatile memory driver v1.3
Apr 19 15:46:49 localhost kernel: [    0.358736] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Apr 19 15:46:49 localhost kernel: [    0.602860] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Apr 19 15:46:49 localhost kernel: [    0.604099] 00:0e: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Apr 19 15:46:49 localhost kernel: [    0.608151] brd: module loaded
Apr 19 15:46:49 localhost kernel: [    0.608372] input: Macintosh mouse button emulation as /devices/virtual/input/input0
Apr 19 15:46:49 localhost kernel: [    0.608520] Uniform Multi-Platform E-IDE driver
Apr 19 15:46:49 localhost kernel: [    0.608959] ide-gd driver 1.18
Apr 19 15:46:49 localhost kernel: [    0.609534] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Apr 19 15:46:49 localhost kernel: [    0.609826] scsi0 : ata_piix
Apr 19 15:46:49 localhost kernel: [    0.610231] scsi1 : ata_piix
Apr 19 15:46:49 localhost kernel: [    0.612643] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
Apr 19 15:46:49 localhost kernel: [    0.612731] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
Apr 19 15:46:49 localhost kernel: [    0.612858] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Apr 19 15:46:49 localhost kernel: [    0.612955] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
Apr 19 15:46:49 localhost kernel: [    0.613302] scsi2 : ata_piix
Apr 19 15:46:49 localhost kernel: [    0.613612] scsi3 : ata_piix
Apr 19 15:46:49 localhost kernel: [    0.613854] ata3: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xc800 irq 19
Apr 19 15:46:49 localhost kernel: [    0.613941] ata4: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc808 irq 19
Apr 19 15:46:49 localhost kernel: [    0.614426] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Apr 19 15:46:49 localhost kernel: [    0.614596] uhci_hcd: USB Universal Host Controller Interface driver
Apr 19 15:46:49 localhost kernel: [    0.614721] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Apr 19 15:46:49 localhost kernel: [    0.614816] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Apr 19 15:46:49 localhost kernel: [    0.615670] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
Apr 19 15:46:49 localhost kernel: [    0.615820] uhci_hcd 0000:00:1d.0: detected 2 ports
Apr 19 15:46:49 localhost kernel: [    0.615939] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
Apr 19 15:46:49 localhost kernel: [    0.616178] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Apr 19 15:46:49 localhost kernel: [    0.616264] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 19 15:46:49 localhost kernel: [    0.616407] usb usb1: Product: UHCI Host Controller
Apr 19 15:46:49 localhost kernel: [    0.616489] usb usb1: Manufacturer: Linux 2.6.33.2v1 uhci_hcd
Apr 19 15:46:49 localhost kernel: [    0.616581] usb usb1: SerialNumber: 0000:00:1d.0
Apr 19 15:46:49 localhost kernel: [    0.617311] hub 1-0:1.0: USB hub found
Apr 19 15:46:49 localhost kernel: [    0.617432] hub 1-0:1.0: 2 ports detected
Apr 19 15:46:49 localhost kernel: [    0.617833] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Apr 19 15:46:49 localhost kernel: [    0.617926] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Apr 19 15:46:49 localhost kernel: [    0.618134] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
Apr 19 15:46:49 localhost kernel: [    0.618283] uhci_hcd 0000:00:1d.1: detected 2 ports
Apr 19 15:46:49 localhost kernel: [    0.618389] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d480
Apr 19 15:46:49 localhost kernel: [    0.618536] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
Apr 19 15:46:49 localhost kernel: [    0.618629] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 19 15:46:49 localhost kernel: [    0.618773] usb usb2: Product: UHCI Host Controller
Apr 19 15:46:49 localhost kernel: [    0.618856] usb usb2: Manufacturer: Linux 2.6.33.2v1 uhci_hcd
Apr 19 15:46:49 localhost kernel: [    0.618941] usb usb2: SerialNumber: 0000:00:1d.1
Apr 19 15:46:49 localhost kernel: [    0.619285] hub 2-0:1.0: USB hub found
Apr 19 15:46:49 localhost kernel: [    0.619372] hub 2-0:1.0: 2 ports detected
Apr 19 15:46:49 localhost kernel: [    0.619574] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Apr 19 15:46:49 localhost kernel: [    0.619668] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Apr 19 15:46:49 localhost kernel: [    0.619914] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
Apr 19 15:46:49 localhost kernel: [    0.620056] uhci_hcd 0000:00:1d.2: detected 2 ports
Apr 19 15:46:49 localhost kernel: [    0.620171] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d800
Apr 19 15:46:49 localhost kernel: [    0.620320] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Apr 19 15:46:49 localhost kernel: [    0.620403] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 19 15:46:49 localhost kernel: [    0.620540] usb usb3: Product: UHCI Host Controller
Apr 19 15:46:49 localhost kernel: [    0.620634] usb usb3: Manufacturer: Linux 2.6.33.2v1 uhci_hcd
Apr 19 15:46:49 localhost kernel: [    0.620716] usb usb3: SerialNumber: 0000:00:1d.2
Apr 19 15:46:49 localhost kernel: [    0.621029] hub 3-0:1.0: USB hub found
Apr 19 15:46:49 localhost kernel: [    0.621113] hub 3-0:1.0: 2 ports detected
Apr 19 15:46:49 localhost kernel: [    0.621292] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
Apr 19 15:46:49 localhost kernel: [    0.623194] uhci_hcd 0000:00:1d.3: UHCI Host Controller
Apr 19 15:46:49 localhost kernel: [    0.623421] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
Apr 19 15:46:49 localhost kernel: [    0.623576] uhci_hcd 0000:00:1d.3: detected 2 ports
Apr 19 15:46:49 localhost kernel: [    0.623693] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d880
Apr 19 15:46:49 localhost kernel: [    0.623837] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Apr 19 15:46:49 localhost kernel: [    0.623923] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 19 15:46:49 localhost kernel: [    0.624066] usb usb4: Product: UHCI Host Controller
Apr 19 15:46:49 localhost kernel: [    0.624149] usb usb4: Manufacturer: Linux 2.6.33.2v1 uhci_hcd
Apr 19 15:46:49 localhost kernel: [    0.624233] usb usb4: SerialNumber: 0000:00:1d.3
Apr 19 15:46:49 localhost kernel: [    0.624572] hub 4-0:1.0: USB hub found
Apr 19 15:46:49 localhost kernel: [    0.624659] hub 4-0:1.0: 2 ports detected
Apr 19 15:46:49 localhost kernel: [    0.625086] usbcore: registered new interface driver libusual
Apr 19 15:46:49 localhost kernel: [    0.625339] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Apr 19 15:46:49 localhost kernel: [    0.628050] serio: i8042 KBD port at 0x60,0x64 irq 1
Apr 19 15:46:49 localhost kernel: [    0.628160] serio: i8042 AUX port at 0x60,0x64 irq 12
Apr 19 15:46:49 localhost kernel: [    0.628775] mice: PS/2 mouse device common for all mice
Apr 19 15:46:49 localhost kernel: [    0.629050] cpuidle: using governor ladder
Apr 19 15:46:49 localhost kernel: [    0.629138] cpuidle: using governor menu
Apr 19 15:46:49 localhost kernel: [    0.629552] usbcore: registered new interface driver hiddev
Apr 19 15:46:49 localhost kernel: [    0.629729] usbcore: registered new interface driver usbhid
Apr 19 15:46:49 localhost kernel: [    0.629813] usbhid: USB HID core driver
Apr 19 15:46:49 localhost kernel: [    0.630095] NET: Registered protocol family 17
Apr 19 15:46:49 localhost kernel: [    0.630228] NET: Registered protocol family 15
Apr 19 15:46:49 localhost kernel: [    0.630344] Using IPI No-Shortcut mode
Apr 19 15:46:49 localhost kernel: [    0.630767] registered taskstats version 1
Apr 19 15:46:49 localhost kernel: [    0.630851] No TPM chip found, activating TPM-bypass!
Apr 19 15:46:49 localhost kernel: [    0.631469]   Magic number: 6:30:787
Apr 19 15:46:49 localhost kernel: [    0.648460] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
Apr 19 15:46:49 localhost kernel: [    0.768864] ata3.00: ATA-8: ExcelStor Technology J9250S, GM2OA52A, max UDMA/133
Apr 19 15:46:49 localhost kernel: [    0.769007] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Apr 19 15:46:49 localhost kernel: [    0.771078] ata4.00: ATAPI: ATAPI   iHAS322   8, 3L13, max UDMA/100
Apr 19 15:46:49 localhost kernel: [    0.771513] ata1.00: ATA-5: IC35L060AVER07-0, ER6OA46A, max UDMA/100
Apr 19 15:46:49 localhost kernel: [    0.771606] ata1.00: 120103200 sectors, multi 16: LBA 
Apr 19 15:46:49 localhost kernel: [    0.774874] ata3.00: configured for UDMA/133
Apr 19 15:46:49 localhost kernel: [    0.776980] ata4.00: configured for UDMA/100
Apr 19 15:46:49 localhost kernel: [    0.780129] ata1.00: configured for UDMA/100
Apr 19 15:46:49 localhost kernel: [    0.780674] scsi 0:0:0:0: Direct-Access     ATA      IC35L060AVER07-0 ER6O PQ: 0 ANSI: 5
Apr 19 15:46:49 localhost kernel: [    0.781551] sd 0:0:0:0: [sda] 120103200 512-byte logical blocks: (61.4 GB/57.2 GiB)
Apr 19 15:46:49 localhost kernel: [    0.781807] sd 0:0:0:0: [sda] Write Protect is off
Apr 19 15:46:49 localhost kernel: [    0.781936] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 19 15:46:49 localhost kernel: [    0.781994] sd 0:0:0:0: Attached scsi generic sg0 type 0
Apr 19 15:46:49 localhost kernel: [    0.782567] scsi 2:0:0:0: Direct-Access     ATA      ExcelStor Techno GM2O PQ: 0 ANSI: 5
Apr 19 15:46:49 localhost kernel: [    0.783099] sd 2:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
Apr 19 15:46:49 localhost kernel: [    0.783111]  sda:
Apr 19 15:46:49 localhost kernel: [    0.783411] sd 2:0:0:0: [sdb] Write Protect is off
Apr 19 15:46:49 localhost kernel: [    0.783459] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 19 15:46:49 localhost kernel: [    0.783755] sd 2:0:0:0: Attached scsi generic sg1 type 0
Apr 19 15:46:49 localhost kernel: [    0.783760]  sdb:
Apr 19 15:46:49 localhost kernel: [    0.785253] scsi 3:0:0:0: CD-ROM            ATAPI    iHAS322   8      3L13 PQ: 0 ANSI: 5
Apr 19 15:46:49 localhost kernel: [    0.789839]  sda1 sda2 sda3 sda4 <sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
Apr 19 15:46:49 localhost kernel: [    0.792449] Uniform CD-ROM driver Revision: 3.20
Apr 19 15:46:49 localhost kernel: [    0.793115] sr 3:0:0:0: Attached scsi generic sg2 type 5
Apr 19 15:46:49 localhost kernel: [    0.795151]  sdb1 sdb2
Apr 19 15:46:49 localhost kernel: [    0.796065] sd 2:0:0:0: [sdb] Attached SCSI disk
Apr 19 15:46:49 localhost kernel: [    0.804189]  sda5 sda6
Apr 19 15:46:49 localhost kernel: [    0.819137]  sda7 sda8 sda9 >
Apr 19 15:46:49 localhost kernel: [    0.837603] sd 0:0:0:0: [sda] Attached SCSI disk
Apr 19 15:46:49 localhost kernel: [    0.837698] debug: unmapping init memory c0957000..c09bc000
Apr 19 15:46:49 localhost kernel: [    0.837849] Write protecting the kernel text: 3316k
Apr 19 15:46:49 localhost kernel: [    0.837955] Write protecting the kernel read-only data: 1796k
Apr 19 15:46:49 localhost kernel: [    0.920705] usb 1-1: new full speed USB device using uhci_hcd and address 2
Apr 19 15:46:49 localhost kernel: [    1.204069] usb 1-1: New USB device found, idVendor=148f, idProduct=2573
Apr 19 15:46:49 localhost kernel: [    1.204163] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Apr 19 15:46:49 localhost kernel: [    1.204249] usb 1-1: Product: 54M.USB.......
Apr 19 15:46:49 localhost kernel: [    1.204332] usb 1-1: Manufacturer: Ralink
Apr 19 15:46:49 localhost kernel: [    1.309020] usb 2-1: new full speed USB device using uhci_hcd and address 2
Apr 19 15:46:49 localhost kernel: [    1.457550] usb 2-1: New USB device found, idVendor=19d2, idProduct=0063
Apr 19 15:46:49 localhost kernel: [    1.457637] usb 2-1: New USB device strings: Mfr=2, Product=1, SerialNumber=0
Apr 19 15:46:49 localhost kernel: [    1.457723] usb 2-1: Product: ZTE CDMA Technologies MSM
Apr 19 15:46:49 localhost kernel: [    1.457807] usb 2-1: Manufacturer: ZTE,Incorporated
Apr 19 15:46:49 localhost kernel: [    1.564021] usb 3-1: new full speed USB device using uhci_hcd and address 2
Apr 19 15:46:49 localhost kernel: [    1.660426] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Apr 19 15:46:49 localhost kernel: [    1.660512] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
Apr 19 15:46:49 localhost kernel: [    1.660717] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Apr 19 15:46:49 localhost kernel: [    1.660822] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Apr 19 15:46:49 localhost kernel: [    1.661065] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
Apr 19 15:46:49 localhost kernel: [    1.661238] ehci_hcd 0000:00:1d.7: using broken periodic workaround
Apr 19 15:46:49 localhost kernel: [    1.661334] ehci_hcd 0000:00:1d.7: debug port 1
Apr 19 15:46:49 localhost kernel: [    1.665307] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfea37c00
Apr 19 15:46:49 localhost kernel: [    1.675014] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Apr 19 15:46:49 localhost kernel: [    1.675218] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 19 15:46:49 localhost kernel: [    1.675304] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 19 15:46:49 localhost kernel: [    1.675451] usb usb5: Product: EHCI Host Controller
Apr 19 15:46:49 localhost kernel: [    1.675535] usb usb5: Manufacturer: Linux 2.6.33.2v1 ehci_hcd
Apr 19 15:46:49 localhost kernel: [    1.675619] usb usb5: SerialNumber: 0000:00:1d.7
Apr 19 15:46:49 localhost kernel: [    1.675893] hub 5-0:1.0: USB hub found
Apr 19 15:46:49 localhost kernel: [    1.675978] hub 5-0:1.0: 8 ports detected
Apr 19 15:46:49 localhost kernel: [    1.997491] device-mapper: uevent: version 1.0.3
Apr 19 15:46:49 localhost kernel: [    1.997805] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
Apr 19 15:46:49 localhost kernel: [    2.015474] padlock: VIA PadLock not detected.
Apr 19 15:46:49 localhost kernel: [    2.077018] usb 3-1: device not accepting address 2, error -71
Apr 19 15:46:49 localhost kernel: [    2.128050] hub 3-0:1.0: unable to enumerate USB device on port 1
Apr 19 15:46:49 localhost kernel: [    2.128172] usb 1-1: USB disconnect, address 2
Apr 19 15:46:49 localhost kernel: [    2.232049] usb 2-1: USB disconnect, address 2
Apr 19 15:46:49 localhost kernel: [    2.438023] usb 5-1: new high speed USB device using ehci_hcd and address 2
Apr 19 15:46:49 localhost kernel: [    2.693114] usb 5-1: New USB device found, idVendor=148f, idProduct=2573
Apr 19 15:46:49 localhost kernel: [    2.693201] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Apr 19 15:46:49 localhost kernel: [    2.693288] usb 5-1: Product: 54M.USB.......
Apr 19 15:46:49 localhost kernel: [    2.693371] usb 5-1: Manufacturer: Ralink
Apr 19 15:46:49 localhost kernel: [    2.795021] usb 5-3: new high speed USB device using ehci_hcd and address 3
Apr 19 15:46:49 localhost kernel: [    2.921245] usb 5-3: New USB device found, idVendor=19d2, idProduct=0063
Apr 19 15:46:49 localhost kernel: [    2.921331] usb 5-3: New USB device strings: Mfr=2, Product=1, SerialNumber=0
Apr 19 15:46:49 localhost kernel: [    2.921418] usb 5-3: Product: ZTE CDMA Technologies MSM
Apr 19 15:46:49 localhost kernel: [    2.921503] usb 5-3: Manufacturer: ZTE,Incorporated
Apr 19 15:46:49 localhost kernel: [    3.025018] usb 5-5: new high speed USB device using ehci_hcd and address 4
Apr 19 15:46:49 localhost kernel: [    3.170254] usb 5-5: New USB device found, idVendor=0ac8, idProduct=3420
Apr 19 15:46:49 localhost kernel: [    3.170341] usb 5-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Apr 19 15:46:49 localhost kernel: [    3.170428] usb 5-5: Product: Venus USB2.0 Camera
Apr 19 15:46:49 localhost kernel: [    3.170512] usb 5-5: Manufacturer: Vimicro Corp.
Apr 19 15:46:49 localhost kernel: [   14.145545] kjournald starting.  Commit interval 5 seconds
Apr 19 15:46:49 localhost kernel: [   14.145755] EXT3-fs (dm-6): mounted filesystem with ordered data mode
Apr 19 15:46:49 localhost kernel: [   14.291581] SELinux:  Disabled at runtime.
Apr 19 15:46:49 localhost kernel: [   14.303139] type=1404 audit(1271684767.303:2): selinux=0 auid=4294967295 ses=4294967295
Apr 19 15:46:49 localhost kernel: [   16.783107] udevd version 127 started
Apr 19 15:46:49 localhost kernel: [   18.147784] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
Apr 19 15:46:49 localhost kernel: [   18.147877] ACPI: Power Button [PWRB]
Apr 19 15:46:49 localhost kernel: [   18.147966] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
Apr 19 15:46:49 localhost kernel: [   18.148002] ACPI: Power Button [PWRF]
Apr 19 15:46:49 localhost kernel: [   18.294250] ACPI: SSDT 7f7c0090 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
Apr 19 15:46:49 localhost kernel: [   18.296370] ACPI: SSDT 7f7c0520 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
Apr 19 15:46:49 localhost kernel: [   18.416332] rtc_cmos 00:03: RTC can wake from S4
Apr 19 15:46:49 localhost kernel: [   18.416566] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Apr 19 15:46:49 localhost kernel: [   18.416602] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
Apr 19 15:46:49 localhost kernel: [   18.560002] input: PC Speaker as /devices/platform/pcspkr/input/input4
Apr 19 15:46:49 localhost kernel: [   18.795176] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Apr 19 15:46:49 localhost kernel: [   18.795203] r8169 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Apr 19 15:46:49 localhost kernel: [   18.795936] eth0: RTL8102e at 0xf90ac000, 00:19:66:a7:72:3c, XID 04a00000 IRQ 26
Apr 19 15:46:49 localhost kernel: [   18.919282] Linux video capture interface: v2.00
Apr 19 15:46:49 localhost kernel: [   19.016969] parport_pc 00:06: reported by Plug and Play ACPI
Apr 19 15:46:49 localhost kernel: [   19.017108] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
Apr 19 15:46:49 localhost kernel: [   19.147006] ppdev: user-space parallel port driver
Apr 19 15:46:49 localhost kernel: [   19.221145] usbcore: registered new interface driver usbserial
Apr 19 15:46:49 localhost kernel: [   19.221173] USB Serial support registered for generic
Apr 19 15:46:49 localhost kernel: [   19.222116] usbcore: registered new interface driver usbserial_generic
Apr 19 15:46:49 localhost kernel: [   19.222119] usbserial: USB Serial Driver core
Apr 19 15:46:49 localhost kernel: [   19.357042] cfg80211: Using static regulatory domain info
Apr 19 15:46:49 localhost kernel: [   19.357044] cfg80211: Regulatory domain: 00
Apr 19 15:46:49 localhost kernel: [   19.357045]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 19 15:46:49 localhost kernel: [   19.357048]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
Apr 19 15:46:49 localhost kernel: [   19.357051]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
Apr 19 15:46:49 localhost kernel: [   19.357053]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
Apr 19 15:46:49 localhost kernel: [   19.357056]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
Apr 19 15:46:49 localhost kernel: [   19.357059]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
Apr 19 15:46:49 localhost kernel: [   19.357687] cfg80211: Calling CRDA to update world regulatory domain
Apr 19 15:46:49 localhost kernel: [   19.419755] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Apr 19 15:46:49 localhost kernel: [   19.455618] leds_ss4200: no LED devices found
Apr 19 15:46:49 localhost kernel: [   19.532049] uvcvideo: Found UVC 1.00 device Venus USB2.0 Camera (0ac8:3420)
Apr 19 15:46:49 localhost kernel: [   19.534311] input: Venus USB2.0 Camera as /devices/pci0000:00/0000:00:1d.7/usb5/5-5/5-5:1.0/input/input5
Apr 19 15:46:49 localhost kernel: [   19.534900] usbcore: registered new interface driver uvcvideo
Apr 19 15:46:49 localhost kernel: [   19.534902] USB Video Class driver (v0.1.0)
Apr 19 15:46:49 localhost kernel: [   19.568425] USB Serial support registered for GSM modem (1-port)
Apr 19 15:46:49 localhost kernel: [   19.568937] option 5-3:1.0: GSM modem (1-port) converter detected
Apr 19 15:46:49 localhost kernel: [   19.570284] usb 5-3: GSM modem (1-port) converter now attached to ttyUSB0
Apr 19 15:46:49 localhost kernel: [   19.570319] option 5-3:1.1: GSM modem (1-port) converter detected
Apr 19 15:46:49 localhost kernel: [   19.570409] usb 5-3: GSM modem (1-port) converter now attached to ttyUSB1
Apr 19 15:46:49 localhost kernel: [   19.570435] option 5-3:1.2: GSM modem (1-port) converter detected
Apr 19 15:46:49 localhost kernel: [   19.570510] usb 5-3: GSM modem (1-port) converter now attached to ttyUSB2
Apr 19 15:46:49 localhost kernel: [   19.570537] option 5-3:1.3: GSM modem (1-port) converter detected
Apr 19 15:46:49 localhost kernel: [   19.570695] usb 5-3: GSM modem (1-port) converter now attached to ttyUSB3
Apr 19 15:46:49 localhost kernel: [   19.570720] option 5-3:1.4: GSM modem (1-port) converter detected
Apr 19 15:46:49 localhost kernel: [   19.570810] usb 5-3: GSM modem (1-port) converter now attached to ttyUSB4
Apr 19 15:46:49 localhost kernel: [   19.570848] usbcore: registered new interface driver option
Apr 19 15:46:49 localhost kernel: [   19.570850] option: v0.7.2:USB Driver for GSM modems
Apr 19 15:46:49 localhost kernel: [   19.650170] Linux agpgart interface v0.103
Apr 19 15:46:49 localhost kernel: [   19.682795] intel_rng: FWH not detected
Apr 19 15:46:49 localhost kernel: [   19.806305] iTCO_vendor_support: vendor-support=0
Apr 19 15:46:49 localhost kernel: [   19.897123] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
Apr 19 15:46:49 localhost kernel: [   19.897296] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0860)
Apr 19 15:46:49 localhost kernel: [   19.897467] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Apr 19 15:46:49 localhost kernel: [   20.063931] agpgart-intel 0000:00:00.0: Intel 945G Chipset
Apr 19 15:46:49 localhost kernel: [   20.065062] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
Apr 19 15:46:49 localhost kernel: [   20.067630] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
Apr 19 15:46:49 localhost kernel: [   20.394359] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input6
Apr 19 15:46:49 localhost kernel: [   20.708389] usbcore: registered new interface driver snd-usb-audio
Apr 19 15:46:49 localhost kernel: [   20.762585] phy0 -> rt2x00_print_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 0002573a.
Apr 19 15:46:49 localhost kernel: [   20.886458] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Apr 19 15:46:49 localhost kernel: [   21.013836] alg: No test for cipher_null (cipher_null-generic)
Apr 19 15:46:49 localhost kernel: [   21.013903] alg: No test for ecb(cipher_null) (ecb-cipher_null)
Apr 19 15:46:49 localhost kernel: [   21.013948] alg: No test for digest_null (digest_null-generic)
Apr 19 15:46:49 localhost kernel: [   21.013990] alg: No test for compress_null (compress_null-generic)
Apr 19 15:46:49 localhost kernel: [   21.099977] Registered led device: rt73usb-phy0::radio
Apr 19 15:46:49 localhost kernel: [   21.100017] Registered led device: rt73usb-phy0::assoc
Apr 19 15:46:49 localhost kernel: [   21.100045] Registered led device: rt73usb-phy0::quality
Apr 19 15:46:49 localhost kernel: [   21.100633] usbcore: registered new interface driver rt73usb
Apr 19 15:46:49 localhost kernel: [   21.118558] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
Apr 19 15:46:49 localhost kernel: [   21.160239] usbcore: registered new interface driver rt2500usb
Apr 19 15:46:49 localhost kernel: [   34.032651] device-mapper: multipath: version 1.1.1 loaded
Apr 19 15:46:49 localhost kernel: [   34.697955] loop: loaded (max 8 devices)


Apr 19 15:46:49 localhost kernel: [   41.438478] microcode: CPU0 sig=0x10676, pf=0x1, revision=0x60c
Apr 19 15:46:49 localhost kernel: [   41.438483] platform microcode: firmware: requesting intel-ucode/06-17-06
Apr 19 15:46:49 localhost kernel: [   41.461401] microcode: CPU1 sig=0x10676, pf=0x1, revision=0x60c
Apr 19 15:46:49 localhost kernel: [   41.461405] platform microcode: firmware: requesting intel-ucode/06-17-06
Apr 19 15:46:49 localhost kernel: [   41.465472] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Apr 19 15:46:49 localhost kernel: [   42.683623] microcode: Microcode Update Driver: v2.00 removed.
Apr 19 15:46:49 localhost kernel: [   42.936546] NET: Registered protocol family 10
Apr 19 15:46:49 localhost kernel: [   42.937089] lo: Disabled Privacy Extensions
Apr 19 15:46:49 localhost kernel: [   43.224430] ip_tables: (C) 2000-2006 Netfilter Core Team
Apr 19 15:46:49 localhost kernel: [   43.459746] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Apr 19 15:46:49 localhost kernel: [   43.460169] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
Apr 19 15:46:49 localhost kernel: [   43.460172] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
Apr 19 15:46:49 localhost kernel: [   43.460174] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Apr 19 15:46:49 localhost kernel: [   43.948078] r8169: eth0: link down
Apr 19 15:46:49 localhost kernel: [   43.948525] ADDRCONF(NETDEV_UP): eth0: link is not ready
Apr 19 15:46:49 localhost kernel: [   49.475723] phy0 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt73.bin'.
Apr 19 15:46:49 localhost kernel: [   49.475729] rt73usb 5-1:1.0: firmware: requesting rt73.bin
Apr 19 15:46:49 localhost kernel: [   49.499955] phy0 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 1.7.
Apr 19 15:46:49 localhost kernel: [   49.572869] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
Apr 19 15:46:49 localhost kernel: [   49.574867] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
Apr 19 15:46:49 localhost kernel: [   49.576866] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
Apr 19 15:46:49 localhost kernel: [   49.578867] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.

Apr 19 15:46:52 localhost acpid: starting up
Apr 19 15:46:54 localhost kernel: [   60.574254] w83627ehf: Found W83627EHG chip at 0x290
Apr 19 15:46:55 localhost acpid: client connected from 3278[68:68]


Apr 19 15:47:15 localhost acpid: client connected from 3814[0:0]
Apr 19 15:47:16 localhost kernel: [   82.699257] [drm] Initialized drm 1.1.0 20060810
Apr 19 15:47:16 localhost kernel: [   82.863585] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Apr 19 15:47:16 localhost kernel: [   82.871496] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
Apr 19 15:47:36 localhost kernel: [  102.812809] fuse init (API version 7.13)

Apr 19 15:52:11 localhost kernel: [  377.101078] usb 5-6: new high speed USB device using ehci_hcd and address 5
Apr 19 15:52:11 localhost kernel: [  377.218750] usb 5-6: New USB device found, idVendor=2040, idProduct=5500
Apr 19 15:52:11 localhost kernel: [  377.218752] usb 5-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Apr 19 15:52:11 localhost kernel: [  377.218755] usb 5-6: Product: WinTV MiniStick
Apr 19 15:52:11 localhost kernel: [  377.218757] usb 5-6: Manufacturer: Hauppauge Computer Works
Apr 19 15:52:11 localhost kernel: [  377.218759] usb 5-6: SerialNumber: f069684c
Apr 19 15:52:11 localhost kernel: [  377.337280] usb 5-6: firmware: requesting sms1xxx-hcw-55xxx-dvbt-02.fw
Apr 19 15:52:12 localhost kernel: [  378.050040] smscore_set_device_mode: firmware download success: sms1xxx-hcw-55xxx-dvbt-02.fw
Apr 19 15:52:12 localhost kernel: [  378.154366] DVB: registering new adapter (Hauppauge WinTV MiniStick)
Apr 19 15:52:12 localhost kernel: [  378.156037] DVB: registering adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...
Apr 19 15:52:12 localhost kernel: [  378.160568] usbcore: registered new interface driver smsusb
