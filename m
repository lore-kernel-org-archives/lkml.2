Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab1D1SMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:12:44 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:60315 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab1D1SMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:12:40 -0400
Date: Thu, 28 Apr 2011 20:12:37 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v2.6.39-rc5
Message-ID: <alpine.DEB.2.00.1104282011410.2215@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v2.6.39-rc5[1] compared to v2.6.38[2].

Summarized:
  - build errors: +45/-161
  - build warnings: +283/-131

JFYI, when comparing v2.6.39-rc5 to v2.6.39-rc4[3], the summaries are:
  - build errors: +36/-10
  - build warnings: +95/-447

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v2.6.39-rc5.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/3947/ (95 out of 108 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/3816/ (all 108 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/3926/ (all 108 configs)


*** ERRORS ***

45 regressions:
  + error: hung_task.c: undefined reference to `ack_bad_irq':  => .text+0x1ff0c)
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL against `.text'+61c:  => (.text+0xa22)
  + src/arch/powerpc/platforms/pseries/iommu.c: error: 'struct pci_dn' has no member named 'eeh_config_addr':  => 796, 766
  + src/arch/powerpc/platforms/pseries/iommu.c: error: 'struct pci_dn' has no member named 'eeh_pe_config_addr':  => 797, 767, 798, 768
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'inb':  => 57
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'inl':  => 188
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'inw':  => 181
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'outb':  => 56
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'outl':  => 142
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'outw':  => 135
  + src/drivers/block/paride/comm.c: error: implicit declaration of function 'inb':  => 54
  + src/drivers/block/paride/comm.c: error: implicit declaration of function 'inl':  => 140
  + src/drivers/block/paride/comm.c: error: implicit declaration of function 'inw':  => 135
  + src/drivers/block/paride/comm.c: error: implicit declaration of function 'outb':  => 53
  + src/drivers/block/paride/comm.c: error: implicit declaration of function 'outl':  => 172
  + src/drivers/block/paride/comm.c: error: implicit declaration of function 'outw':  => 168
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'inb':  => 1368
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'inl':  => 1398
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'inw':  => 1383
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'outb':  => 1376
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'outl':  => 1406
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'outw':  => 1391
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: invalid operands to binary << (have 'void *' and 'int'):  => 1406, 1391
  + src/drivers/char/pcmcia/cm4000_cs.c: error: implicit declaration of function 'inb':  => 312
  + src/drivers/char/pcmcia/cm4000_cs.c: error: implicit declaration of function 'outb':  => 429
  + src/drivers/char/pcmcia/synclink_cs.c: error: implicit declaration of function 'inb':  => 683
  + src/drivers/char/pcmcia/synclink_cs.c: error: implicit declaration of function 'inw':  => 860
  + src/drivers/char/pcmcia/synclink_cs.c: error: implicit declaration of function 'outb':  => 694
  + src/drivers/char/pcmcia/synclink_cs.c: error: implicit declaration of function 'outw':  => 342
  + src/drivers/char/tpm/tpm.h: error: invalid operands to binary & (have 'void *' and 'int'):  => 130
  + src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread32':  => 413
  + src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread8':  => 104
  + src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite32':  => 422
  + src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite8':  => 117
  + src/drivers/gpu/drm/radeon/radeon_gart.c: error: 'DMA_ERROR_CODE' undeclared (first use in this function):  => 186
  + src/drivers/gpu/drm/radeon/radeon_gart.c: error: (Each undeclared identifier is reported only once:  => 186
  + src/drivers/gpu/drm/radeon/radeon_gart.c: error: for each function it appears in.):  => 186
  + src/drivers/input/gameport/lightning.c: error: invalid operands to binary & (have 'void *' and 'int'):  => 177, 141, 86
  + src/drivers/staging/gma500/psb_drv.c: error: implicit declaration of function 'set_pages_uc':  => 664
  + src/drivers/usb/host/ohci-hcd.c: error: #error "missing bus glue for ohci-hcd":  => 1118:2
  + src/drivers/video/backlight/hp680_bl.c: error: implicit declaration of function 'inw':  => 48
  + src/drivers/video/backlight/hp680_bl.c: error: implicit declaration of function 'outw':  => 50
  + src/kernel/fork.c: error: implicit declaration of function 'alloc_thread_info_node':  => 267
  + src/sound/drivers/mpu401/mpu401_uart.c: error: implicit declaration of function 'inb':  => 67
  + src/sound/drivers/mpu401/mpu401_uart.c: error: implicit declaration of function 'outb':  => 61

161 improvements:
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/cgroupstats.h: error: expected specifier-qualifier-list before '__u64': 32 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/connector.h: error: expected specifier-qualifier-list before '__u32': 67, 60 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/errqueue.h: error: expected specifier-qualifier-list before '__u32': 7 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: '__u16' undeclared (first use in this function): 44 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: 'speed' undeclared (first use in this function): 45 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: 'struct ethtool_cmd' has no member named 'speed': 44 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: 'struct ethtool_cmd' has no member named 'speed_hi': 45 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: (Each undeclared identifier is reported only once: 44 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: expected ';' before 'speed': 44 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'ethtool_cmd_speed': 48 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: expected declaration specifiers or '...' before '__u32': 41 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: expected specifier-qualifier-list before '__be32': 371, 353, 336 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: expected specifier-qualifier-list before '__u32': 104, 90, 21, 282, 389, 460, 521, 444, 96, 297, 82, 57, 291, 258, 231, 482, 209, 510, 265, 113 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: for each function it appears in.): 44 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/genetlink.h: error: expected specifier-qualifier-list before '__u8': 13 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_addr.h: error: expected specifier-qualifier-list before '__u32': 49 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_addr.h: error: expected specifier-qualifier-list before '__u8': 8 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_bonding.h: error: expected specifier-qualifier-list before '__s32': 102, 96 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_bonding.h: error: expected specifier-qualifier-list before '__u16': 110 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_ether.h: error: expected specifier-qualifier-list before '__be16': 122 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_link.h: error: expected specifier-qualifier-list before '__u32': 243, 200, 289, 295, 284, 230, 9, 300 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_link.h: error: expected specifier-qualifier-list before '__u64': 42, 75 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_link.h: error: expected specifier-qualifier-list before '__u8': 373 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/neighbour.h: error: expected specifier-qualifier-list before '__u16': 130 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/neighbour.h: error: expected specifier-qualifier-list before '__u32': 58 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/neighbour.h: error: expected specifier-qualifier-list before '__u64': 90 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/neighbour.h: error: expected specifier-qualifier-list before '__u8': 124, 8 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/netlink.h: error: expected specifier-qualifier-list before '__u16': 125 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/netlink.h: error: expected specifier-qualifier-list before '__u32': 38, 33, 105 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/rtnetlink.h: error: expected specifier-qualifier-list before '__u32': 472, 330, 458 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/rtnetlink.h: error: expected specifier-qualifier-list before '__u8': 386, 504 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/spi/spidev.h: error: expected specifier-qualifier-list before '__u64': 86 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/taskstats.h: error: expected specifier-qualifier-list before '__u16': 46 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be16': 28 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32'/scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le32': 30 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32'/scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:31: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le64': 30 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32': 30 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be64': 32 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le16': 27 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le32'/scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:28: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be16': 29 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le32': 29 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le64': 31 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__sum16': 34 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__wsum': 35 => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL against `.text'+71c: (.text+0xb22) => 
  - src/Documentation/accounting/getdelays.c: error: '__u16' undeclared (first use in this function): 252, 189 => 
  - src/Documentation/accounting/getdelays.c: error: '__u32' undeclared (first use in this function): 253 => 
  - src/Documentation/accounting/getdelays.c: error: 'genl_cmd' undeclared (first use in this function): 136 => 
  - src/Documentation/accounting/getdelays.c: error: 'id' undeclared (first use in this function): 375 => 
  - src/Documentation/accounting/getdelays.c: error: 'mypid' undeclared (first use in this function): 374 => 
  - src/Documentation/accounting/getdelays.c: error: 'nla_type' undeclared (first use in this function): 139 => 
  - src/Documentation/accounting/getdelays.c: error: 'nlmsg_pid' undeclared (first use in this function): 135 => 
  - src/Documentation/accounting/getdelays.c: error: 'nlmsg_type' undeclared (first use in this function): 132 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct cgroupstats' has no member named 'nr_io_wait': 232 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct cgroupstats' has no member named 'nr_running': 233 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct cgroupstats' has no member named 'nr_sleeping': 231 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct cgroupstats' has no member named 'nr_stopped': 234 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct cgroupstats' has no member named 'nr_uninterruptible': 235 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct genlmsghdr' has no member named 'cmd': 136 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct genlmsghdr' has no member named 'version': 137 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct nlattr' has no member named 'nla_len': 464, 495, 142, 508, 187, 140, 469 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct nlattr' has no member named 'nla_type': 518, 139, 188, 475, 465, 505 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct nlmsghdr' has no member named 'nlmsg_flags': 133 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct nlmsghdr' has no member named 'nlmsg_len': 447, 131, 145, 142, 458, 183, 454 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct nlmsghdr' has no member named 'nlmsg_pid': 135 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct nlmsghdr' has no member named 'nlmsg_seq': 134 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct nlmsghdr' has no member named 'nlmsg_type': 182, 446, 132 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'ac_comm': 242 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'blkio_count': 210 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'blkio_delay_total': 211 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'cancelled_write_bytes': 245 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'cpu_count': 205 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'cpu_delay_total': 208 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'cpu_run_real_total': 206 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'cpu_run_virtual_total': 207 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'freepages_count': 216 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'freepages_delay_total': 217 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'nivcsw': 225 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'nvcsw': 225 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'read_bytes': 243 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'swapin_count': 213 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'swapin_delay_total': 214 => 
  - src/Documentation/accounting/getdelays.c: error: 'struct taskstats' has no member named 'write_bytes': 244 => 
  - src/Documentation/accounting/getdelays.c: error: (Each undeclared identifier is reported only once: 132 => 
  - src/Documentation/accounting/getdelays.c: error: expected ';' before 'id': 252 => 
  - src/Documentation/accounting/getdelays.c: error: expected ';' before 'mypid': 253 => 
  - src/Documentation/accounting/getdelays.c: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'stime': 54 => 
  - src/Documentation/accounting/getdelays.c: error: expected declaration specifiers or '...' before '__u16': 120, 121 => 
  - src/Documentation/accounting/getdelays.c: error: expected declaration specifiers or '...' before '__u32': 120 => 
  - src/Documentation/accounting/getdelays.c: error: expected declaration specifiers or '...' before '__u8': 121 => 
  - src/Documentation/accounting/getdelays.c: error: expected expression before ')' token: 189 => 
  - src/Documentation/accounting/getdelays.c: error: for each function it appears in.): 132 => 
  - src/Documentation/accounting/getdelays.c: error: too many arguments to function 'send_cmd': 385, 179, 529, 424, 409 => 
  - src/Documentation/connector/ucon.c: error: 'seq' undeclared (first use in this function): 71, 186 => 
  - src/Documentation/connector/ucon.c: error: 'struct cb_id' has no member named 'idx': 240, 195, 184 => 
  - src/Documentation/connector/ucon.c: error: 'struct cb_id' has no member named 'val': 240, 185, 195 => 
  - src/Documentation/connector/ucon.c: error: 'struct cn_msg' has no member named 'ack': 240, 187 => 
  - src/Documentation/connector/ucon.c: error: 'struct cn_msg' has no member named 'len': 188, 68, 82 => 
  - src/Documentation/connector/ucon.c: error: 'struct cn_msg' has no member named 'seq': 240, 186 => 
  - src/Documentation/connector/ucon.c: error: 'struct nlmsghdr' has no member named 'nlmsg_flags': 75 => 
  - src/Documentation/connector/ucon.c: error: 'struct nlmsghdr' has no member named 'nlmsg_len': 74 => 
  - src/Documentation/connector/ucon.c: error: 'struct nlmsghdr' has no member named 'nlmsg_pid': 72 => 
  - src/Documentation/connector/ucon.c: error: 'struct nlmsghdr' has no member named 'nlmsg_seq': 71 => 
  - src/Documentation/connector/ucon.c: error: 'struct nlmsghdr' has no member named 'nlmsg_type': 73, 230 => 
  - src/Documentation/connector/ucon.c: error: 'struct sockaddr_nl' has no member named 'nl_groups': 160 => 
  - src/Documentation/connector/ucon.c: error: 'struct sockaddr_nl' has no member named 'nl_pid': 161 => 
  - src/Documentation/connector/ucon.c: error: (Each undeclared identifier is reported only once: 71 => 
  - src/Documentation/connector/ucon.c: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'seq': 58 => 
  - src/Documentation/connector/ucon.c: error: for each function it appears in.): 71 => 
  - src/Documentation/networking/ifenslave.c: error: 'struct ethtool_drvinfo' has no member named 'cmd': 615 => 
  - src/Documentation/networking/ifenslave.c: error: 'struct ethtool_drvinfo' has no member named 'driver': 616 => 
  - src/Documentation/networking/ifenslave.c: error: 'struct ethtool_drvinfo' has no member named 'fw_version': 617 => 
  - src/Documentation/networking/timestamping/timestamping.c: error: 'struct sock_extended_err' has no member named 'ee_errno': 226 => 
  - src/Documentation/networking/timestamping/timestamping.c: error: 'struct sock_extended_err' has no member named 'ee_origin': 229, 227 => 
  - src/Documentation/spi/spidev_fdx.c: error: '__u32' undeclared (first use in this function): 82 => 
  - src/Documentation/spi/spidev_fdx.c: error: '__u8' undeclared (first use in this function): 81 => 
  - src/Documentation/spi/spidev_fdx.c: error: 'bits' undeclared (first use in this function)In file included from /scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/netlink.h:5,: 92 => 
  - src/Documentation/spi/spidev_fdx.c: error: 'lsb' undeclared (first use in this function): 88 => 
  - src/Documentation/spi/spidev_fdx.c: error: 'mode' undeclared (first use in this function): 84 => 
  - src/Documentation/spi/spidev_fdx.c: error: 'speed' undeclared (first use in this function): 96 => 
  - src/Documentation/spi/spidev_fdx.c: error: 'struct spi_ioc_transfer' has no member named 'len': 65, 62 => 
  - src/Documentation/spi/spidev_fdx.c: error: 'struct spi_ioc_transfer' has no member named 'rx_buf': 64 => 
  - src/Documentation/spi/spidev_fdx.c: error: 'struct spi_ioc_transfer' has no member named 'tx_buf': 61 => 
  - src/Documentation/spi/spidev_fdx.c: error: (Each undeclared identifier is reported only once: 81 => 
  - src/Documentation/spi/spidev_fdx.c: error: expected ';' before 'mode': 81 => 
  - src/Documentation/spi/spidev_fdx.c: error: expected ';' before 'speed': 82 => 
  - src/Documentation/spi/spidev_fdx.c: error: for each function it appears in.): 81 => 
  - src/Documentation/spi/spidev_test.c: error: '__u32' undeclared (first use in this function): 193 => 
  - src/Documentation/spi/spidev_test.c: error: '__u8' undeclared (first use in this function): 171 => 
  - src/Documentation/spi/spidev_test.c: error: (Each undeclared identifier is reported only once: 171 => 
  - src/Documentation/spi/spidev_test.c: error: for each function it appears in.): 171 => 
  - src/Documentation/spi/spidev_test.c: error: unknown field 'bits_per_word' specified in initializer: 57 => 
  - src/Documentation/spi/spidev_test.c: error: unknown field 'delay_usecs' specified in initializer: 55 => 
  - src/Documentation/spi/spidev_test.c: error: unknown field 'len' specified in initializer: 54 => 
  - src/Documentation/spi/spidev_test.c: error: unknown field 'rx_buf' specified in initializer: 53 => 
  - src/Documentation/spi/spidev_test.c: error: unknown field 'speed_hz' specified in initializer: 56 => 
  - src/Documentation/spi/spidev_test.c: error: unknown field 'tx_buf' specified in initializer: 52 => 
  - src/arch/cris/arch-v10/kernel/irq.c: error: implicit declaration of function 'set_irq_desc_and_handler': 202 => 
  - src/arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards: 999, 989, 1008 => 
  - src/arch/xtensa/kernel/irq.c: error: 'irq_cpustat_t' has no member named '__nmi_count': 107 => 
  - src/drivers/block/paride/kbic.c: error: invalid operands to binary | (have 'void *' and 'int'): 67, 85, 53, 57, 61, 91 => 
  - src/drivers/bluetooth/bluecard_cs.c: error: implicit declaration of function 'inb': 348 => 
  - src/drivers/bluetooth/bluecard_cs.c: error: implicit declaration of function 'outb': 168 => 
  - src/drivers/bluetooth/bluecard_cs.c: error: implicit declaration of function 'outb_p': 209 => 
  - src/drivers/bluetooth/btuart_cs.c: error: implicit declaration of function 'inb': 117 => 
  - src/drivers/bluetooth/btuart_cs.c: error: implicit declaration of function 'outb': 123 => 
  - src/drivers/char/specialix.c: error: implicit declaration of function 'inb': 228 => 
  - src/drivers/char/specialix.c: error: implicit declaration of function 'outb': 227 => 
  - src/drivers/char/specialix.c: error: invalid operands to binary | (have 'void *' and 'int'): 237, 227 => 
  - src/drivers/dma/pch_dma.c: error: implicit declaration of function 'kfree': 920 => 
  - src/drivers/dma/pch_dma.c: error: implicit declaration of function 'kzalloc': 785 => 
  - src/drivers/i2c/busses/i2c-pca-platform.c: error: implicit declaration of function 'ioread8': 46 => 
  - src/drivers/i2c/busses/i2c-pca-platform.c: error: implicit declaration of function 'iowrite8': 64 => 
  - src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'ioread32': 198 => 
  - src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'ioread8': 183 => 
  - src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'iowrite16': 188 => 
  - src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'iowrite32': 193 => 
  - src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'iowrite8': 178 => 
  - src/fs/ntfs/file.c: error: insn does not satisfy its constraints:: 2068 => 
  - src/include/linux/gameport.h: error: implicit declaration of function 'inb': 189 => 
  - src/include/linux/gameport.h: error: implicit declaration of function 'outb': 181 => 


*** WARNINGS ***

283 regressions:
  + .config: warning: override: HIGHMEM4G changes choice state:  => 343
  + .config: warning: override: SLOB changes choice state:  => 154
  + /tmp/cc7C7lDl.s: Warning: source register same as write-back base:  => 104
  + <stdin>: warning: #warning syscall clock_adjtime not implemented:  => 1546:2
  + <stdin>: warning: #warning syscall name_to_handle_at not implemented:  => 1538:2
  + <stdin>: warning: #warning syscall open_by_handle_at not implemented:  => 1542:2
  + <stdin>: warning: #warning syscall syncfs not implemented:  => 1550:2
  + arch/powerpc/configs/pmac32_defconfig: warning: symbol value 'm' invalid for BT_L2CAP:  => 115
  + arch/powerpc/configs/pmac32_defconfig: warning: symbol value 'm' invalid for BT_SCO:  => 116
  + arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm' invalid for BT_L2CAP:  => 354
  + arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm' invalid for BT_SCO:  => 355
  + arch/powerpc/configs/ps3_defconfig: warning: symbol value 'm' invalid for BT_L2CAP:  => 55
  + arch/powerpc/configs/ps3_defconfig: warning: symbol value 'm' invalid for BT_SCO:  => 56
  + modpost: WARNING: modpost: Found 12 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 19 section mismatch(es).:  => N/A
  + src/arch/m68k/kernel/setup_mm.c: warning: unused variable 'i':  => 219
  + src/arch/parisc/kernel/cache.c: warning: format '%s' expects type 'char *', but argument 4 has type 'void * const':  => 310
  + src/arch/parisc/kernel/cache.c: warning: pointer type mismatch in conditional expression:  => 310
  + src/arch/s390/mm/extmem.c: warning: 'end_addr' may be used uninitialized in this function: 573 => 411, 573
  + src/arch/s390/mm/extmem.c: warning: 'start_addr' may be used uninitialized in this function: 573 => 411, 573
  + src/arch/x86/kernel/apic/io_apic.c: warning: 'reg_02' is used uninitialized in this function:  => 1505
  + src/arch/x86/kernel/apic/io_apic.c: warning: 'reg_03' is used uninitialized in this function:  => 1506
  + src/arch/x86/kernel/quirks.c: warning: 'd' may be used uninitialized in this function:  => 365
  + src/arch/x86/kernel/quirks.c: warning: 'val' may be used uninitialized in this function:  => 408
  + src/arch/x86/kernel/reboot_32.S: Warning: shift count out of range (32 is not between 0 and 31):  => 134
  + src/arch/x86/kernel/reboot_32.S: Warning: shift count out of range (40 is not between 0 and 31):  => 134
  + src/arch/xtensa/include/asm/regs.h: warning: this is the location of the previous definition:  => 59:1
  + src/arch/xtensa/kernel/irq.c: warning: passing argument 1 of 'xtensa_irq_mask' makes pointer from integer without a cast:  => 92
  + src/arch/xtensa/kernel/irq.c: warning: passing argument 1 of 'xtensa_irq_unmask' makes pointer from integer without a cast:  => 87
  + src/drivers/ata/pata_legacy.c: warning: 'r' is used uninitialized in this function:  => 1098
  + src/drivers/base/memory.c: warning: 'ret' may be used uninitialized in this function:  => 404
  + src/drivers/base/power/sysfs.c: warning: 'dev_attr_async' defined but not used:  => 431
  + src/drivers/base/power/sysfs.c: warning: 'dev_attr_wakeup' defined but not used:  => 249
  + src/drivers/block/drbd/drbd_int.h: warning: comparison is always false due to limited range of data type:  => 2226
  + src/drivers/block/drbd/drbd_receiver.c: warning: 'rl' may be used uninitialized in this function:  => 3400
  + src/drivers/bluetooth/btwilink.c: warning: overflow in implicit constant conversion:  => 178
  + src/drivers/char/tpm/tpm.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 433, 400
  + src/drivers/infiniband/hw/nes/nes.c: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result:  => 1141
  + src/drivers/isdn/sc/init.c: warning: passing argument 1 of 'readl' makes pointer from integer without a cast:  => 497, 487, 507
  + src/drivers/leds/leds-alix2.c: warning: 'divil_pci' defined but not used:  => 25
  + src/drivers/mfd/wl1273-core.c: warning: unused variable 'val':  => 156
  + src/drivers/mtd/devices/docprobe.c: warning: #warning Unknown architecture  CC [M]  drivers/input/joystick/gf2k.o:  => 79:2
  + src/drivers/mtd/ftl.c: warning: passing argument 4 of 'part->mbd.mtd->read' from incompatible pointer type:  => 527, 294, 228, 490
  + src/drivers/mtd/ftl.c: warning: passing argument 4 of 'part->mbd.mtd->write' from incompatible pointer type:  => 564, 535, 426, 507, 442, 555
  + src/drivers/mtd/maps/latch-addr-flash.c: warning: 'latch_addr_flash_remove' defined but not used:  => 102
  + src/drivers/mtd/sm_ftl.c: warning: comparison of distinct pointer types lacks a cast:  => 215, 216
  + src/drivers/net/rionet.c: warning: cast from pointer to integer of different size:  => 166
  + src/drivers/net/sh_eth.c: warning: 'mdp' may be used uninitialized in this function:  => 1773
  + src/drivers/net/stmmac/stmmac_main.c: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result:  => 1984, 1980, 1987, 1975, 1968, 1978, 1970, 1972, 1982
  + src/drivers/pci/intel-iommu.c: warning: no return statement in function returning non-void:  => 3231
  + src/drivers/pci/pci-driver.c: warning: 'pci_pm_default_resume_early' defined but not used:  => 457
  + src/drivers/platform/x86/ibm_rtl.c: warning: cast from pointer to integer of different size:  => 278, 290
  + src/drivers/regulator/wm831x-dcdc.c: warning: unused variable 'wm831x':  => 779, 603
  + src/drivers/scsi/fcoe/fcoe.c: warning: label 'out_nodev' defined but not used:  => 1855, 1812
  + src/drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_resume' defined but not used:  => 33
  + src/drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_suspend' defined but not used:  => 18
  + src/drivers/staging/gma500/psb_bl.c: warning: 'device_backlight_init' defined but not used:  => 86
  + src/drivers/staging/gma500/psb_drv.c: warning: cast to pointer from integer of different size:  => 1086
  + src/drivers/staging/gma500/psb_drv.c: warning: unused variable 'bd':  => 913, 928
  + src/drivers/staging/gma500/psb_fb.c: warning: cast from pointer to integer of different size:  => 756
  + src/drivers/staging/gma500/psb_fb.c: warning: cast to pointer from integer of different size:  => 751
  + src/drivers/staging/iio/accel/sca3000_ring.c: warning: assignment from incompatible pointer type:  => 286
  + src/drivers/staging/iio/meter/ade7758_ring.c: warning: cast from pointer to integer of different size:  => 147
  + src/drivers/staging/iio/meter/ade7758_ring.c: warning: cast to pointer from integer of different size:  => 147
  + src/drivers/tty/cyclades.c: warning: 'cyz_interrupt' defined but not used:  => 1200
  + src/drivers/tty/n_gsm.c: warning: zero-length gnu_printf format string:  => 535
  + src/drivers/tty/n_gsm.c: warning: zero-length printf format string:  => 535
  + src/drivers/tty/rocket.c: warning: 'rmSpeakerReset' defined but not used:  => 3166
  + src/drivers/tty/rocket.c: warning: 'sPCIInitController' defined but not used:  => 2625
  + src/drivers/usb/core/hcd-pci.c: warning: 'resume_common' defined but not used:  => 436
  + src/drivers/usb/core/hcd-pci.c: warning: 'suspend_common' defined but not used:  => 381
  + src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_ep0_complete' defined but not used:  => 983
  + src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_set_ep_bycnt' defined but not used:  => 1032
  + src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_wrfifo' defined but not used:  => 771
  + src/drivers/usb/gadget/fusb300_udc.c: warning: cast from pointer to integer of different size:  => 1079
  + src/drivers/usb/misc/usbtest.c: warning: cast from pointer to integer of different size:  => 273
  + src/drivers/usb/otg/twl6030-usb.c: warning: ISO C90 forbids mixed declarations and code:  => 183
  + src/drivers/video/aty/aty128fb.c: warning: 'backlight' defined but not used:  => 362
  + src/drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M10' defined but not used:  => 1718
  + src/drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M9P' defined but not used:  => 1971
  + src/fs/9p/acl.c: warning: 'full_name' may be used uninitialized in this function:  => 240, 287
  + src/fs/btrfs/extent-tree.c: warning: 'ret' may be used uninitialized in this function:  => 2058
  + src/fs/fuse/file.c: warning: 'parent' may be used uninitialized in this function:  => 2052
  + src/fs/nfs/nfs4filelayout.c: warning: comparison of distinct pointer types lacks a cast:  => 56
  + src/fs/nfs/nfs4filelayout.c: warning: control reaches end of non-void function:  => 77
  + src/fs/sysfs/dir.c: warning: 'sysfs_pathname' defined but not used: 415 => 414, 415
  + src/fs/udf/inode.c: warning: 'adsize' may be used uninitialized in this function:  => 496
  + src/fs/xfs/linux-2.6/./xfs_trace.h: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t':  => 1354
  + src/include/linux/video_output.h: warning: 'video_output_register' defined but not used:  => 45
  + src/include/linux/video_output.h: warning: 'video_output_unregister' defined but not used:  => 52
  + src/include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined:  => 59:5
  + src/include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined:  => 50:5
  + src/include/net/ip_vs.h: warning: control reaches end of non-void function:  => 92, 70
  + src/include/trace/events/btrfs.h: warning: large integer implicitly truncated to unsigned type:  => 365, 197, 332, 273, 626, 68, 420, 47, 591, 144, 459, 541
  + src/kernel/fork.c: warning: assignment makes pointer from integer without a cast:  => 267
  + src/kernel/futex.c: warning: 'curval' may be used uninitialized in this function:  => 1549
  + src/kernel/futex.c: warning: 'nval' may be used uninitialized in this function:  => 2454
  + src/kernel/irq/debug.h: warning: "PS" redefined:  => 8:1
  + src/kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable':  => 2175
  + src/kernel/watchdog.c: warning: 'watchdog_disable_all_cpus' defined but not used:  => 486
  + src/kernel/watchdog.c: warning: 'watchdog_enable_all_cpus' defined but not used:  => 469
  + src/lib/debugobjects.c: warning: 'obj_states' defined but not used:  => 73
  + src/lib/debugobjects.c: warning: unused variable 'hint':  => 256
  + src/mm/swapfile.c: warning: 'span' may be used uninitialized in this function:  => 2026
  + src/net/batman-adv/vis.c: warning: passing argument 2 of 'compare_eth' discards qualifiers from pointer target type:  => 146
  + src/net/bridge/netfilter/ebtables.c: warning: 'off' may be used uninitialized in this function:  => 1885
  + src/net/bridge/netfilter/ebtables.c: warning: 'size_kern' may be used uninitialized in this function:  => 1886
  + src/net/core/ethtool.c: warning: control reaches end of non-void function:  => 421
  + src/net/netfilter/xt_connlimit.c: warning: value computed is not used:  => 234
  + src/net/sunrpc/svcsock.c: warning: 'level' may be used uninitialized in this function:  => 700
  + src/net/sunrpc/svcsock.c: warning: 'optname' may be used uninitialized in this function:  => 700
  + src/net/xfrm/xfrm_policy.c: warning: 'dst_ops' may be used uninitialized in this function:  => 1333
  + src/security/selinux/hooks.c: warning: 'prefix' may be used uninitialized in this function:  => 964
  + src/security/selinux/hooks.c: warning: 'sclass' may be used uninitialized in this function:  => 1426
  + src/security/selinux/netnode.c: warning: 'idx' may be used uninitialized in this function: 132 => 173, 132
  + src/sound/soc/codecs/wl1273.c: warning: initialization discards qualifiers from pointer target type:  => 212, 250
  + src/sound/soc/codecs/wm2000.c: warning: 'wm2000_i2c_resume' defined but not used:  => 848
  + src/sound/soc/codecs/wm2000.c: warning: 'wm2000_i2c_suspend' defined but not used:  => 840
  + warning: (CPU_SUBTYPE_SH7720 && CPU_SUBTYPE_SH7721 && CPU_SUBTYPE_SH7757 && CPU_SUBTYPE_SH7763 && CPU_SUBTYPE_SH7786) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (IA64) selects PM which has unmet direct dependencies (PM_SLEEP || PM_RUNTIME):  => N/A
  + warning: (IWLAGN && IWLWIFI_LEGACY && ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS):  => N/A
  + warning: (NET_CLS_ROUTE4) selects IP_ROUTE_CLASSID which has unmet direct dependencies (NET && INET):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON || PMC_MSP)):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  => N/A
  + warning: 1 bad relocations:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x56704): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x56720): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x5673c): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x58264): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x58280): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x5829c): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb1d0): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb2b4): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: drivers/built-in.o(.text+0x25d8e54): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/built-in.o(.text+0x25df3f8): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25df444): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25df478): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25dfbec): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25dfc38): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25dfc6c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25e1b08): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/built-in.o(.text+0x261df20): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/built-in.o(.text+0x324fb6c): Section mismatch in reference from the function .lp5521_probe() to the function .init.text:.lp5521_init_led():  => N/A
  + warning: drivers/built-in.o(.text+0x32528fc): Section mismatch in reference from the function .lp5523_probe() to the function .init.text:.lp5523_init_led():  => N/A
  + warning: drivers/built-in.o(.text+0x62f64): Section mismatch in reference from the function parport_pc_probe_port() to the function .init.text:platform_device_register_resndata():  => N/A
  + warning: drivers/built-in.o(.text+0x63d564): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/built-in.o(.text+0x137330): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/built-in.o(.text+0x137330): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/radeon/built-in.o(.text+0xd26a4): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/radeon/radeon.o(.text+0xd26a4): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/radeon/radeon.o(.text+0xd26a8): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/input/built-in.o(.text+0x27010): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/input/keyboard/built-in.o(.text+0xf8c4): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/leds/built-in.o(.text+0xb2dc): Section mismatch in reference from the function .lp5521_probe() to the function .init.text:.lp5521_init_led():  => N/A
  + warning: drivers/leds/built-in.o(.text+0xe06c): Section mismatch in reference from the function .lp5523_probe() to the function .init.text:.lp5523_init_led():  => N/A
  + warning: drivers/leds/leds-lp5521.o(.text+0x1dd8): Section mismatch in reference from the function .lp5521_probe() to the function .init.text:.lp5521_init_led():  => N/A
  + warning: drivers/leds/leds-lp5521.o(.text+0xa6a): Section mismatch in reference from the function lp5521_probe() to the function .init.text:lp5521_init_led():  => N/A
  + warning: drivers/leds/leds-lp5523.o(.text+0x29fc): Section mismatch in reference from the function .lp5523_probe() to the function .init.text:.lp5523_init_led():  => N/A
  + warning: drivers/leds/leds-lp5523.o(.text+0xfd2): Section mismatch in reference from the function lp5523_probe() to the function .init.text:lp5523_init_led():  => N/A
  + warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xaa): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info:  => N/A
  + warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xb0): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info:  => N/A
  + warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xbc): Section mismatch in reference from the function sst25l_match_device() to the (unknown reference) .init.data:(unknown):  => N/A
  + warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xc4): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info:  => N/A
  + warning: drivers/net/depca.o(.devinit.text+0x18): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_common_init():  => N/A
  + warning: drivers/net/depca.o(.devinit.text+0x40): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DepcaSignature():  => N/A
  + warning: drivers/net/depca.o(.devinit.text+0xa0): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_hw_init():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0x10a18): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0x7d64): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xe308): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xe354): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xe388): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xeafc): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xeb48): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xeb7c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_audio.o(.text+0x2b8c): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_audio.o(.text+0x5c98): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x311c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x3442): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x3d10): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x82b4): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x8300): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x8334): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x89f4): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x8a3c): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x8a70): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0xb2e8): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x1184): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x3420): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x3440): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x3460): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x3d6c): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x3e28): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x41a6): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x4df0): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xa310): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xa35c): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xa390): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xab04): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xab50): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xab84): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xca1c): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xca20): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x1263c): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x53a0): Section mismatch in reference from the function __ffs_func_bind_do_descs() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x546c): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x57ea): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x9978): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xe0ec): Section mismatch in reference from the function .__ffs_func_bind_do_descs() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xe2cc): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xe318): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xe34c): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xeac0): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xeb0c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xeb40): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_hid.o(.text+0x10c4): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_hid.o(.text+0x3750): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_hid.o(.text+0x3e64): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_hid.o(.text+0x5aa4): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0x42a6): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0xab18): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0xab74): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0xb48c): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0xbc7c): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x15bb8): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x15c14): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x15e28): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x15e74): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x15ea8): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x1661c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x16668): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x1669c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x16d5c): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x16da4): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x16dd8): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x8780): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x889a): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x8c1a): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x8f40): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xe1c0): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xf37c): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ncm.o(.text+0x30ec): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ncm.o(.text+0x82a8): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x38b2): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x3bd8): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x4020): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x97a0): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x97ec): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x9820): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x9ee0): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x9f28): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x9f5c): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0xc7d4): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x2436): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x4d10): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x6278): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x62c0): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x62f4): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x8b6c): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_webcam.o(.text+0x68f4): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_webcam.o(.text+0x83e4): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_zero.o(.text+0x5c08): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_zero.o(.text+0x62a8): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/video/sm501fb.o(.text+0x180c): Section mismatch in reference from the function sm501fb_init_fb() to the variable .devinit.data:sm501_default_mode:  => N/A
  + warning: vmlinux.o (.xt.lit): unexpected non-allocatable section.:  => N/A
  + warning: vmlinux.o (.xt.prop): unexpected non-allocatable section.:  => N/A
  + warning: vmlinux.o(.text+0x2c6c14): Section mismatch in reference from the function parport_pc_probe_port() to the function .init.text:platform_device_register_resndata():  => N/A
  + warning: vmlinux.o(.text+0x33ce4): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x5b840): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x61ba4): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: vmlinux.o(.text+0x61bc0): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: vmlinux.o(.text+0x61bdc): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: vmlinux.o(.text+0x74228): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: vmlinux.o(.text+0x742d8): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.reserve_bootmem_node():  => N/A
  + warning: vmlinux.o(.text+0x7430c): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: vmlinux.o(.text+0x7d42): Section mismatch in reference from the function atari_stram_alloc() to the function .init.text:__alloc_bootmem_low():  => N/A
  + warning: vmlinux.o(.text+0x92f0): Section mismatch in reference from the function .start_secondary_prolog() to the function .devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x9304): Section mismatch in reference from the function .start_secondary_resume() to the function .devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0xa2a78): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0xa8838): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0xb32c0): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0xb3350): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0xb33a8): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A
  + warning: vmlinux.o(.text+0xb8a6e): Section mismatch in reference from the variable system_reset_iSeries to the variable .init.data:boot_paca:  => N/A

131 improvements:
  - .config: warning: symbol value '' invalid for X86_INTERNODE_CACHE_SHIFT: 249 => 
  - modpost: WARNING: modpost: Found 16 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 28 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 55 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 8 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 9 section mismatch(es).: N/A => 
  - src/Documentation/accounting/getdelays.c: warning: passing argument 2 of 'send_cmd' makes pointer from integer without a cast: 179 => 
  - src/Documentation/spi/spidev_test.c: warning: (near initialization for 'tr'): 52, 53, 57, 56, 55, 54 => 
  - src/Documentation/spi/spidev_test.c: warning: excess elements in struct initializer: 52, 53, 57, 56, 55, 54 => 
  - src/arch/cris/arch-v32/drivers/axisflashmap.c: warning: ISO C90 forbids mixed declarations and code: 403, 530 => 
  - src/arch/cris/arch-v32/drivers/axisflashmap.c: warning: cast to pointer from integer of different size: 593 => 
  - src/arch/cris/arch-v32/drivers/axisflashmap.c: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'uint64_t': 342 => 
  - src/arch/cris/arch-v32/kernel/debugport.c: warning: ISO C90 forbids mixed declarations and code: 123 => 
  - src/arch/cris/arch-v32/kernel/fasttimer.c: warning: ISO C90 forbids mixed declarations and code: 353 => 
  - src/arch/cris/arch-v32/kernel/ptrace.c: warning: unused variable 'tmp': 118 => 
  - src/arch/cris/arch-v32/mach-a3/pinmux.c: warning: ISO C90 forbids mixed declarations and code: 273, 96 => 
  - src/arch/cris/arch-v32/mach-fs/pinmux.c: warning: ISO C90 forbids mixed declarations and code: 225, 97 => 
  - src/arch/cris/arch-v32/mm/intmem.c: warning: comparison of distinct pointer types lacks a cast: 123, 116 => 
  - src/arch/cris/arch-v32/mm/intmem.c: warning: initialization from incompatible pointer type: 149 => 
  - src/arch/ia64/kernel/mca.c: warning: assignment makes pointer from integer without a cast: 1862 => 
  - src/arch/ia64/sn/pci/tioca_provider.c: warning: initialization from incompatible pointer type: 660, 659 => 
  - src/arch/m68k/include/asm/atarihw.h: warning: this is the location of the previous definition: 403:1, 402:1 => 
  - src/arch/m68k/kernel/setup.c: warning: unused variable 'i': 218 => 
  - src/arch/s390/kvm/../../../virt/kvm/kvm_main.c: warning: 'kvm_create_dirty_bitmap' defined but not used: 597 => 
  - src/arch/x86/kernel/pci-gart_64.c: warning: 'info.aper_base' may be used uninitialized in this function: 745 => 
  - src/arch/x86/platform/scx200/scx200_32.c: warning: 'base' may be used uninitialized in this function: 82 => 
  - src/drivers/acpi/acpica/nsrepair.c: warning: 'new_object' may be used uninitialized in this function: 125 => 
  - src/drivers/block/xd.c: warning: 'address' may be used uninitialized in this function: 159 => 
  - src/drivers/block/xd.c: warning: 'controller' may be used uninitialized in this function: 158 => 
  - src/drivers/char/cyclades.c: warning: 'cyz_interrupt' defined but not used: 1200, 1201 => 
  - src/drivers/char/rocket.c: warning: 'rmSpeakerReset' defined but not used: 3167, 3166 => 
  - src/drivers/char/rocket.c: warning: 'sPCIInitController' defined but not used: 2625, 2630 => 
  - src/drivers/dma/pch_dma.c: warning: 'pch_dma_resume' defined but not used: 755 => 
  - src/drivers/dma/pch_dma.c: warning: 'pch_dma_suspend' defined but not used: 741 => 
  - src/drivers/dma/pch_dma.c: warning: assignment makes pointer from integer without a cast: 786 => 
  - src/drivers/edac/i7300_edac.c: warning: 'nr_pages' may be used uninitialized in this function: 780 => 
  - src/drivers/gpio/ml_ioh_gpio.c: warning: 'ioh_gpio_restore_reg_conf' defined but not used: 152 => 
  - src/drivers/gpio/ml_ioh_gpio.c: warning: 'ioh_gpio_save_reg_conf' defined but not used: 143 => 
  - src/drivers/gpu/drm/drm_pci.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast: 109, 84 => 
  - src/drivers/gpu/drm/drm_vm.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast: 308 => 
  - src/drivers/gpu/drm/radeon/radeon_gart.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type: 69 => 
  - src/drivers/infiniband/hw/amso1100/c2_qp.c: warning: 'actual_sge_count' may be used uninitialized in this function: 799, 961 => 
  - src/drivers/infiniband/hw/amso1100/c2_qp.c: warning: 'tot_len' may be used uninitialized in this function: 798 => 
  - src/drivers/infiniband/hw/ipath/ipath_driver.c: warning: 'pnum' may be used uninitialized in this function: 1635 => 
  - src/drivers/infiniband/hw/nes/nes.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result: 1140 => 
  - src/drivers/input/keyboard/tc3589x-keypad.c: warning: 'tc3589x_keypad_resume' defined but not used: 425 => 
  - src/drivers/input/keyboard/tc3589x-keypad.c: warning: 'tc3589x_keypad_suspend' defined but not used: 406 => 
  - src/drivers/input/misc/cma3000_d0x.c: warning: comparison is always false due to limited range of data type: 320, 121 => 
  - src/drivers/leds/leds-gpio.c: warning: 'flags' may be used uninitialized in this function: 251 => 
  - src/drivers/media/dvb/b2c2/flexcop-fe-tuner.c: warning: 'flexcop_set_voltage' defined but not used: 31 => 
  - src/drivers/media/dvb/b2c2/flexcop-fe-tuner.c: warning: 'flexcop_sleep' defined but not used: 59 => 
  - src/drivers/message/i2o/i2o_config.c: warning: cast to pointer from integer of different size: 881, 936 => 
  - src/drivers/mfd/mc13xxx-core.c: warning: 'id' may be used uninitialized in this function: 716 => 
  - src/drivers/mfd/tc3589x.c: warning: 'tc3589x_resume' defined but not used: 374 => 
  - src/drivers/mfd/tc3589x.c: warning: 'tc3589x_suspend' defined but not used: 360 => 
  - src/drivers/misc/pch_phub.c: warning: 'pch_phub_restore_reg_conf' defined but not used: 180 => 
  - src/drivers/misc/pch_phub.c: warning: 'pch_phub_save_reg_conf' defined but not used: 121 => 
  - src/drivers/misc/sgi-gru/grufault.c: warning: 'paddr' may be used uninitialized in this function: 265 => 
  - src/drivers/misc/sgi-gru/grufault.c: warning: 'ps' may be used uninitialized in this function: 266 => 
  - src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2288 bytes is larger than 2048 bytes: 658 => 
  - src/drivers/net/atl1c/atl1c_main.c: warning: 'atl1c_resume' defined but not used: 2543 => 
  - src/drivers/net/qlcnic/qlcnic_main.c: warning: 'pci_using_dac' may be used uninitialized in this function: 1469 => 
  - src/drivers/net/s2io.c: warning: 'tcp_len' may be used uninitialized in this function: 7559 => 
  - src/drivers/net/sky2.c: warning: 'sky2_resume' defined but not used: 4988 => 
  - src/drivers/net/sky2.c: warning: control reaches end of non-void function: 2953 => 
  - src/drivers/net/wan/farsync.c: warning: cast to pointer from integer of different size: 1408 => 
  - src/drivers/net/wireless/rtlwifi/pci.c: warning: unused variable 'rtlpci': 1435 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h: warning: "GPIO_IN" redefined: 353:1 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h: warning: "GPIO_OUT" redefined: 354:1 => 
  - src/drivers/rtc/rtc-cmos.c: warning: 'cmos_resume' defined but not used: 907 => 
  - src/drivers/scsi/bfa/bfa_fcpim.c: warning: left shift count >= width of type: 2125, 2113 => 
  - src/drivers/scsi/bfa/bfa_fcpim.c: warning: right shift count >= width of type: 2125, 2113 => 
  - src/drivers/scsi/mpt2sas/mpt2sas_base.c: warning: right shift count >= width of type: 3166, 3164 => 
  - src/drivers/scsi/pmcraid.c: warning: passing argument 2 of 'access_ok' makes pointer from integer without a cast: 3811 => 
  - src/drivers/tty/serial/pch_uart.c: warning: cast from pointer to integer of different size: 779 => 
  - src/drivers/usb/gadget/u_ether.c: warning: comparison of distinct pointer types lacks a cast: 244 => 
  - src/drivers/usb/host/ehci-hub.c: warning: 'ehci_adjust_port_wakeup_flags' defined but not used: 109 => 
  - src/drivers/usb/host/ehci-lpm.c: warning: 'ehci_lpm_check' defined but not used: 40 => 
  - src/drivers/usb/host/ehci-lpm.c: warning: 'ehci_lpm_set_da' defined but not used: 20 => 
  - src/drivers/usb/host/ohci-hub.c: warning: 'ohci_finish_controller_resume' defined but not used: 318 => 
  - src/drivers/video/via/via-core.c: warning: assignment discards qualifiers from pointer target type: 684 => 
  - src/drivers/video/via/via_i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:359): 212 => 
  - src/drivers/video/via/viafbdev.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result: 1380, 1214, 1417, 1311, 1144, 1272 => 
  - src/fs/cifs/cifssmb.c: warning: 'pdata' may be used uninitialized in this function: 3141 => 
  - src/fs/eventpoll.c: warning: 'slack' may be used uninitialized in this function: 1143 => 
  - src/fs/fat/namei_vfat.c: warning: 'lcase' may be used uninitialized in this function: 605 => 
  - src/fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in this function: 610 => 
  - src/fs/freevxfs/vxfs_lookup.c: warning: 'pp' may be used uninitialized in this function: 178 => 
  - src/fs/gfs2/inode.c: warning: 'inode' may be used uninitialized in this function: 188 => 
  - src/fs/ocfs2/cluster/tcp.c: warning: 'o2net_get_func_run_time' defined but not used: 213 => 
  - src/fs/qnx4/namei.c: warning: 'ino' may be used uninitialized in this function: 103 => 
  - src/include/linux/mtd/cfi.h: warning: #warning No CONFIG_MTD_CFI_Ix selected. No NOR chip support can work.: 75:2 => 
  - src/kernel/debug/debug_core.c: warning: value computed is not used: 512, 497 => 
  - src/net/batman-adv/vis.c: warning: passing argument 2 of 'compare_orig' discards qualifiers from pointer target type: 117 => 
  - src/net/mac80211/tx.c: warning: unused variable 'mppath': 1753 => 
  - src/net/netfilter/xt_socket.c: warning: 'daddr' may be used uninitialized in this function: 262 => 
  - src/net/netfilter/xt_socket.c: warning: 'dport' may be used uninitialized in this function: 263 => 
  - src/net/netfilter/xt_socket.c: warning: 'saddr' may be used uninitialized in this function: 262 => 
  - src/net/netfilter/xt_socket.c: warning: 'sport' may be used uninitialized in this function: 263 => 
  - src/net/sctp/socket.c: warning: 'newsock' may be used uninitialized in this function: 4074 => 
  - src/net/sctp/tsnmap.c: warning: 'end' may be used uninitialized in this function: 347 => 
  - src/net/sctp/tsnmap.c: warning: 'start' may be used uninitialized in this function: 347 => 
  - src/sound/drivers/serial-u16550.c: warning: 'uart' may be used uninitialized in this function: 905 => 
  - src/sound/oss/dmabuf.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast: 139 => 
  - src/sound/oss/pss.c: warning: 'check_region' is deprecated (declared at /scratch/kisskb/src/include/linux/ioport.h:170): 676 => 
  - src/sound/pci/atiixp.c: warning: 'chip' may be used uninitialized in this function: 1652 => 
  - src/sound/pci/atiixp_modem.c: warning: 'chip' may be used uninitialized in this function: 1288 => 
  - src/sound/pci/ctxfi/ctvmem.c: warning: 'entry' may be used uninitialized in this function: 34, 80 => 
  - src/sound/pci/lx6464es/lx6464es.c: warning: cast to pointer from integer of different size: 456 => 
  - src/sound/pci/lx6464es/lx_core.c: warning: cast to pointer from integer of different size: 1185 => 
  - src/sound/pci/via82xx.c: warning: 'chip' may be used uninitialized in this function: 2503 => 
  - src/sound/pci/via82xx_modem.c: warning: 'chip' may be used uninitialized in this function: 1168 => 
  - src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_ratio' may be used uninitialized in this function: 744 => 
  - src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_slow_lock_ref' may be used uninitialized in this function: 744 => 
  - src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fllclk_div' may be used uninitialized in this function: 744 => 
  - src/sound/soc/codecs/wm8900.c: warning: 'fll_div.k' may be used uninitialized in this function: 744 => 
  - src/sound/soc/codecs/wm8900.c: warning: 'fll_div.n' may be used uninitialized in this function: 744 => 
  - src/sound/soc/codecs/wm8985.c: warning: 'pll_div.div2' may be used uninitialized in this function: 785 => 
  - src/sound/soc/codecs/wm8985.c: warning: 'pll_div.k' may be used uninitialized in this function: 785 => 
  - src/sound/soc/codecs/wm8985.c: warning: 'pll_div.n' may be used uninitialized in this function: 785 => 
  - src/sound/soc/soc-core.c: warning: 'compress_type' may be used uninitialized in this function: 1719 => 
  - warning: "cause_of_death" [vmlinux] is COMMON symbol: N/A => 
  - warning: (ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS): N/A => 
  - warning: (CPU_SUBTYPE_SH7720 && CPU_SUBTYPE_SH7721 && CPU_SUBTYPE_SH7763 && CPU_SUBTYPE_SH7786) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
  - warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF): N/A => 
  - warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && DWARF_UNWINDER && FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS): N/A => 
  - warning: (NETFILTER_XT_MATCH_REALM) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED): N/A => 
  - warning: (PAGE_POISONING) selects DEBUG_PAGEALLOC which has unmet direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC && (!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK): N/A => 
  - warning: (SERIAL_PCH_UART) selects PCH_DMA which has unmet direct dependencies (DMADEVICES && PCI && X86): N/A => 
  - warning: (STUB_POULSBO && DRM_I915) selects ACPI_VIDEO which has unmet direct dependencies (ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT): N/A => 
  - warning: 3 bad relocations: N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
