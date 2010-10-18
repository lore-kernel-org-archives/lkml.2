Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab0JRIsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:48:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47141 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab0JRIsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Gz2bm+5TdT84RHgkAv0Zp5LXOB6KGsnD7s3kvDtbOPE+fxLFTf7QHksGhl5m0njBb2
         2pUaZs3g0UMN8kWhnyiK9kmp3WrreAo6GH7XB4EeeZ+EiRENAjAgSaroo+y3icYVN3L4
         JtQtUY+bfSZdVdMdXT4xopC2WhHD6PMQLffUU=
MIME-Version: 1.0
In-Reply-To: <20101017201318.4e1ac3b0.sfr@canb.auug.org.au>
References: <alpine.DEB.2.00.1010161656590.12912@ayla.of.borg>
	<alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
	<20101017092621.67ac74e0.sfr@canb.auug.org.au>
	<AANLkTi=ZFUkXebqw9-NUzT48KK58PyaJF7DSpxKJeGm8@mail.gmail.com>
	<20101017201318.4e1ac3b0.sfr@canb.auug.org.au>
Date: Mon, 18 Oct 2010 10:48:50 +0200
X-Google-Sender-Auth: fTPRY7rIwWOzs-N89FfJ7Yf6btI
Message-ID: <AANLkTi=WDRX+tWJFoZxB+7e6=RBCCgOp=VJtht2cGB3R@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.36-rc8
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 11:13, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Ah, light dawns ... kisskb, when it gets a failure, attempts to do a
> bisect between the failing kernel and the last kernel that built.
> Consequently, the log of the bisect attempts will contain some of the
> other errors that occurred since the kernel built correctly.  (As an
> aside, the bisect script appears not to work very well ... :-( )
>
> You were unlucky here that the m68k build went through a series of
> different build problems without getting a good build.
>
> You could try cutting the log off after seeing "make failed, trying to
> bisect".

Thanks for reminding me, I forgot to take that into account :-(

Now it starts looking better:
  - v2.6.35 to v2.6.36-rc8:
        * build errors: +124/-51
        * build warnings: +98/-196
  - v2.6.36-rc7 to v2.6.36-rc8:
        * build errors: +115/-50
        * build warnings: +95/-114

I also updated the summaries on kernel.org.

*** ERRORS ***

124 regressions:
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/cgroupstats.h:
error: expected specifier-qualifier-list before ‘__u64’:  => 32
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/connector.h:
error: expected specifier-qualifier-list before ‘__u32’:  => 67, 60
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/errqueue.h:
error: expected specifier-qualifier-list before ‘__u32’:  => 7
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/genetlink.h:
error: expected specifier-qualifier-list before ‘__u8’:  => 13
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_addr.h:
error: expected specifier-qualifier-list before ‘__u32’:  => 49
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_addr.h:
error: expected specifier-qualifier-list before ‘__u8’:  => 8
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_link.h:
error: expected specifier-qualifier-list before ‘__u32’:  => 272, 203,
261, 267, 9, 173, 216, 256
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_link.h:
error: expected specifier-qualifier-list before ‘__u64’:  => 42, 75
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/if_link.h:
error: expected specifier-qualifier-list before ‘__u8’:  => 345
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/neighbour.h:
error: expected specifier-qualifier-list before ‘__u16’:  => 130
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/neighbour.h:
error: expected specifier-qualifier-list before ‘__u32’:  => 58
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/neighbour.h:
error: expected specifier-qualifier-list before ‘__u64’:  => 90
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/neighbour.h:
error: expected specifier-qualifier-list before ‘__u8’:  => 124, 8
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/netlink.h:
error: expected specifier-qualifier-list before ‘__u16’:  => 125
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/netlink.h:
error: expected specifier-qualifier-list before ‘__u32’:  => 38, 33,
105
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/rtnetlink.h:
error: expected specifier-qualifier-list before ‘__u32’:  => 472, 330,
458
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/rtnetlink.h:
error: expected specifier-qualifier-list before ‘__u8’:  => 386, 504
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/spi/spidev.h:
error: expected specifier-qualifier-list before ‘__u64’:  => 86
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/taskstats.h:
error: expected specifier-qualifier-list before ‘__u16’:  => 46
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:
error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘__be16’:  => 28
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:
error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘__be32’:  => 30
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:
error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘__be64’:  => 32
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:
error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘__le16’:  => 27
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:
error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘__le32’:  => 29
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:
error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘__le64’:  => 31
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:
error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘__sum16’:  => 34
	build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:
error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘__wsum’:  => 35
	error: No rule to make target include/config/auto.conf:  => N/A
	init/Kconfig: error: recursive dependency detected!:  => 985
	src/Documentation/accounting/getdelays.c: error: (Each undeclared
identifier is reported only once:  => 131
	src/Documentation/accounting/getdelays.c: error: expected declaration
specifiers or ‘...’ before ‘__u16’:  => 119, 120
	src/Documentation/accounting/getdelays.c: error: expected declaration
specifiers or ‘...’ before ‘__u32’:  => 119
	src/Documentation/accounting/getdelays.c: error: expected declaration
specifiers or ‘...’ before ‘__u8’:  => 120
	src/Documentation/accounting/getdelays.c: error: expected expression
before ‘)’ token:  => 188
	src/Documentation/accounting/getdelays.c: error: expected ‘;’ before
‘id’:  => 251
	src/Documentation/accounting/getdelays.c: error: expected ‘;’ before
‘mypid’:  => 252
	src/Documentation/accounting/getdelays.c: error: expected ‘=’, ‘,’,
‘;’, ‘asm’ or ‘__attribute__’ before ‘stime’:  => 53
	src/Documentation/accounting/getdelays.c: error: for each function it
appears in.):  => 131
	src/Documentation/accounting/getdelays.c: error: too many arguments
to function ‘send_cmd’:  => 360, 375, 494, 390, 178
	src/Documentation/accounting/getdelays.c: error: ‘__u16’ undeclared
(first use in this function):  => 251, 188
	src/Documentation/accounting/getdelays.c: error: ‘__u32’ undeclared
(first use in this function):  => 252
	src/Documentation/accounting/getdelays.c: error: ‘genl_cmd’
undeclared (first use in this function):  => 135
	src/Documentation/accounting/getdelays.c: error: ‘id’ undeclared
(first use in this function):  => 350
	src/Documentation/accounting/getdelays.c: error: ‘mypid’ undeclared
(first use in this function):  => 349
	src/Documentation/accounting/getdelays.c: error: ‘nla_type’
undeclared (first use in this function):  => 138
	src/Documentation/accounting/getdelays.c: error: ‘nlmsg_pid’
undeclared (first use in this function):  => 134
	src/Documentation/accounting/getdelays.c: error: ‘nlmsg_type’
undeclared (first use in this function):  => 131
	src/Documentation/accounting/getdelays.c: error: ‘struct cgroupstats’
has no member named ‘nr_io_wait’:  => 231
	src/Documentation/accounting/getdelays.c: error: ‘struct cgroupstats’
has no member named ‘nr_running’:  => 232
	src/Documentation/accounting/getdelays.c: error: ‘struct cgroupstats’
has no member named ‘nr_sleeping’:  => 230
	src/Documentation/accounting/getdelays.c: error: ‘struct cgroupstats’
has no member named ‘nr_stopped’:  => 233
	src/Documentation/accounting/getdelays.c: error: ‘struct cgroupstats’
has no member named ‘nr_uninterruptible’:  => 234
	src/Documentation/accounting/getdelays.c: error: ‘struct genlmsghdr’
has no member named ‘cmd’:  => 135
	src/Documentation/accounting/getdelays.c: error: ‘struct genlmsghdr’
has no member named ‘version’:  => 136
	src/Documentation/accounting/getdelays.c: error: ‘struct nlattr’ has
no member named ‘nla_len’:  => 474, 461, 186, 141, 139, 435, 430
	src/Documentation/accounting/getdelays.c: error: ‘struct nlattr’ has
no member named ‘nla_type’:  => 431, 484, 138, 471, 441, 187
	src/Documentation/accounting/getdelays.c: error: ‘struct nlmsghdr’
has no member named ‘nlmsg_flags’:  => 132
	src/Documentation/accounting/getdelays.c: error: ‘struct nlmsghdr’
has no member named ‘nlmsg_len’:  => 413, 130, 182, 424, 144, 141, 420
	src/Documentation/accounting/getdelays.c: error: ‘struct nlmsghdr’
has no member named ‘nlmsg_pid’:  => 134
	src/Documentation/accounting/getdelays.c: error: ‘struct nlmsghdr’
has no member named ‘nlmsg_seq’:  => 133
	src/Documentation/accounting/getdelays.c: error: ‘struct nlmsghdr’
has no member named ‘nlmsg_type’:  => 131, 412, 181
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘ac_comm’:  => 241
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘blkio_count’:  => 209
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘blkio_delay_total’:  => 210
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘cancelled_write_bytes’:  => 244
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘cpu_count’:  => 204
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘cpu_delay_total’:  => 207
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘cpu_run_real_total’:  => 205
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘cpu_run_virtual_total’:  => 206
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘freepages_count’:  => 215
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘freepages_delay_total’:  => 216
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘nivcsw’:  => 224
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘nvcsw’:  => 224
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘read_bytes’:  => 242
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘swapin_count’:  => 212
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘swapin_delay_total’:  => 213
	src/Documentation/accounting/getdelays.c: error: ‘struct taskstats’
has no member named ‘write_bytes’:  => 243
	src/Documentation/connector/ucon.c: error: (Each undeclared
identifier is reported only once:  => 71
	src/Documentation/connector/ucon.c: error: expected ‘=’, ‘,’, ‘;’,
‘asm’ or ‘__attribute__’ before ‘seq’:  => 58
	src/Documentation/connector/ucon.c: error: for each function it
appears in.):  => 71
	src/Documentation/connector/ucon.c: error: ‘seq’ undeclared (first
use in this function):  => 71, 186
	src/Documentation/connector/ucon.c: error: ‘struct cb_id’ has no
member named ‘idx’:  => 240, 195, 184
	src/Documentation/connector/ucon.c: error: ‘struct cb_id’ has no
member named ‘val’:  => 240, 185, 195
	src/Documentation/connector/ucon.c: error: ‘struct cn_msg’ has no
member named ‘ack’:  => 240, 187
	src/Documentation/connector/ucon.c: error: ‘struct cn_msg’ has no
member named ‘len’:  => 188, 68, 82
	src/Documentation/connector/ucon.c: error: ‘struct cn_msg’ has no
member named ‘seq’:  => 240, 186
	src/Documentation/connector/ucon.c: error: ‘struct nlmsghdr’ has no
member named ‘nlmsg_flags’:  => 75
	src/Documentation/connector/ucon.c: error: ‘struct nlmsghdr’ has no
member named ‘nlmsg_len’:  => 74
	src/Documentation/connector/ucon.c: error: ‘struct nlmsghdr’ has no
member named ‘nlmsg_pid’:  => 72
	src/Documentation/connector/ucon.c: error: ‘struct nlmsghdr’ has no
member named ‘nlmsg_seq’:  => 71
	src/Documentation/connector/ucon.c: error: ‘struct nlmsghdr’ has no
member named ‘nlmsg_type’:  => 73, 230
	src/Documentation/connector/ucon.c: error: ‘struct sockaddr_nl’ has
no member named ‘nl_groups’:  => 160
	src/Documentation/connector/ucon.c: error: ‘struct sockaddr_nl’ has
no member named ‘nl_pid’:  => 161
	src/Documentation/networking/timestamping/timestamping.c: error:
‘struct sock_extended_err’ has no member named ‘ee_errno’:  => 226
	src/Documentation/networking/timestamping/timestamping.c: error:
‘struct sock_extended_err’ has no member named ‘ee_origin’:  => 229,
227
	src/Documentation/spi/spidev_fdx.c: error: (Each undeclared
identifier is reported only once:  => 81
	src/Documentation/spi/spidev_fdx.c: error: expected ‘;’ before ‘mode’:  => 81
	src/Documentation/spi/spidev_fdx.c: error: expected ‘;’ before ‘speed’:  => 82
	src/Documentation/spi/spidev_fdx.c: error: for each function it
appears in.):  => 81
	src/Documentation/spi/spidev_fdx.c: error: ‘__u32’ undeclared (first
use in this function):  => 82
	src/Documentation/spi/spidev_fdx.c: error: ‘__u8’ undeclared (first
use in this function):  => 81
	src/Documentation/spi/spidev_fdx.c: error: ‘bits’ undeclared (first
use in this function):  => 92
	src/Documentation/spi/spidev_fdx.c: error: ‘mode’ undeclared (first
use in this function):  => 84
	src/Documentation/spi/spidev_fdx.c: error: ‘speed’ undeclared (first
use in this function):  => 96
	src/Documentation/spi/spidev_fdx.c: error: ‘struct spi_ioc_transfer’
has no member named ‘len’:  => 65, 62
	src/Documentation/spi/spidev_fdx.c: error: ‘struct spi_ioc_transfer’
has no member named ‘rx_buf’:  => 64
	src/Documentation/spi/spidev_fdx.c: error: ‘struct spi_ioc_transfer’
has no member named ‘tx_buf’:  => 61
	src/Documentation/spi/spidev_test.c: error: (Each undeclared
identifier is reported only once:  => 171
	src/Documentation/spi/spidev_test.c: error: for each function it
appears in.):  => 171
	src/Documentation/spi/spidev_test.c: error: unknown field
‘bits_per_word’ specified in initializer:  => 57
	src/Documentation/spi/spidev_test.c: error: unknown field
‘delay_usecs’ specified in initializer:  => 55
	src/Documentation/spi/spidev_test.c: error: unknown field ‘len’
specified in initializer:  => 54
	src/Documentation/spi/spidev_test.c: error: unknown field ‘rx_buf’
specified in initializer:  => 53
	src/Documentation/spi/spidev_test.c: error: unknown field ‘speed_hz’
specified in initializer:  => 56
	src/Documentation/spi/spidev_test.c: error: unknown field ‘tx_buf’
specified in initializer:  => 52
	src/Documentation/spi/spidev_test.c: error: ‘__u32’ undeclared (first
use in this function):  => 193
	src/Documentation/spi/spidev_test.c: error: ‘__u8’ undeclared (first
use in this function):  => 171
	src/arch/avr32/include/asm/syscalls.h: error: previous declaration of
‘sys_execve’ was here:  => 25
	src/arch/avr32/kernel/process.c: error: conflicting types for
‘sys_execve’:  => 390
	src/arch/sh/include/asm/syscalls_32.h: error: previous declaration of
'sys_execve' was here:  => 22
	src/arch/sh/kernel/process_32.c: error: conflicting types for
'sys_execve':  => 299
	src/drivers/net/3c59x.c: error: request for member 'current_state' in
something not a structure or union:  => 3211
	src/fs/ceph/mds_client.c: error: insn does not satisfy its
constraints::  => 3192
	src/include/linux/kprobes.h: error: dereferencing pointer to
incomplete type:  => 316

51 improvements:
	error: vga16fb.c: undefined reference to `vgacon_remap_base':
.devinit.text+0x1a8fa), .devinit.text+0x1a8fe) =>
	error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL
against `.text'+718: (.text+0xb1e) =>
	src/arch/cris/arch-v10/kernel/irq.c: error: implicit declaration of
function 'breakpoint': 261 =>
	src/arch/cris/arch-v10/kernel/irq.c: error: implicit declaration of
function 'kgdb_init': 260 =>
	src/arch/powerpc/sysdev/fsl_rio.c: error: 'MCSR_MASK' undeclared
(first use in this function): 248 =>
	src/arch/powerpc/sysdev/fsl_rio.c: error: (Each undeclared identifier
is reported only once: 248 =>
	src/arch/powerpc/sysdev/fsl_rio.c: error: for each function it
appears in.): 248 =>
	src/arch/sparc/include/asm/uaccess_64.h: error: call to
'copy_from_user_overflow' declared with attribute error:
copy_from_user() buffer size is not provably correct: 232 =>
	src/arch/xtensa/include/asm/pgalloc.h: error: implicit declaration of
function 'kmem_cache_alloc': 47 =>
	src/arch/xtensa/include/asm/pgalloc.h: error: implicit declaration of
function 'kmem_cache_free': 62 =>
	src/arch/xtensa/platforms/iss/network.c: error: 'struct net_device'
has no member named 'change_mtu': 697 =>
	src/arch/xtensa/platforms/iss/network.c: error: 'struct net_device'
has no member named 'get_stats': 693 =>
	src/arch/xtensa/platforms/iss/network.c: error: 'struct net_device'
has no member named 'hard_start_xmit': 691 =>
	src/arch/xtensa/platforms/iss/network.c: error: 'struct net_device'
has no member named 'open': 690 =>
	src/arch/xtensa/platforms/iss/network.c: error: 'struct net_device'
has no member named 'set_mac_address': 696 =>
	src/arch/xtensa/platforms/iss/network.c: error: 'struct net_device'
has no member named 'set_multicast_list': 694 =>
	src/arch/xtensa/platforms/iss/network.c: error: 'struct net_device'
has no member named 'stop': 692 =>
	src/arch/xtensa/platforms/iss/network.c: error: 'struct net_device'
has no member named 'tx_timeout': 695 =>
	src/drivers/gpio/gpiolib.c: error: 'ARCH_NR_GPIOS' undeclared here
(not in a function): 68 =>
	src/drivers/gpio/gpiolib.c: error: 'GPIOF_DIR_IN' undeclared (first
use in this function): 1261 =>
	src/drivers/gpio/gpiolib.c: error: 'GPIOF_INIT_HIGH' undeclared
(first use in this function): 1265 =>
	src/drivers/gpio/gpiolib.c: error: (Each undeclared identifier is
reported only once: 1261 =>
	src/drivers/gpio/gpiolib.c: error: arithmetic on pointer to an
incomplete type: 1302, 1289, 1280 =>
	src/drivers/gpio/gpiolib.c: error: decrement of pointer to unknown
structure: 1289 =>
	src/drivers/gpio/gpiolib.c: error: dereferencing pointer to
incomplete type: 1588, 743, 1720, 1428, 1410, 942, 1481, 1637, 943,
1375, 598, 1532, 1423, 1360, 1721, 1013, 1188, 986, 1138, 1413, 1289,
1232, 744, 1531, 1370, 1072, 1604, 1550, 1081, 1614, 1624, 1184, 1233,
750, 1628, 1191, 949, 1077, 1636, 1063, 1483, 1088, 1097, 144, 1281,
100, 1110, 979, 1412, 957, 1230, 589, 749, 1384, 1357, 1471, 1172,
1468, 112, 1321, 1470, 1131, 1570, 1196, 104, 1713, 962, 1373, 1707,
755, 1302, 1359, 1714, 607, 1551, 1237, 1715, 1437, 1426, 1061, 1708
=>
	src/drivers/gpio/gpiolib.c: error: for each function it appears in.): 1261 =>
	src/drivers/gpio/gpiolib.c: error: increment of pointer to unknown
structure: 1302, 1280 =>
	src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_direction_input': 1346 =>
	src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_direction_output': 1399 =>
	src/drivers/gpio/gpiolib.c: error: redefinition of 'gpio_export': 721 =>
	src/drivers/gpio/gpiolib.c: error: redefinition of 'gpio_export_link': 807 =>
	src/drivers/gpio/gpiolib.c: error: redefinition of 'gpio_free': 1211 =>
	src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_get_value_cansleep': 1599 =>
	src/drivers/gpio/gpiolib.c: error: redefinition of 'gpio_request': 1157 =>
	src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_set_debounce': 1457 =>
	src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_set_value_cansleep': 1609 =>
	src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_sysfs_set_active_low': 854 =>
	src/drivers/gpio/gpiolib.c: error: redefinition of 'gpio_unexport': 894 =>
	src/include/linux/bio.h: error: #error "You should define
ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform": 396:3 =>
	src/include/linux/blkdev.h: error: #error "You should define
ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform": 762:3 =>
	src/include/linux/gpio.h: error: previous definition of
'gpio_direction_input' was here: 45 =>
	src/include/linux/gpio.h: error: previous definition of
'gpio_direction_output' was here: 50 =>
	src/include/linux/gpio.h: error: previous definition of 'gpio_export'
was here: 93 =>
	src/include/linux/gpio.h: error: previous definition of
'gpio_export_link' was here: 101 =>
	src/include/linux/gpio.h: error: previous definition of 'gpio_free'
was here: 37 =>
	src/include/linux/gpio.h: error: previous definition of
'gpio_get_value_cansleep' was here: 80 =>
	src/include/linux/gpio.h: error: previous definition of
'gpio_request' was here: 32 =>
	src/include/linux/gpio.h: error: previous definition of
'gpio_set_debounce' was here: 55 =>
	src/include/linux/gpio.h: error: previous definition of
'gpio_set_value_cansleep' was here: 87 =>
	src/include/linux/gpio.h: error: previous definition of
'gpio_sysfs_set_active_low' was here: 108 =>
	src/include/linux/gpio.h: error: previous definition of
'gpio_unexport' was here: 115 =>


*** WARNINGS ***

98 regressions:
	.config: warning: override: HIGHMEM4G changes choice state:  => 309
	.config: warning: override: PCI_GOANY changes choice state:  => 421
	.config: warning: override: SLOB changes choice state: 163 => 137, 115
	<stdin>: warning: #warning syscall fanotify_init not implemented:  => 1526:2
	<stdin>: warning: #warning syscall fanotify_mark not implemented:  => 1530:2
	<stdin>: warning: #warning syscall prlimit64 not implemented:  => 1534:2
	modpost: WARNING: modpost: Found 54 section mismatch(es).:  => N/A
	src/Documentation/accounting/getdelays.c: warning: passing argument 2
of ‘send_cmd’ makes pointer from integer without a cast:  => 178
	src/Documentation/spi/spidev_test.c: warning: (near initialization
for ‘tr’):  => 52, 53, 57, 56, 55, 54
	src/Documentation/spi/spidev_test.c: warning: excess elements in
struct initializer:  => 52, 53, 57, 56, 55, 54
	src/arch/sh/math-emu/math.c: warning: right shift count is negative
CC      drivers/char/tty_buffer.o:  => 108
	src/block/blk-merge.c: warning: 'bbio' may be used uninitialized in
this function:  => 18
	src/drivers/atm/nicstar.c: warning: 'err' may be used uninitialized
in this function:  => 956
	src/drivers/char/n_gsm.c: warning: ignoring return value of
'__kfifo_must_check_helper', declared with attribute
warn_unused_result:  => 1580
	src/drivers/gpu/drm/drm_context.c: warning: passing argument 2 of
'__constant_test_and_set_bit' discards qualifiers from pointer target
type:  => 233
	src/drivers/gpu/drm/drm_context.c: warning: passing argument 2 of
'__generic_test_and_set_bit' discards qualifiers from pointer target
type:  => 233
	src/drivers/gpu/drm/drm_pci.c: warning: passing argument 1 of
'virt_to_phys' makes pointer from integer without a cast:  => 109, 84
	src/drivers/gpu/drm/drm_vm.c: warning: passing argument 1 of
'virt_to_phys' makes pointer from integer without a cast:  => 308
	src/drivers/gpu/drm/radeon/radeon_gart.c: warning: passing argument 3
of 'pci_free_consistent' discards qualifiers from pointer target type:
 => 69
	src/drivers/infiniband/hw/amso1100/c2_qp.c: warning:
'actual_sge_count' may be used uninitialized in this function:  =>
799, 961
	src/drivers/infiniband/hw/amso1100/c2_qp.c: warning: 'tot_len' may be
used uninitialized in this function:  => 798
	src/drivers/infiniband/hw/cxgb4/cm.c: warning: cast to pointer from
integer of different size:  => 2326
	src/drivers/infiniband/hw/cxgb4/cq.c: warning: cast from pointer to
integer of different size:  => 58, 135
	src/drivers/infiniband/hw/cxgb4/mem.c: warning: cast from pointer to
integer of different size:  => 74
	src/drivers/infiniband/hw/cxgb4/qp.c: warning: cast from pointer to
integer of different size:  => 147, 1063, 988
	src/drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_fhs'
defined but not used: 319 => 319, 320
	src/drivers/input/misc/hp_sdc_rtc.c: warning:
'hp_sdc_rtc_set_i8042timer' defined but not used: 359 => 360, 359
	src/drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_rt'
defined but not used: 279 => 280, 279
	src/drivers/isdn/hardware/mISDN/mISDNipac.c: warning: unsupported
argument to '__builtin_return_address':  => 754
	src/drivers/isdn/hardware/mISDN/netjet.c: warning: comparison is
always false due to limited range of data type:  => 318
	src/drivers/isdn/hardware/mISDN/w6692.c: warning: unsupported
argument to '__builtin_return_address':  => 1188
	src/drivers/leds/leds-gpio.c: warning: 'flags' may be used
uninitialized in this function:  => 251
	src/drivers/media/dvb/ngene/ngene-core.c: warning: unused variable
'flags':  => 1308
	src/drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' is used
uninitialized in this function:  => 1245
	src/drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' may be
used uninitialized in this function:  => 1707, 1683, 943
	src/drivers/media/video/sh_mobile_ceu_camera.c: warning: unused
variable 'sd':  => 1648
	src/drivers/media/video/videobuf-dma-sg.c: warning: comparison of
distinct pointer types lacks a cast:  => 119, 120
	src/drivers/message/fusion/mptsas.c: warning: unused variable
'log_info':  => 5010
	src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of
2288 bytes is larger than 2048 bytes:  => 657
	src/drivers/mtd/devices/doc2001plus.c: warning: passing argument 2 of
'MemWriteDOC' discards qualifiers from pointer target type:  => 767
	src/drivers/mtd/nand/alauda.c: warning: passing argument 3 of
'alauda_write_page' discards qualifiers from pointer target type:  =>
480
	src/drivers/net/3c59x.c: warning: dereferencing 'void *' pointer:  => 3211
	src/drivers/net/pcmcia/ibmtr_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 235
	src/drivers/net/pcmcia/ibmtr_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 235
	src/drivers/net/pcmcia/nmclan_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 650
	src/drivers/net/pcmcia/nmclan_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 650
	src/drivers/net/pcmcia/smc91c92_cs.c: warning: 'j' may be used
uninitialized in this function:  => 846
	src/drivers/net/tehuti.c: warning: passing argument 2 of
'bdx_tx_push_desc_safe' discards qualifiers from pointer target type:
=> 330
	src/drivers/net/wan/farsync.c: warning: cast to pointer from integer
of different size:  => 1408
	src/drivers/net/wireless/iwmc3200wifi/rx.c: warning: comparison is
always true due to limited range of data type:  => 1198
	src/drivers/net/wireless/libertas/cfg.c: warning: passing argument 3
of 'lbs_deb_hex' discards qualifiers from pointer target type:  => 273
	src/drivers/net/wireless/mwl8k.c: warning: 'ap_legacy_rates' may be
used uninitialized in this function:  => 3403
	src/drivers/net/wireless/p54/p54usb.c: warning: 'p54u_device_reset'
defined but not used:  => 406, 407
	src/drivers/parisc/led.c: warning: assignment from incompatible
pointer type:  => 366
	src/drivers/power/ds2782_battery.c: warning: 'raw' may be used
uninitialized in this function:  => 159, 199
	src/drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be
used uninitialized in this function:  => 115
	src/drivers/regulator/max1586.c: warning: 'selector' may be used
uninitialized in this function:  => 116
	src/drivers/scsi/aic7xxx_old.c: warning: passing argument 3 of
'pci_free_consistent' discards qualifiers from pointer target type:
=> 8490
	src/drivers/scsi/mpt2sas/mpt2sas_base.c: warning: right shift count
>= width of type:  => 3022, 3020
	src/drivers/scsi/pmcraid.c: warning: passing argument 2 of
'access_ok' makes pointer from integer without a cast:  => 3800
	src/drivers/scsi/stex.c: warning: passing argument 2 of
'scsi_sg_copy_from_buffer' discards qualifiers from pointer target
type:  => 636
	src/drivers/usb/gadget/dbgp.c: warning: comparison is always true due
to limited range of data type:  => 389
	src/drivers/usb/gadget/storage_common.c: warning: 'fsg_show_nofua'
defined but not used:  => 718, 720
	src/drivers/usb/gadget/storage_common.c: warning: 'fsg_store_nofua'
defined but not used:  => 782, 785
	src/drivers/usb/host/xhci-ring.c: warning: 'event_trb' may be used
uninitialized in this function:  => 1719
	src/drivers/usb/serial/mos7720.c: warning: 'status' may be used
uninitialized in this function:  => 1385, 1347
	src/drivers/video/metronomefb.c: warning: passing argument 1 of
'load_waveform' discards qualifiers from pointer target type:  => 687
	src/drivers/video/sis/osdef.h: warning: #warning Neither
CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set:  => 100:2
	src/drivers/video/sis/osdef.h: warning: #warning sisfb will not
work!:  => 101:2
	src/drivers/video/sis/sis_main.c: warning: 'sisfb_post_map_vram'
defined but not used:  => 4181
	src/drivers/w1/masters/ds2490.c: warning: passing argument 2 of
'ds_write_block' discards qualifiers from pointer target type:  => 827
	src/fs/autofs/root.c: warning: 'autofs_root_compat_ioctl' declared
'static' but never defined:  => 30
	src/fs/autofs4/root.c: warning: 'autofs4_root_compat_ioctl' declared
'static' but never defined:  => 31
	src/fs/btrfs/ordered-data.c: warning: 'prev' may be used
uninitialized in this function:  => 144
	src/fs/nfsd/nfs4state.c: warning: control reaches end of non-void
function:  => 452
	src/include/sound/tlv320aic3x.h: warning: no newline at end of file:  => 17:7
	src/kernel/module.c: warning: passing argument 2 of 'add_kallsyms'
discards qualifiers from pointer target type:  => 2535
	src/kernel/pm_qos_params.c: warning: control may reach end of
non-void function ‘pm_qos_get_value’ being inlined:  => 200
	src/kernel/pm_qos_params.c: warning: control reaches end of non-void
function:  => 132
	src/kernel/trace/trace_events.c: warning: enumeration value
'TRACE_REG_PERF_REGISTER' not handled in switch:  => 146
	src/kernel/trace/trace_events.c: warning: enumeration value
'TRACE_REG_PERF_UNREGISTER' not handled in switch:  => 146
	src/kernel/trace/trace_functions_graph.c: warning: comparison of
distinct pointer types lacks a cast:  => 652
	src/kernel/watchdog.c: warning: 'watchdog_disable_all_cpus' defined
but not used:  => 484
	src/kernel/watchdog.c: warning: 'watchdog_enable_all_cpus' defined
but not used:  => 471
	src/lib/debugobjects.c: warning: 'obj_states' defined but not used:  => 73
	src/lib/radix-tree.c: warning: 'radix_tree_range_tag_if_tagged' uses
dynamic stack allocation:  => 737
	src/mm/percpu.c: warning: 'pcpu_build_alloc_info' defined but not
used:  => 1094
	src/net/ipv4/inet_connection_sock.c: warning: 'head' may be used
uninitialized in this function:  => 95
	src/net/mac80211/tx.c: warning: unused variable 'mesh_hdr':  => 1702
	src/net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects
type 'signed size_t', but argument 2 has type 'ssize_t':  => 706
	src/net/sunrpc/auth_gss/auth_gss.c: warning: format '%zd' expects
type 'signed size_t', but argument 3 has type 'ssize_t':  => 688
	src/sound/pci/ctxfi/ctvmem.c: warning: 'entry' may be used
uninitialized in this function:  => 34, 80
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 226
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 226
	src/sound/pcmcia/vx/vxpocket.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 233
	src/sound/pcmcia/vx/vxpocket.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 233
	src/sound/soc/codecs/wm_hubs.c: warning: 'reg_l' may be used
uninitialized in this function:  => 95
	src/sound/soc/codecs/wm_hubs.c: warning: 'reg_r' may be used
uninitialized in this function:  => 95

196 improvements:
	.config: warning: override: reassigning to symbol ENABLE_MUST_CHECK: 5171 =>
	.config: warning: override: reassigning to symbol
PROFILE_ALL_BRANCHES: 5169 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD: 120 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD_BLOCK: 173 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD_CFI: 143 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD_CFI_AMDSTD: 146 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD_CFI_INTELEXT: 145 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD_CHAR: 172 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol NET_ETHERNET: 301 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol USB: 497 =>
	arch/ia64/configs/generic_defconfig: warning: symbol value 'm'
invalid for INET_LRO: 317 =>
	arch/m68k/configs/multi_defconfig: warning: symbol value 'm' invalid
for INET_LRO: 222 =>
	arch/m68k/configs/sun3_defconfig: warning: symbol value 'm' invalid
for INET_LRO: 207 =>
	arch/mips/configs/ip22_defconfig: warning: symbol value 'm' invalid
for RFKILL_INPUT: 611 =>
	arch/parisc/configs/a500_defconfig: warning: symbol value 'm' invalid
for PCCARD_NONSTATIC: 199 =>
	arch/powerpc/configs/iseries_defconfig: warning: symbol value 'm'
invalid for GFS2_FS_LOCKING_DLM: 953 =>
	arch/powerpc/configs/pmac32_defconfig: warning: symbol value 'm'
invalid for PCCARD_NONSTATIC: 332 =>
	arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm'
invalid for GFS2_FS_LOCKING_DLM: 3021 =>
	arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm'
invalid for IP_DCCP_CCID3: 683 =>
	arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm'
invalid for IP_DCCP_TFRC_LIB: 686 =>
	modpost: WARNING: modpost: Found 11 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 12 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 26 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 28 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 3 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 4 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 43 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 45 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 49 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 6 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 70 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 81 section mismatch(es).: N/A =>
	src/arch/cris/arch-v10/drivers/axisflashmap.c: warning: format '%08x'
expects type 'unsigned int', but argument 3 has type 'uint64_t': 356,
374, 292 =>
	src/arch/cris/arch-v10/drivers/axisflashmap.c: warning: format '%08x'
expects type 'unsigned int', but argument 4 has type 'uint64_t': 356,
374 =>
	src/arch/cris/arch-v32/mach-a3/pinmux.c: warning: ISO C90 forbids
mixed declarations and code: 273, 96 =>
	src/arch/cris/boot/compressed/misc.c: warning: conflicting types for
built-in function 'puts': 109 =>
	src/arch/cris/boot/compressed/misc.c: warning: value computed is not
used: 182 =>
	src/arch/cris/kernel/profile.c: warning: no return statement in
function returning non-void: 57 =>
	src/arch/powerpc/include/asm/io-defs.h: warning: array subscript is
above array bounds: 6, 11, 9 =>
	src/arch/powerpc/include/asm/io.h: warning: array subscript is above
array bounds: 159 =>
	src/arch/powerpc/kernel/crash_dump.c: warning: comparison of distinct
pointer types lacks a cast: 131 =>
	src/arch/powerpc/kvm/book3s_paired_singles.c: warning: the frame size
of 2288 bytes is larger than 2048 bytes: 1289 =>
	src/arch/powerpc/platforms/52xx/mpc52xx_pci.c: warning: cast to
pointer from integer of different size: 295 =>
	src/arch/powerpc/platforms/52xx/mpc52xx_pci.c: warning: format '%x'
expects type 'unsigned int', but argument 2 has type
'resource_size_t': 277 =>
	src/arch/powerpc/platforms/52xx/mpc52xx_pci.c: warning: format '%x'
expects type 'unsigned int', but argument 3 has type
'resource_size_t': 277 =>
	src/arch/sh/include/cpu-sh4/cpu/cache.h: warning: this is the
location of the previous definition: 20:1 =>
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in
branch to __restore_all; converted into longer instruction sequence:
89 =>
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in
branch to syscall_call; converted into longer instruction sequence:
209 =>
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in
branch to syscall_exit_work; converted into longer instruction
sequence: 364, 361 =>
	src/arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in
branch to syscall_trace_entry; converted into longer instruction
sequence: 337, 335 =>
	src/arch/sh/kernel/cpu/sh2a/clock-sh7201.c: warning: 'return' with a
value, in function returning void: 37 =>
	src/arch/sparc/include/asm/uaccess_32.h: warning: call to
'copy_from_user_overflow' declared with attribute warning:
copy_from_user() buffer size is not provably correct: 276 =>
	src/arch/sparc/include/asm/uaccess_64.h: warning: call to
'copy_from_user_overflow' declared with attribute warning:
copy_from_user() buffer size is not provably correct: 232 =>
	src/arch/x86/kernel/cpu/perf_event.c: warning: 'emptyconstraint'
defined but not used: 1234 =>
	src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_disable_all'
defined but not used: 567 =>
	src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_enable_all'
defined but not used: 602 =>
	src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_enable_event'
defined but not used: 936 =>
	src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_handle_irq'
defined but not used: 1120 =>
	src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_hw_config'
defined but not used: 492 =>
	src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_schedule_events'
defined but not used: 627 =>
	src/arch/xtensa/include/asm/pgalloc.h: warning: return makes pointer
from integer without a cast: 47 =>
	src/crypto/testmgr.c: warning: 'alg_test_crc32c' uses dynamic stack
allocation: 1488 =>
	src/drivers/acpi/acpi_pad.c: warning: 'num_cpus' may be used
uninitialized in this function: 432 =>
	src/drivers/bluetooth/btmrvl_sdio.c: warning: 'fws1' may be used
uninitialized in this function: 80 =>
	src/drivers/char/ip2/ip2main.c: warning: 'ip2main_pci_tbl' defined
but not used: 3206 =>
	src/drivers/char/isicom.c: warning: unused variable 'card': 875 =>
	src/drivers/char/rocket.c: warning: 'rocket_pci_ids' defined but not
used: 1756 =>
	src/drivers/dma/timb_dma.c: warning: cast to pointer from integer of
different size: 203 =>
	src/drivers/gpio/bt8xxgpio.c: warning: ignoring return value of
'gpiochip_remove', declared with attribute warn_unused_result: 247 =>
	src/drivers/gpio/gpiolib.c: warning: 'struct gpio' declared inside
parameter list: 1299, 1276 =>
	src/drivers/gpio/gpiolib.c: warning: its scope is only this
definition or declaration, which is probably not what you want: 1276
=>
	src/drivers/gpio/wm8994-gpio.c: warning: 'wm8994_gpio_to_irq' defined
but not used: 84 =>
	src/drivers/gpu/drm/drm_edid.c: warning: array subscript is above
array bounds: 1525, 1577 =>
	src/drivers/input/keyboard/matrix_keypad.c: warning:
'matrix_keypad_resume' defined but not used: 242 =>
	src/drivers/input/keyboard/matrix_keypad.c: warning:
'matrix_keypad_suspend' defined but not used: 219 =>
	src/drivers/isdn/hisax/config.c: warning: 'hisax_pci_tbl' defined but
not used: 1910 =>
	src/drivers/isdn/i4l/isdn_common.c: warning: unused variable 's': 1284 =>
	src/drivers/media/video/sh_mobile_ceu_camera.c: warning:
'ceu_sub_height' may be used uninitialized in this function: 1517 =>
	src/drivers/media/video/sh_mobile_ceu_camera.c: warning:
'ceu_sub_width' may be used uninitialized in this function: 1517 =>
	src/drivers/mfd/sh_mobile_sdhi.c: warning: 'sh_mobile_sdhi_remove'
defined but not used: 142 =>
	src/drivers/mfd/twl6030-irq.c: warning: cast to pointer from integer
of different size: 267 =>
	src/drivers/misc/enclosure.c: warning: ignoring return value of
'ERR_PTR', declared with attribute warn_unused_result: 289 =>
	src/drivers/misc/hpilo.c: warning: 'ilo_remove' defined but not used: 720 =>
	src/drivers/misc/hpilo.c: warning: cast to pointer from integer of
different size: 275 =>
	src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of
2080 bytes is larger than 2048 bytes: 1800 =>
	src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of
1324 bytes is larger than 1024 bytes: 606 =>
	src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of
2160 bytes is larger than 2048 bytes: 983 =>
	src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of
2368 bytes is larger than 2048 bytes: 658 =>
	src/drivers/mtd/maps/gpio-addr-flash.c: warning: cast to pointer from
integer of different size: 212, 224 =>
	src/drivers/net/arcnet/capmode.c: warning: 'arcnet_cap_init' defined
but not used: 65 =>
	src/drivers/net/bonding/bond_main.c: warning: 'disable_netpoll'
defined but not used: 171 =>
	src/drivers/net/fs_enet/mii-fec.c: warning: format '%x' expects type
'unsigned int', but argument 4 has type 'resource_size_t': 131 =>
	src/drivers/net/gianfar_ethtool.c: warning: the frame size of 2048
bytes is larger than 1024 bytes: 846 =>
	src/drivers/net/ll_temac_main.c: warning: cast to pointer from
integer of different size: 575 =>
	src/drivers/net/mac8390.c: warning: passing argument 1 of
'__builtin_memcpy' makes pointer from integer without a cast: 248 =>
	src/drivers/net/mac8390.c: warning: passing argument 1 of
'word_memcpy_tocard' makes pointer from integer without a cast: 253 =>
	src/drivers/net/mac8390.c: warning: passing argument 2 of
'word_memcpy_fromcard' makes pointer from integer without a cast: 255
=>
	src/drivers/net/pcmcia/ibmtr_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:191): 237 =>
	src/drivers/net/pcmcia/nmclan_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:191): 651 =>
	src/drivers/net/pcmcia/nmclan_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:193): 651 =>
	src/drivers/net/sh_eth.c: warning: unused variable 'i': 1389 =>
	src/drivers/net/sky2.c: warning: control reaches end of non-void
function: 2992 =>
	src/drivers/pci/pcie/aer/aerdrv_core.c: warning: 'e_src.id' may be
used uninitialized in this function: 756 =>
	src/drivers/pci/pcie/aer/aerdrv_core.c: warning: 'e_src.status' may
be used uninitialized in this function: 756 =>
	src/drivers/rtc/rtc-cmos.c: warning: #warning Assuming 128 bytes of
RTC+NVRAM address space, not 64 bytes.: 693:2 =>
	src/drivers/scsi/fdomain.c: warning: 'fdomain_pci_tbl' defined but
not used: 1773 =>
	src/drivers/scsi/initio.c: warning: 'i91u_pci_devices' defined but
not used: 131 =>
	src/drivers/serial/mpc52xx_uart.c: warning: cast to pointer from
integer of different size: 1139, 812, 1272 =>
	src/drivers/serial/ucc_uart.c: warning: format '%x' expects type
'unsigned int', but argument 3 has type 'dma_addr_t': 238 =>
	src/drivers/staging/comedi/drivers/serial2002.c: warning: the frame
size of 1664 bytes is larger than 1024 bytes: 677 =>
	src/drivers/staging/iio/accel/adis16220_core.c: warning:
initialization from incompatible pointer type: 437, 484, 460 =>
	src/drivers/staging/iio/imu/adis16400_core.c: warning:
'adis16400_self_test' defined but not used: 416 =>
	src/drivers/staging/quatech_usb2/quatech_usb2.c: warning:
'qt2_box_flush' defined but not used: 1852 =>
	src/drivers/staging/udlfb/udlfb.c: warning: ignoring return value of
'device_create_bin_file', declared with attribute warn_unused_result:
1364 =>
	src/drivers/staging/udlfb/udlfb.c: warning: ignoring return value of
'device_create_file', declared with attribute warn_unused_result: 1362
=>
	src/drivers/staging/xgifb/XGI_main.h: warning: 'XGIfb_pdc' defined
but not used: 391 =>
	src/drivers/staging/xgifb/XGI_main_26.c: warning:
'XGIfb_search_crt2type' defined but not used: 858 =>
	src/drivers/staging/xgifb/XGI_main_26.c: warning:
'XGIfb_search_queuemode' defined but not used: 877 =>
	src/drivers/staging/xgifb/XGI_main_26.c: warning:
'XGIfb_search_tvstd' defined but not used: 941 =>
	src/drivers/staging/xgifb/XGI_main_26.c: warning: 'crt1off' defined
but not used: 3588 =>
	src/drivers/telephony/ixj.c: warning: 'ixj_pci_tbl' defined but not
used: 286 =>
	src/drivers/usb/host/ehci-hcd.c: warning: 'ehci_port_power' defined
but not used: 423 =>
	src/drivers/usb/host/ehci-hub.c: warning:
'ehci_adjust_port_wakeup_flags' defined but not used: 109 =>
	src/drivers/usb/host/ohci-hub.c: warning:
'ohci_finish_controller_resume' defined but not used: 318 =>
	src/drivers/usb/host/whci/hcd.c: warning: 'whci_hcd_id_table' defined
but not used: 359 =>
	src/drivers/uwb/whc-rc.c: warning: 'whcrc_id_table' defined but not
used: 452 =>
	src/drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M10'
defined but not used: 1718 =>
	src/drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M9P'
defined but not used: 1971 =>
	src/drivers/video/fsl-diu-fb.c: warning: format '%08x' expects type
'unsigned int', but argument 5 has type 'resource_size_t': 1457 =>
	src/drivers/video/via/via-gpio.c: warning: assignment from
incompatible pointer type: 216 =>
	src/drivers/watchdog/alim7101_wdt.c: warning: 'alim7101_pci_tbl'
defined but not used: 433 =>
	src/fs/afs/internal.h: warning: 'packed' attribute ignored for field
of type 'enum <anonymous>': 162 =>
	src/fs/afs/write.c: warning: format '%zd' expects type 'signed
size_t', but argument 4 has type 'ssize_t': 672, 668 =>
	src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval'
defined but not used: 51 =>
	src/fs/ecryptfs/crypto.c: warning: format '%zd' expects type 'signed
size_t', but argument 3 has type 'ssize_t': 1543 =>
	src/fs/ecryptfs/messaging.c: warning: 'daemon' may be used
uninitialized in this function: 277 =>
	src/fs/ext2/balloc.c: warning: passing argument 2 of
'test_and_clear_bit' from incompatible pointer type: 550 =>
	src/fs/ext2/balloc.c: warning: passing argument 2 of
'test_and_set_bit' from incompatible pointer type: 740, 725 =>
	src/fs/ext2/ialloc.c: warning: passing argument 2 of
'test_and_set_bit' from incompatible pointer type: 498 =>
	src/fs/ext3/balloc.c: warning: passing argument 2 of
'test_and_clear_bit' from incompatible pointer type: 832, 619 =>
	src/fs/ext3/balloc.c: warning: passing argument 2 of
'test_and_set_bit' from incompatible pointer type: 828, 610 =>
	src/fs/ext3/ialloc.c: warning: passing argument 2 of
'test_and_clear_bit' from incompatible pointer type: 154 =>
	src/fs/ext3/ialloc.c: warning: passing argument 2 of
'test_and_set_bit' from incompatible pointer type: 483 =>
	src/fs/ext4/balloc.c: warning: passing argument 2 of
'test_and_clear_bit' from incompatible pointer type: 442 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[10u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[11u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[12u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[13u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[14u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[15u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[16u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[1u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[2u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[3u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[4u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[5u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[6u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[7u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[8u]' may be used
uninitialized in this function: 435 =>
	src/fs/ncpfs/inode.c: warning: 'data.mounted_vol[9u]' may be used
uninitialized in this function: 435 =>
	src/fs/nilfs2/alloc.c: warning: passing argument 2 of
'test_and_clear_bit' from incompatible pointer type: 670, 557, 520 =>
	src/fs/nilfs2/alloc.c: warning: passing argument 2 of
'test_and_set_bit' from incompatible pointer type: 374, 355 =>
	src/fs/ocfs2/cluster/tcp.c: warning: format '%zd' expects type
'signed size_t', but argument 12 has type 'ssize_t': 936 =>
	src/fs/ocfs2/dlmfs/dlmfs.c: warning: format '%zd' expects type
'signed size_t', but argument 7 has type 'ssize_t': 327, 283 =>
	src/fs/omfs/file.c: warning: 'new_block' may be used uninitialized in
this function: 225 =>
	src/fs/quota/quota_tree.c: warning: format '%zd' expects type 'signed
size_t', but argument 2 has type 'ssize_t': 376 =>
	src/fs/quota/quota_v2.c: warning: format '%zd' expects type 'signed
size_t', but argument 3 has type 'ssize_t': 66 =>
	src/fs/smbfs/file.c: warning: format '%Zd' expects type 'signed
size_t', but argument 5 has type 'ssize_t': 353, 230, 277 =>
	src/fs/squashfs/xattr.c: warning: 'squashfs_xattr_handler' declared
inline after being called: 37 =>
	src/fs/squashfs/xattr.c: warning: previous declaration of
'squashfs_xattr_handler' was here: 37 =>
	src/include/linux/bio.h: warning: "ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE"
is not defined: 398:5 =>
	src/include/linux/blkdev.h: warning:
"ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE" is not defined: 764:5 =>
	src/include/linux/ncp_fs_sb.h: warning: 'packed' attribute ignored
for field of type '__u16': 112, 109, 111, 113, 110 =>
	src/include/linux/ncp_fs_sb.h: warning: 'packed' attribute ignored
for field of type '__u32': 108, 107 =>
	src/include/linux/sysv_fs.h: warning: 'packed' attribute ignored for
field of type '__fs32': 170, 130, 142, 114, 42, 112, 169, 30, 144,
157, 43, 100 =>
	src/include/linux/sysv_fs.h: warning: 'packed' attribute ignored for
field of type 'sysv_zone_t[64]': 160 =>
	src/include/sound/emu10k1.h: warning: "CCR" redefined: 441:1 =>
	src/kernel/irq/handle.c: warning:   CC      kernel/irq/spurious.o: 432:3 =>
	src/kernel/kprobes.c: warning: ‘cleanup_rp_inst’ defined but not used: 910 =>
	src/kernel/sched.c: warning: unsupported argument to
'__builtin_return_address': 3444, 3446 =>
	src/lib/decompress_bunzip2.c: warning: the frame size of 1824 bytes
is larger than 1024 bytes: 511 =>
	src/lib/decompress_bunzip2.c: warning: the frame size of 1840 bytes
is larger than 1024 bytes: 511 =>
	src/lib/decompress_bunzip2.c: warning: the frame size of 1876 bytes
is larger than 1024 bytes: 511 =>
	src/lib/decompress_bunzip2.c: warning: the frame size of 1888 bytes
is larger than 1024 bytes: 511 =>
	src/lib/decompress_bunzip2.c: warning: the frame size of 1916 bytes
is larger than 1024 bytes: 511 =>
	src/net/bluetooth/l2cap.c: warning: comparison is always false due to
limited range of data type: 4150, 4145, 3826, 3873 =>
	src/sound/i2c/other/ak4xxx-adda.c: warning: no return statement in
function returning non-void: 903 =>
	src/sound/pci/ice1712/quartet.c: warning: 'get_binary' defined but
not used: 211 =>
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:191): 226 =>
	src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:193): 226 =>
	src/sound/pcmcia/vx/vxpocket.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:191): 233 =>
	src/sound/pcmcia/vx/vxpocket.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:193): 233 =>
	src/sound/usb/format.c: warning: 'ret' may be used uninitialized in
this function: 355 =>
	src/sound/usb/misc/ua101.c: warning: unused variable 'ua': 1172 =>
	warning: "saved_config" [vmlinux] is COMMON symbol: N/A =>
	warning: 3 bad relocations: N/A =>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
