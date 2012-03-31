Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587Ab2CaMEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:04:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44643 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272Ab2CaMEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:04:24 -0400
MIME-Version: 1.0
Date: Sat, 31 Mar 2012 14:04:23 +0200
Message-ID: <CAJ6tnsJKt2rb0wq1vh+RReF-0sAWJijKavjYOhC39cc3Nc6EFQ@mail.gmail.com>
Subject: PROBLEM: Kernel oops 805 running Debian on Qnap TS-119PII
From: Berto <berto37@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is where to send this; please forward to the right people.

Description: I am running Debian squeeze on my Qnap TS-119PII. I used
the installer by Martin Michlmayr (cyrius.com). No exotic packages
installed, just the ordinary openssh, samba, afp and apache. All seems
to run fine until, once or twice a day, the systems crashes, rendering
it unreachable on all ports (even ping). I am often pumping lot's of
files in it through samba, but I am not sure that is the cause of evil here.

Keywords: kernel oops 805 samba

#cat /proc/version
Linux version 2.6.32-5-kirkwood (Debian 2.6.32-41squeeze2)
(dannf@debian.org) (gcc version 4.3.5 (Debian 4.3.5-4) ) #1 Fri Mar 23
07:59:47 UTC 2012

In the logs:
Mar 22 13:13:51 debian kernel: [18672.987583] kernel BUG at
/build/buildd-linux-2.6_2.6.32-41-armel-VtoESm/linux-2.6-2.6.32/debian/build/source_armel_none/mm/filemap.c:1944!
Mar 22 13:13:51 debian kernel: [18673.000548] Unable to handle kernel
NULL pointer dereference at virtual address 00000000
Mar 22 13:13:51 debian kernel: [18673.008897] pgd = df124000
Mar 22 13:13:51 debian kernel: [18673.011609] [00000000] *pgd=00000000
Mar 22 13:13:51 debian kernel: [18673.015317] Internal error: Oops: 805 [#1]
Mar 22 13:13:51 debian kernel: [18673.019430] last sysfs file:
/sys/devices/virtual/net/lo/operstate
Mar 22 13:13:51 debian kernel: [18673.025629] Modules linked in: ipv6
nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ext2 loop mv643xx_eth
ehci_hcd hmac libphy evdev sha1_generic usbcore nls_base mv_cesa
inet_lro gpio_keys aes_generic ext3 jbd mbcache sd_mod crc_t10dif
sata_mv libata scsi_mod
Mar 22 13:13:51 debian kernel: [18673.048923] CPU: 0    Not tainted
(2.6.32-5-kirkwood #1)
Mar 22 13:13:51 debian kernel: [18673.054342] PC is at __bug+0x1c/0x28
Mar 22 13:13:51 debian kernel: [18673.057930] LR is at __bug+0x18/0x28
Mar 22 13:13:51 debian kernel: [18673.061514] pc : [<c002b7f8>]    lr
: [<c002b7f4>]    psr: 20000013
Mar 22 13:13:51 debian kernel: [18673.061518] sp : df955da0  ip :
00002e22  fp : 00000000
Mar 22 13:13:51 debian kernel: [18673.073050] r10: 00000000  r9 :
00000001  r8 : 8a997000
Mar 22 13:13:51 debian kernel: [18673.078291] r7 : df954000  r6 :
00000000  r5 : 00001000  r4 : 00011de0
Mar 22 13:13:51 debian kernel: [18673.084848] r3 : 00000000  r2 :
00000001  r1 : 60000013  r0 : 00000095
Mar 22 13:13:51 debian kernel: [18673.091397] Flags: nzCv  IRQs on
FIQs on  Mode SVC_32  ISA ARM  Segment user
Mar 22 13:13:51 debian kernel: [18673.098565] Control: 0005397f
Table: 1f124000  DAC: 00000015
Mar 22 13:13:51 debian kernel: [18673.104329] Process smbd (pid: 1129,
stack limit = 0xdf954270)
Mar 22 13:13:51 debian kernel: [18673.110180] Stack: (0xdf955da0 to 0xdf956000)
Mar 22 13:13:51 debian kernel: [18673.114552] 5da0: 00000000 c009f12c
00011de0 c00a0e8c 00001000 00011de0 c0507d80 df4ea9a0
Mar 22 13:13:51 debian kernel: [18673.122766] 5dc0: ceece580 df4eaa3c
00001000 00000000 bf0b8ec0 df4eaa3c df955f50 00000001
Mar 22 13:13:51 debian kernel: [18673.130980] 5de0: 00000000 0000e000
df4ea9a0 c0507d80 8a997000 8a9a5000 00000001 8a997000
Mar 22 13:13:51 debian kernel: [18673.139195] 5e00: 00000001 df4ea9a0
ceece580 0000e000 0000e000 c00a1534 8a997000 00000001
Mar 22 13:13:51 debian kernel: [18673.147409] 5e20: df955f10 0000e000
00000000 00000000 df955eb0 df955f10 df955f50 df955ec0
Mar 22 13:13:51 debian kernel: [18673.155622] 5e40: ceece580 df4eaa3c
00000000 00000001 00000000 000003ac df490300 00000000
Mar 22 13:13:51 debian kernel: [18673.163837] 5e60: 00000000 0000e000
00000000 df4eaa10 df955f50 df955ec0 00000001 00000001
Mar 22 13:13:51 debian kernel: [18673.172051] 5e80: ceece580 8a997000
8a997000 c00a15ec df955f40 df955f80 df955ec0 ceece580
Mar 22 13:13:51 debian kernel: [18673.180266] 5ea0: df955f50 df955fa8
fffffdee df954000 00000000 c00cd964 8a997000 00000001
Mar 22 13:13:51 debian kernel: [18673.188480] 5ec0: 00000000 00000010
00000000 00000001 ffffffff ceece580 00000000 00000000
Mar 22 13:13:51 debian kernel: [18673.196694] 5ee0: 00000000 00000000
dfae2b80 bf158b54 00000000 00000000 df955ef4 dfae2b80
Mar 22 13:13:51 debian kernel: [18673.204909] 5f00: c005d6e4 df955f04
df955f04 df955f80 8a997000 00000001 000003ac 0000000b
Mar 22 13:13:51 debian kernel: [18673.213122] 5f20: df822424 00000080
0000e000 00000000 c03d0d0c 0000012c 001c08f4 c023da68
Mar 22 13:13:51 debian kernel: [18673.221337] 5f40: 00000000 c00cdb54
df954000 0000000c 2a91821c 0000e000 ceece580 2a91821c
Mar 22 13:13:51 debian kernel: [18673.229551] 5f60: df955fa8 000000b5
0000e000 c00ce5c0 0000000b 0000000b 2a91821c ceece580
Mar 22 13:13:51 debian kernel: [18673.237765] 5f80: 0000e000 000000b5
c0028048 c00ce708 c004b68c 00000000 8a997000 00000001
Mar 22 13:13:51 debian kernel: [18673.245979] 5fa0: 0000001f c0027ea0
8a997000 00000001 0000001f 2a91821c 0000e000 00000000
Mar 22 13:13:51 debian kernel: [18673.254194] 5fc0: 8a997000 00000001
0000001f 000000b5 2a91821c 00000001 0000e000 8a997000
Mar 22 13:13:51 debian kernel: [18673.262408] 5fe0: 403f2000 be867220
2a33ea38 40365910 60000010 0000001f 00000000 00000000
Mar 22 13:13:51 debian kernel: [18673.270630] [<c002b7f8>]
(__bug+0x1c/0x28) from [<c009f12c>] (iov_iter_advance+0x74/0xcc)
Mar 22 13:13:51 debian kernel: [18673.278849] [<c009f12c>]
(iov_iter_advance+0x74/0xcc) from [<c00a0e8c>]
(generic_file_buffered_write+0x194/0x288)
Mar 22 13:13:51 debian kernel: [18673.289154] [<c00a0e8c>]
(generic_file_buffered_write+0x194/0x288) from [<c00a1534>]
(__generic_file_aio_write+0x410/0x45c)
Mar 22 13:13:51 debian kernel: [18673.300333] [<c00a1534>]
(__generic_file_aio_write+0x410/0x45c) from [<c00a15ec>]
(generic_file_aio_write+0x6c/0xd4)
Mar 22 13:13:51 debian kernel: [18673.310904] [<c00a15ec>]
(generic_file_aio_write+0x6c/0xd4) from [<c00cd964>]
(do_sync_write+0xb4/0x100)
Mar 22 13:13:51 debian kernel: [18673.320425] [<c00cd964>]
(do_sync_write+0xb4/0x100) from [<c00ce5c0>] (vfs_write+0xac/0x1a0)
Mar 22 13:13:51 debian kernel: [18673.328900] [<c00ce5c0>]
(vfs_write+0xac/0x1a0) from [<c00ce708>] (sys_pwrite64+0x54/0x78)
Mar 22 13:13:51 debian kernel: [18673.337200] [<c00ce708>]
(sys_pwrite64+0x54/0x78) from [<c0027ea0>] (ret_fast_syscall+0x0/0x28)
Mar 22 13:13:51 debian kernel: [18673.345936] Code: e1a01000 e59f000c
eb0a3037 e3a03000 (e5833000)
Mar 22 13:13:51 debian kernel: [18673.352225] ---[ end trace
fe18c27702b340b6 ]---

Reproduction: unfortunately it doesn't happen during a specific
action, all the time. I installed debian, with /home being a separate
partition, just openssh, samba, afp and apache2 installed. Copying
files through samba for hours fine until, at some undefined moment in
time the box stops all external connections and will not accept new
once. No red lights or beeps. Reboot seems the only option. At least
it did write to log... I tried the same recipe with a different hard
drive: same cake.

#./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
Linux knapzak 2.6.32-5-kirkwood #1 Fri Mar 23 07:59:47 UTC 2012
armv5tel GNU/Linux
./ver_linux: 15: gcc: not found
Gnu C
util-linux             ng 2.17.2)
mount                  ng 2.17.2 (with libblkid and selinux support)
modutils               3.12
e2fsprogs              1.41.12
Linux C Library        2.11.3
Dynamic linker (ldd)   2.11.3
Procps                 3.2.8
Net-tools              1.60
Kbd                    loadkeys:
Sh-utils               8.5
Modules Loaded         ipv6 nfsd lockd nfs_acl auth_rpcgss sunrpc
exportfs ext2 loop mv643xx_eth ehci_hcd libphy evdev usbcore hmac
sha1_generic nls_base mv_cesa gpio_keys inet_lro aes_generic ext3 jbd
mbcache sd_mod crc_t10dif sata_mv libata scsi_mod

#cat /proc/cpuinfo
Processor	: Feroceon 88FR131 rev 1 (v5l)
BogoMIPS	: 1985.74
Features	: swp half thumb fastmult edsp
CPU implementer	: 0x56
CPU architecture: 5TE
CPU variant	: 0x2
CPU part	: 0x131
CPU revision	: 1
Hardware	: QNAP TS-119/TS-219
Revision	: 0000
Serial		: 0000000000000000

#cat /proc/modules
ipv6 254252 23 - Live 0xbf242000
nfsd 247736 11 - Live 0xbf1f5000
lockd 63197 1 nfsd, Live 0xbf1dc000
nfs_acl 2277 1 nfsd, Live 0xbf1d6000
auth_rpcgss 33350 1 nfsd, Live 0xbf1c6000
sunrpc 171352 10 nfsd,lockd,nfs_acl,auth_rpcgss, Live 0xbf186000
exportfs 3008 1 nfsd, Live 0xbf180000
ext2 55355 1 - Live 0xbf16a000
loop 11435 0 - Live 0xbf161000
mv643xx_eth 22574 0 - Live 0xbf155000
ehci_hcd 36573 0 - Live 0xbf145000
libphy 14844 1 mv643xx_eth, Live 0xbf139000
evdev 6582 0 - Live 0xbf132000
usbcore 123143 2 ehci_hcd, Live 0xbf102000
hmac 2475 0 - Live 0xbf0fc000
sha1_generic 1717 0 - Live 0xbf0f6000
nls_base 5367 1 usbcore, Live 0xbf0ef000
mv_cesa 9270 0 - Live 0xbf0e7000
gpio_keys 3074 0 - Live 0xbf0e1000
inet_lro 5060 1 mv643xx_eth, Live 0xbf0da000
aes_generic 32820 1 mv_cesa, Live 0xbf0cc000
ext3 111292 2 - Live 0xbf0a5000
jbd 37786 1 ext3, Live 0xbf092000
mbcache 4860 2 ext2,ext3, Live 0xbf08a000
sd_mod 31360 5 - Live 0xbf07b000
crc_t10dif 1106 1 sd_mod, Live 0xbf075000
sata_mv 24406 4 - Live 0xbf068000
libata 137954 1 sata_mv, Live 0xbf032000
scsi_mod 124524 2 sd_mod,libata, Live 0xbf000000

#cat /proc/iomem
00000000-0fffffff : System RAM
  00027000-00396fff : Kernel text
  003ac000-0043ddd3 : Kernel data
10000000-1fffffff : System RAM
f1010300-f101030f : rtc-mv
f1010600-f10107ff : orion_spi.0
  f1010600-f10107ff : orion_spi.0
f1011000-f101101f : mv64xxx_i2c.0
  f1011000-f101101f : mv64xxx_i2c adapter
f1012000-f10120ff : serial8250.0
  f1012000-f101201f : serial
f1012100-f10121ff : serial8250.1
  f1012100-f101211f : serial
f1030000-f103ffff : regs
f1050000-f1050fff : orion-ehci.0
  f1050000-f1050fff : ehci_hcd
f1060800-f10608ff : xor 0 low
f1060900-f10609ff : xor 1 low
f1060a00-f1060aff : xor 0 high
f1060b00-f1060bff : xor 1 high
f1072000-f1073fff : ge00 base
f1080000-f1084fff : sata base
f5000000-f50007ff : sram

#cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
Vendor: ATA      Model: WDC WD5000AAVS-0 Rev: 01.0
Type:   Direct-Access                    ANSI  SCSI revision: 05
