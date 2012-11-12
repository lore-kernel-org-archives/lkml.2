Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab2KLHlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 02:41:00 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:42426 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2KLHk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 02:40:58 -0500
Message-ID: <50A0A7EF.3050706@linux.vnet.ibm.com>
Date: Mon, 12 Nov 2012 15:40:31 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pawel.sikora@agmk.net>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, arekm@pld-linux.org,
        baggins@pld-linux.org
Subject: Re: [3.6.6] panic on reboot / khungtaskd blocked? (WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule)
References: <56378024.A3Kec8xZj0@pawels> <50A0672C.6030808@linux.vnet.ibm.com> <14708876.P7cyvF6HsA@localhost>
In-Reply-To: <14708876.P7cyvF6HsA@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12111207-3568-0000-0000-000002BFDB22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 03:16 PM, Paweł Sikora wrote:
> On Monday 12 of November 2012 11:04:12 Michael Wang wrote:
>> On 11/09/2012 09:48 PM, Paweł Sikora wrote:
>>> Hi,
>>>
>>> during playing with new ups i've caught an nice oops on reboot:
>>>
>>> http://imgbin.org/index.php?page=image&id=10253
>>>
>>> probably the upstream is also affected.
>>
>> Hi, Paweł
>>
>> Are you using a clean 3.6.6 without any modify?
> 
> yes, pure 3.6.6 form git tree with modular config.
> 
>> Looks like some threads has set itself to be UNINTERRUPTIBLE with out
>> any design on switch itself back later(or the time is too long), are you
>> accidentally using some bad designed module?
> 
> hmm, hard to say. mostly all modules are loaded automatically by kernel.

Could you please provide the whole dmesg in text? your picture lost the
print info of the hung task.

And please try the latest kernel, the issue may already solved(if it is
a issue...).

Regards,
Michael Wang

> 
> # lsmod
> Module                  Size  Used by
> nfsv4                 125022  1 
> fuse                   77993  0 
> nfsv3                  34273  1 
> nfs                   142878  5 nfsv4,nfsv3
> fscache                46225  1 nfs
> nfsd                  247413  13 
> lockd                  76458  3 nfsv3,nfs,nfsd
> nfs_acl                12741  2 nfsv3,nfsd
> auth_rpcgss            39901  2 nfsv4,nfsd
> sunrpc                211604  31 nfsv4,nfsv3,nfs,nfsd,lockd,nfs_acl,auth_rpcgss
> ipmi_si                48670  0 
> ipmi_devintf           17521  0 
> ipmi_msghandler        43715  2 ipmi_si,ipmi_devintf
> sch_sfq                21375  2 
> iptable_nat            13182  1 
> nf_nat                 24649  1 iptable_nat
> nf_conntrack_ipv4      14594  3 iptable_nat,nf_nat
> nf_conntrack           74130  3 iptable_nat,nf_nat,nf_conntrack_ipv4
> nf_defrag_ipv4         12673  1 nf_conntrack_ipv4
> iptable_filter         12810  0 
> xt_TCPMSS              12707  2 
> xt_tcpudp              12603  2 
> iptable_mangle         12695  1 
> ip_tables              26782  3 iptable_nat,iptable_filter,iptable_mangle
> ip6table_filter        12815  0 
> ip6_tables             26942  1 ip6table_filter
> x_tables               27637  8 iptable_nat,iptable_filter,xt_TCPMSS,xt_tcpudp,iptable_mangle,ip_tables,ip6table_filter,ip6_tables
> ext4                  482400  2 
> jbd2                   89967  1 ext4
> crc16                  12559  1 ext4
> raid0                  17188  2 
> dm_mod                 77931  0 
> autofs4                28341  11 
> dummy                  12915  0 
> ide_cd_mod             35359  0 
> cdrom                  41920  1 ide_cd_mod
> ata_generic            12910  0 
> pata_acpi              13038  0 
> pata_atiixp            13271  0 
> ide_pci_generic        12866  0 
> igb                   125677  0 
> pcspkr                 12718  0 
> evdev                  17797  0 
> joydev                 17457  0 
> sp5100_tco             13697  0 
> powernow_k8            18109  1 
> freq_table             13743  1 powernow_k8
> mperf                  12607  1 powernow_k8
> mgag200                38130  1 
> amd64_edac_mod         28812  0 
> edac_core              56455  2 amd64_edac_mod
> kvm_amd                55563  0 
> ttm                    75424  1 mgag200
> kvm                   406326  1 kvm_amd
> drm_kms_helper         44701  1 mgag200
> drm                   250914  3 mgag200,ttm,drm_kms_helper
> k10temp                13126  0 
> hwmon                  12853  1 k10temp
> i2c_algo_bit           13257  1 mgag200
> sysimgblt              12588  1 mgag200
> sysfillrect            12654  1 mgag200
> syscopyarea            12445  1 mgag200
> microcode              18669  0 
> hid_generic            12493  0 
> atiixp                 12917  0 
> i2c_piix4              13266  0 
> dca                    14601  1 igb
> ptp                    18413  1 igb
> pps_core               13770  1 ptp
> edac_mce_amd           22771  1 amd64_edac_mod
> ide_core              108021  3 ide_cd_mod,ide_pci_generic,atiixp
> i2c_core               28918  5 mgag200,drm_kms_helper,drm,i2c_algo_bit,i2c_piix4
> processor              31231  1 powernow_k8
> button                 13692  0 
> ext3                  220064  1 
> jbd                    77423  1 ext3
> mbcache                14316  2 ext4,ext3
> sd_mod                 44963  16 
> crc_t10dif             12483  1 sd_mod
> raid1                  35216  1 
> md_mod                112433  5 raid0,raid1
> ahci                   25731  12 
> libahci                26007  1 ahci
> libata                195604  5 ata_generic,pata_acpi,pata_atiixp,ahci,libahci
> scsi_mod              161576  2 sd_mod,libata
> usbhid                 46734  0 
> hid                    94508  2 hid_generic,usbhid
> ohci_hcd               31595  0 
> ehci_hcd               50048  0 
> usbcore               173967  4 usbhid,ohci_hcd,ehci_hcd
> usb_common             12489  1 usbcore
> 
> BR,
> Paweł.
> 

