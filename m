Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab2LQXIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 18:08:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:24583 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab2LQXIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 18:08:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,305,1355126400"; 
   d="scan'208";a="258574376"
From: Thiago Macieira <thiago.macieira@intel.com>
To: linux-kernel@vger.kernel.org
Subject: uapi header self-containing
Date: Mon, 17 Dec 2012 15:08:13 -0800
Message-ID: <1507560.U44hG9b7LS@tjmaciei-mobl2>
Organization: Intel Corporation
User-Agent: KMail/4.10 pre (Linux/3.5.5-2.fc17.x86_64; KDE/4.9.80; x86_64; git-398f664; 2012-10-21)
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was told that each header in include/uapi/linux should be self-contained and 
compile on its own. So I tried a quick check. I don't have patches fixing them.

First of all: include/uapi/linux/compiler.h is missing. Nothing compiles 
without that header.

Then I ran this script (zsh rules) on 9360b53:
for f in linux/**/*.h(.); do 
	err=`g++ -I. -c -o /dev/null -D__EXPORTED_HEADERS__ -Wall -Wextra -xc $f 
2>&1` && continue
	echo === $f ===
	echo $err
	echo
done

Here's the result:
=== linux/agpgart.h ===
linux/agpgart.h:66:2: error: unknown type name ‘size_t’
linux/agpgart.h:67:2: error: unknown type name ‘size_t’
linux/agpgart.h:68:2: error: unknown type name ‘size_t’
linux/agpgart.h:69:2: error: unknown type name ‘size_t’

=== linux/atmbr2684.h ===
In file included from linux/atmbr2684.h:6:0:
./linux/if.h:184:19: error: field ‘ifru_addr’ has incomplete type
./linux/if.h:185:19: error: field ‘ifru_dstaddr’ has incomplete type
./linux/if.h:186:19: error: field ‘ifru_broadaddr’ has incomplete type
./linux/if.h:187:19: error: field ‘ifru_netmask’ has incomplete type
./linux/if.h:188:20: error: field ‘ifru_hwaddr’ has incomplete type

=== linux/atm_zatm.h ===
linux/atm_zatm.h:39:17: error: field ‘real’ has incomplete type
linux/atm_zatm.h:40:17: error: field ‘expected’ has incomplete type

=== linux/auto_fs4.h ===
In file included from linux/auto_fs4.h:16:0:
./linux/auto_fs.h:65:12: error: ‘NAME_MAX’ undeclared here (not in a function)

=== linux/auto_fs.h ===
linux/auto_fs.h:65:12: error: ‘NAME_MAX’ undeclared here (not in a function)

=== linux/can/bcm.h ===
linux/can/bcm.h:33:17: error: field ‘ival1’ has incomplete type
linux/can/bcm.h:33:24: error: field ‘ival2’ has incomplete type

=== linux/chio.h ===
linux/chio.h:99:25: error: expected ‘:’, ‘,’, ‘;’, ‘}’ or ‘__attribute__’ 
before ‘*’ token

=== linux/coda.h ===
linux/coda.h:216:2: error: unknown type name ‘u_short’
linux/coda.h:226:2: error: unknown type name ‘u_long’
linux/coda.h:227:2: error: unknown type name ‘u_long’
linux/coda.h:298:5: error: unknown type name ‘pid_t’
linux/coda.h:299:5: error: unknown type name ‘pid_t’
linux/coda.h:330:5: error: unknown type name ‘ino_t’
linux/coda.h:380:5: error: unknown type name ‘caddr_t’
linux/coda.h:540:5: error: unknown type name ‘caddr_t’
linux/coda.h:718:9: error: unknown type name ‘u_short’
linux/coda.h:719:9: error: unknown type name ‘u_short’

=== linux/coda_psdev.h ===
linux/coda_psdev.h:12:22: error: field ‘uc_chain’ has incomplete type
linux/coda_psdev.h:13:2: error: unknown type name ‘caddr_t’
linux/coda_psdev.h:14:2: error: unknown type name ‘u_short’
linux/coda_psdev.h:15:2: error: unknown type name ‘u_short’
linux/coda_psdev.h:16:2: error: unknown type name ‘u_short’
linux/coda_psdev.h:17:2: error: unknown type name ‘u_short’
linux/coda_psdev.h:19:2: error: unknown type name ‘wait_queue_head_t’

=== linux/dlm_netlink.h ===
linux/dlm_netlink.h:35:21: error: ‘DLM_RESNAME_MAXLEN’ undeclared here (not in 
a function)

=== linux/dm-log-userspace.h ===
linux/dm-log-userspace.h:402:2: error: unknown type name ‘uint64_t’
linux/dm-log-userspace.h:406:2: error: unknown type name ‘uint32_t’
linux/dm-log-userspace.h:407:2: error: unknown type name ‘int32_t’
linux/dm-log-userspace.h:409:2: error: unknown type name ‘uint32_t’
linux/dm-log-userspace.h:410:2: error: unknown type name ‘uint32_t’
linux/dm-log-userspace.h:411:2: error: unknown type name ‘uint32_t’

=== linux/elfcore.h ===
In file included from ./linux/signal.h:4:0,
                 from linux/elfcore.h:5:
/usr/include/asm/signal.h:135:2: error: unknown type name ‘size_t’
linux/elfcore.h:20:1: error: unknown type name ‘elf_greg_t’
linux/elfcore.h:21:1: error: unknown type name ‘elf_gregset_t’
linux/elfcore.h:22:1: error: unknown type name ‘elf_fpregset_t’
linux/elfcore.h:23:1: error: unknown type name ‘elf_fpxregset_t’
linux/elfcore.h:51:2: error: unknown type name ‘pid_t’
linux/elfcore.h:52:2: error: unknown type name ‘pid_t’
linux/elfcore.h:53:2: error: unknown type name ‘pid_t’
linux/elfcore.h:54:2: error: unknown type name ‘pid_t’
linux/elfcore.h:62:2: error: unknown type name ‘elf_gregset_t’
linux/elfcore.h:87:2: error: unknown type name ‘pid_t’

=== linux/hdlc/ioctl.h ===
linux/hdlc/ioctl.h:73:14: error: ‘IFNAMSIZ’ undeclared here (not in a 
function)

=== linux/hsi/hsi_char.h ===
linux/hsi/hsi_char.h:51:2: error: unknown type name ‘uint32_t’
linux/hsi/hsi_char.h:52:2: error: unknown type name ‘uint32_t’
linux/hsi/hsi_char.h:53:2: error: unknown type name ‘uint32_t’
linux/hsi/hsi_char.h:57:2: error: unknown type name ‘uint32_t’
linux/hsi/hsi_char.h:58:2: error: unknown type name ‘uint32_t’
linux/hsi/hsi_char.h:59:2: error: unknown type name ‘uint32_t’
linux/hsi/hsi_char.h:60:2: error: unknown type name ‘uint32_t’

=== linux/if_arp.h ===
In file included from ./linux/netdevice.h:28:0,
                 from linux/if_arp.h:26:
./linux/if.h:184:19: error: field ‘ifru_addr’ has incomplete type
./linux/if.h:185:19: error: field ‘ifru_dstaddr’ has incomplete type
./linux/if.h:186:19: error: field ‘ifru_broadaddr’ has incomplete type
./linux/if.h:187:19: error: field ‘ifru_netmask’ has incomplete type
./linux/if.h:188:20: error: field ‘ifru_hwaddr’ has incomplete type
linux/if_arp.h:112:19: error: field ‘arp_pa’ has incomplete type
linux/if_arp.h:113:19: error: field ‘arp_ha’ has incomplete type
linux/if_arp.h:115:25: error: field ‘arp_netmask’ has incomplete type
linux/if_arp.h:120:19: error: field ‘arp_pa’ has incomplete type
linux/if_arp.h:121:19: error: field ‘arp_ha’ has incomplete type
linux/if_arp.h:123:25: error: field ‘arp_netmask’ has incomplete type

=== linux/if_bonding.h ===
In file included from linux/if_bonding.h:46:0:
./linux/if.h:184:19: error: field ‘ifru_addr’ has incomplete type
./linux/if.h:185:19: error: field ‘ifru_dstaddr’ has incomplete type
./linux/if.h:186:19: error: field ‘ifru_broadaddr’ has incomplete type
./linux/if.h:187:19: error: field ‘ifru_netmask’ has incomplete type
./linux/if.h:188:20: error: field ‘ifru_hwaddr’ has incomplete type

=== linux/if_bridge.h ===
linux/if_bridge.h:169:20: error: field ‘ip6’ has incomplete type

=== linux/if_frad.h ===
In file included from linux/if_frad.h:27:0:
./linux/if.h:184:19: error: field ‘ifru_addr’ has incomplete type
./linux/if.h:185:19: error: field ‘ifru_dstaddr’ has incomplete type
./linux/if.h:186:19: error: field ‘ifru_broadaddr’ has incomplete type
./linux/if.h:187:19: error: field ‘ifru_netmask’ has incomplete type
./linux/if.h:188:20: error: field ‘ifru_hwaddr’ has incomplete type

=== linux/if.h ===
linux/if.h:184:19: error: field ‘ifru_addr’ has incomplete type
linux/if.h:185:19: error: field ‘ifru_dstaddr’ has incomplete type
linux/if.h:186:19: error: field ‘ifru_broadaddr’ has incomplete type
linux/if.h:187:19: error: field ‘ifru_netmask’ has incomplete type
linux/if.h:188:20: error: field ‘ifru_hwaddr’ has incomplete type

=== linux/if_ppp.h ===
In file included from linux/if_ppp.h:1:0:
./linux/ppp-ioctl.h:55:14: error: field ‘mode’ has incomplete type

=== linux/if_pppol2tp.h ===
linux/if_pppol2tp.h:29:21: error: field ‘addr’ has incomplete type
linux/if_pppol2tp.h:46:22: error: field ‘addr’ has incomplete type
linux/if_pppol2tp.h:57:21: error: field ‘addr’ has incomplete type
linux/if_pppol2tp.h:71:22: error: field ‘addr’ has incomplete type

=== linux/if_pppox.h ===
In file included from linux/if_pppox.h:25:0:
./linux/if_pppol2tp.h:29:21: error: field ‘addr’ has incomplete type
./linux/if_pppol2tp.h:46:22: error: field ‘addr’ has incomplete type
./linux/if_pppol2tp.h:57:21: error: field ‘addr’ has incomplete type
./linux/if_pppol2tp.h:71:22: error: field ‘addr’ has incomplete type
linux/if_pppox.h:42:20: error: ‘IFNAMSIZ’ undeclared here (not in a function)
linux/if_pppox.h:50:17: error: field ‘sin_addr’ has incomplete type
linux/if_pppox.h:79:3: error: conflicting types for ‘__packed’
linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
linux/if_pppox.h:85:3: error: conflicting types for ‘__packed’
linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
linux/if_pppox.h:94:3: error: conflicting types for ‘__packed’
linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
linux/if_pppox.h:100:3: error: conflicting types for ‘__packed’
linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
linux/if_pppox.h:150:3: error: conflicting types for ‘__packed’
linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here

=== linux/if_tunnel.h ===
linux/if_tunnel.h:31:14: error: ‘IFNAMSIZ’ undeclared here (not in a function)
linux/if_tunnel.h:37:16: error: field ‘iph’ has incomplete type
linux/if_tunnel.h:76:19: error: field ‘prefix’ has incomplete type

=== linux/ip6_tunnel.h ===
linux/ip6_tunnel.h:23:12: error: ‘IFNAMSIZ’ undeclared here (not in a 
function)
linux/ip6_tunnel.h:30:18: error: field ‘laddr’ has incomplete type
linux/ip6_tunnel.h:31:18: error: field ‘raddr’ has incomplete type
linux/ip6_tunnel.h:42:18: error: field ‘laddr’ has incomplete type
linux/ip6_tunnel.h:43:18: error: field ‘raddr’ has incomplete type

=== linux/ipv6_route.h ===
linux/ipv6_route.h:41:19: error: field ‘rtmsg_dst’ has incomplete type
linux/ipv6_route.h:42:19: error: field ‘rtmsg_src’ has incomplete type
linux/ipv6_route.h:43:19: error: field ‘rtmsg_gateway’ has incomplete type

=== linux/ixjuser.h ===
linux/ixjuser.h:351:29: error: expected ‘:’, ‘,’, ‘;’, ‘}’ or ‘__attribute__’ 
before ‘*’ token

=== linux/kexec.h ===
linux/kexec.h:41:2: error: unknown type name ‘size_t’
linux/kexec.h:43:2: error: unknown type name ‘size_t’
linux/kexec.h:50:31: error: unknown type name ‘size_t’

=== linux/llc.h ===
linux/llc.h:26:27: error: ‘IFHWADDRLEN’ undeclared here (not in a function)

=== linux/mroute6.h ===
linux/mroute6.h:82:22: error: field ‘mf6cc_origin’ has incomplete type
linux/mroute6.h:83:22: error: field ‘mf6cc_mcastgrp’ has incomplete type
linux/mroute6.h:93:22: error: field ‘src’ has incomplete type
linux/mroute6.h:94:22: error: field ‘grp’ has incomplete type
linux/mroute6.h:134:18: error: field ‘im6_src’ has incomplete type
linux/mroute6.h:134:27: error: field ‘im6_dst’ has incomplete type

=== linux/mroute.h ===
linux/mroute.h:61:18: error: field ‘vifc_lcl_addr’ has incomplete type
linux/mroute.h:64:17: error: field ‘vifc_rmt_addr’ has incomplete type
linux/mroute.h:78:17: error: field ‘mfcc_origin’ has incomplete type
linux/mroute.h:79:17: error: field ‘mfcc_mcastgrp’ has incomplete type
linux/mroute.h:93:17: error: field ‘src’ has incomplete type
linux/mroute.h:94:17: error: field ‘grp’ has incomplete type
linux/mroute.h:123:17: error: field ‘im_src’ has incomplete type
linux/mroute.h:123:24: error: field ‘im_dst’ has incomplete type

=== linux/ncp_fs.h ===
linux/ncp_fs.h:89:2: error: unknown type name ‘size_t’
linux/ncp_fs.h:95:2: error: unknown type name ‘size_t’

=== linux/netdevice.h ===
In file included from linux/netdevice.h:28:0:
./linux/if.h:184:19: error: field ‘ifru_addr’ has incomplete type
./linux/if.h:185:19: error: field ‘ifru_dstaddr’ has incomplete type
./linux/if.h:186:19: error: field ‘ifru_broadaddr’ has incomplete type
./linux/if.h:187:19: error: field ‘ifru_netmask’ has incomplete type
./linux/if.h:188:20: error: field ‘ifru_hwaddr’ has incomplete type

=== linux/netfilter_arp/arp_tables.h ===
In file included from ./linux/netfilter.h:6:0,
                 from ./linux/netfilter_arp.h:8,
                 from linux/netfilter_arp/arp_tables.h:14:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from ./linux/netfilter_arp.h:8:0,
                 from linux/netfilter_arp/arp_tables.h:14:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type
linux/netfilter_arp/arp_tables.h:44:17: error: field ‘src’ has incomplete type
linux/netfilter_arp/arp_tables.h:44:22: error: field ‘tgt’ has incomplete type
linux/netfilter_arp/arp_tables.h:46:17: error: field ‘smsk’ has incomplete type
linux/netfilter_arp/arp_tables.h:46:23: error: field ‘tmsk’ has incomplete type
linux/netfilter_arp/arp_tables.h:64:15: error: ‘IFNAMSIZ’ undeclared here (not 
in a function)

=== linux/netfilter_arp/arpt_mangle.h ===
In file included from ./linux/netfilter.h:6:0,
                 from ./linux/netfilter_arp.h:8,
                 from ./linux/netfilter_arp/arp_tables.h:14,
                 from linux/netfilter_arp/arpt_mangle.h:3:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from ./linux/netfilter_arp.h:8:0,
                 from ./linux/netfilter_arp/arp_tables.h:14,
                 from linux/netfilter_arp/arpt_mangle.h:3:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type
In file included from linux/netfilter_arp/arpt_mangle.h:3:0:
./linux/netfilter_arp/arp_tables.h:44:17: error: field ‘src’ has incomplete type
./linux/netfilter_arp/arp_tables.h:44:22: error: field ‘tgt’ has incomplete type
./linux/netfilter_arp/arp_tables.h:46:17: error: field ‘smsk’ has incomplete 
type
./linux/netfilter_arp/arp_tables.h:46:23: error: field ‘tmsk’ has incomplete 
type
./linux/netfilter_arp/arp_tables.h:64:15: error: ‘IFNAMSIZ’ undeclared here 
(not in a function)
linux/netfilter_arp/arpt_mangle.h:11:18: error: field ‘src_ip’ has incomplete 
type
linux/netfilter_arp/arpt_mangle.h:14:18: error: field ‘tgt_ip’ has incomplete 
type
linux/netfilter_arp/arpt_mangle.h:16:2: error: unknown type name ‘u_int8_t’

=== linux/netfilter_arp.h ===
In file included from ./linux/netfilter.h:6:0,
                 from linux/netfilter_arp.h:8:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from linux/netfilter_arp.h:8:0:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type

=== linux/netfilter_bridge/ebtables.h ===
In file included from linux/netfilter_bridge/ebtables.h:15:0:
./linux/if.h:184:19: error: field ‘ifru_addr’ has incomplete type
./linux/if.h:185:19: error: field ‘ifru_dstaddr’ has incomplete type
./linux/if.h:186:19: error: field ‘ifru_broadaddr’ has incomplete type
./linux/if.h:187:19: error: field ‘ifru_netmask’ has incomplete type
./linux/if.h:188:20: error: field ‘ifru_hwaddr’ has incomplete type
In file included from ./linux/netfilter.h:6:0,
                 from ./linux/netfilter_bridge.h:7,
                 from linux/netfilter_bridge/ebtables.h:16:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from ./linux/netfilter_bridge.h:7:0,
                 from linux/netfilter_bridge/ebtables.h:16:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type
In file included from ./linux/if_pppox.h:25:0,
                 from ./linux/netfilter_bridge.h:10,
                 from linux/netfilter_bridge/ebtables.h:16:
./linux/if_pppol2tp.h:29:21: error: field ‘addr’ has incomplete type
./linux/if_pppol2tp.h:46:22: error: field ‘addr’ has incomplete type
./linux/if_pppol2tp.h:57:21: error: field ‘addr’ has incomplete type
./linux/if_pppol2tp.h:71:22: error: field ‘addr’ has incomplete type
In file included from ./linux/netfilter_bridge.h:10:0,
                 from linux/netfilter_bridge/ebtables.h:16:
./linux/if_pppox.h:50:17: error: field ‘sin_addr’ has incomplete type
./linux/if_pppox.h:79:3: error: conflicting types for ‘__packed’
./linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
./linux/if_pppox.h:85:3: error: conflicting types for ‘__packed’
./linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
./linux/if_pppox.h:94:3: error: conflicting types for ‘__packed’
./linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
./linux/if_pppox.h:100:3: error: conflicting types for ‘__packed’
./linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
./linux/if_pppox.h:150:3: error: conflicting types for ‘__packed’
./linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
linux/netfilter_bridge/ebtables.h:38:2: error: unknown type name ‘uint64_t’
linux/netfilter_bridge/ebtables.h:39:2: error: unknown type name ‘uint64_t’

=== linux/netfilter_bridge/ebt_arp.h ===
linux/netfilter_bridge/ebt_arp.h:28:23: error: ‘ETH_ALEN’ undeclared here (not 
in a function)

=== linux/netfilter_bridge/ebt_arpreply.h ===
linux/netfilter_bridge/ebt_arpreply.h:5:20: error: ‘ETH_ALEN’ undeclared here 
(not in a function)

=== linux/netfilter_bridge/ebt_ip6.h ===
linux/netfilter_bridge/ebt_ip6.h:32:18: error: field ‘saddr’ has incomplete type
linux/netfilter_bridge/ebt_ip6.h:33:18: error: field ‘daddr’ has incomplete type
linux/netfilter_bridge/ebt_ip6.h:34:18: error: field ‘smsk’ has incomplete type
linux/netfilter_bridge/ebt_ip6.h:35:18: error: field ‘dmsk’ has incomplete type

=== linux/netfilter_bridge/ebt_nat.h ===
linux/netfilter_bridge/ebt_nat.h:6:20: error: ‘ETH_ALEN’ undeclared here (not 
in a function)

=== linux/netfilter_bridge/ebt_ulog.h ===
linux/netfilter_bridge/ebt_ulog.h:23:13: error: ‘IFNAMSIZ’ undeclared here (not 
in a function)
linux/netfilter_bridge/ebt_ulog.h:28:17: error: field ‘stamp’ has incomplete 
type
linux/netfilter_bridge/ebt_ulog.h:31:2: error: unknown type name ‘size_t’

=== linux/netfilter_bridge.h ===
In file included from ./linux/netfilter.h:6:0,
                 from linux/netfilter_bridge.h:7:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from linux/netfilter_bridge.h:7:0:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type
In file included from ./linux/if_pppox.h:25:0,
                 from linux/netfilter_bridge.h:10:
./linux/if_pppol2tp.h:29:21: error: field ‘addr’ has incomplete type
./linux/if_pppol2tp.h:46:22: error: field ‘addr’ has incomplete type
./linux/if_pppol2tp.h:57:21: error: field ‘addr’ has incomplete type
./linux/if_pppol2tp.h:71:22: error: field ‘addr’ has incomplete type
In file included from linux/netfilter_bridge.h:10:0:
./linux/if_pppox.h:42:20: error: ‘IFNAMSIZ’ undeclared here (not in a 
function)
./linux/if_pppox.h:50:17: error: field ‘sin_addr’ has incomplete type
./linux/if_pppox.h:79:3: error: conflicting types for ‘__packed’
./linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
./linux/if_pppox.h:85:3: error: conflicting types for ‘__packed’
./linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
./linux/if_pppox.h:94:3: error: conflicting types for ‘__packed’
./linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
./linux/if_pppox.h:100:3: error: conflicting types for ‘__packed’
./linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here
./linux/if_pppox.h:150:3: error: conflicting types for ‘__packed’
./linux/if_pppox.h:68:3: note: previous declaration of ‘__packed’ was here

=== linux/netfilter_decnet.h ===
In file included from ./linux/netfilter.h:6:0,
                 from linux/netfilter_decnet.h:10:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from linux/netfilter_decnet.h:10:0:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type

=== linux/netfilter.h ===
In file included from linux/netfilter.h:6:0:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type

=== linux/netfilter/ipset/ip_set_bitmap.h ===
linux/netfilter/ipset/ip_set_bitmap.h:7:27: error: ‘IPSET_ERR_TYPE_SPECIFIC’ 
undeclared here (not in a function)

=== linux/netfilter/ipset/ip_set_hash.h ===
linux/netfilter/ipset/ip_set_hash.h:7:24: error: ‘IPSET_ERR_TYPE_SPECIFIC’ 
undeclared here (not in a function)

=== linux/netfilter/ipset/ip_set_list.h ===
linux/netfilter/ipset/ip_set_list.h:7:19: error: ‘IPSET_ERR_TYPE_SPECIFIC’ 
undeclared here (not in a function)

=== linux/netfilter_ipv4.h ===
In file included from ./linux/netfilter.h:6:0,
                 from linux/netfilter_ipv4.h:8:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from linux/netfilter_ipv4.h:8:0:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type

=== linux/netfilter_ipv4/ip_tables.h ===
In file included from ./linux/netfilter.h:6:0,
                 from ./linux/netfilter_ipv4.h:8,
                 from linux/netfilter_ipv4/ip_tables.h:20:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from ./linux/netfilter_ipv4.h:8:0,
                 from linux/netfilter_ipv4/ip_tables.h:20:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type
linux/netfilter_ipv4/ip_tables.h:71:17: error: field ‘src’ has incomplete type
linux/netfilter_ipv4/ip_tables.h:71:22: error: field ‘dst’ has incomplete type
linux/netfilter_ipv4/ip_tables.h:73:17: error: field ‘smsk’ has incomplete type
linux/netfilter_ipv4/ip_tables.h:73:23: error: field ‘dmsk’ has incomplete type
linux/netfilter_ipv4/ip_tables.h:74:15: error: ‘IFNAMSIZ’ undeclared here (not 
in a function)

=== linux/netfilter_ipv4/ipt_ULOG.h ===
linux/netfilter_ipv4/ipt_ULOG.h:29:2: error: unknown type name ‘size_t’
linux/netfilter_ipv4/ipt_ULOG.h:30:2: error: unknown type name ‘size_t’
linux/netfilter_ipv4/ipt_ULOG.h:40:18: error: ‘IFNAMSIZ’ undeclared here (not 
in a function)
linux/netfilter_ipv4/ipt_ULOG.h:42:2: error: unknown type name ‘size_t’

=== linux/netfilter_ipv6.h ===
In file included from ./linux/netfilter.h:6:0,
                 from linux/netfilter_ipv6.h:11:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from linux/netfilter_ipv6.h:11:0:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type

=== linux/netfilter_ipv6/ip6_tables.h ===
In file included from ./linux/netfilter.h:6:0,
                 from ./linux/netfilter_ipv6.h:11,
                 from linux/netfilter_ipv6/ip6_tables.h:20:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from ./linux/netfilter_ipv6.h:11:0,
                 from linux/netfilter_ipv6/ip6_tables.h:20:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type
linux/netfilter_ipv6/ip6_tables.h:64:18: error: field ‘src’ has incomplete type
linux/netfilter_ipv6/ip6_tables.h:64:23: error: field ‘dst’ has incomplete type
linux/netfilter_ipv6/ip6_tables.h:66:18: error: field ‘smsk’ has incomplete type
linux/netfilter_ipv6/ip6_tables.h:66:24: error: field ‘dmsk’ has incomplete type
linux/netfilter_ipv6/ip6_tables.h:67:15: error: ‘IFNAMSIZ’ undeclared here (not 
in a function)

=== linux/netfilter_ipv6/ip6t_NPT.h ===
In file included from ./linux/netfilter.h:6:0,
                 from linux/netfilter_ipv6/ip6t_NPT.h:5:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from linux/netfilter_ipv6/ip6t_NPT.h:5:0:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type

=== linux/netfilter_ipv6/ip6t_rt.h ===
linux/netfilter_ipv6/ip6t_rt.h:15:18: error: array type has incomplete element 
type

=== linux/netfilter/nf_conntrack_sctp.h ===
In file included from linux/netfilter/nf_conntrack_sctp.h:5:0:
./linux/netfilter/nf_conntrack_tuple_common.h:15:2: error: unknown type name 
‘__be16’
./linux/netfilter/nf_conntrack_tuple_common.h:18:3: error: unknown type name 
‘__be16’
./linux/netfilter/nf_conntrack_tuple_common.h:21:3: error: unknown type name 
‘__be16’
./linux/netfilter/nf_conntrack_tuple_common.h:24:3: error: unknown type name 
‘__be16’
./linux/netfilter/nf_conntrack_tuple_common.h:27:3: error: unknown type name 
‘__be16’
./linux/netfilter/nf_conntrack_tuple_common.h:30:3: error: unknown type name 
‘__be16’
./linux/netfilter/nf_conntrack_tuple_common.h:33:3: error: unknown type name 
‘__be16’
linux/netfilter/nf_conntrack_sctp.h:22:2: error: unknown type name ‘__be32’

=== linux/netfilter/nf_conntrack_tuple_common.h ===
linux/netfilter/nf_conntrack_tuple_common.h:15:2: error: unknown type name 
‘__be16’
linux/netfilter/nf_conntrack_tuple_common.h:18:3: error: unknown type name 
‘__be16’
linux/netfilter/nf_conntrack_tuple_common.h:21:3: error: unknown type name 
‘__be16’
linux/netfilter/nf_conntrack_tuple_common.h:24:3: error: unknown type name 
‘__be16’
linux/netfilter/nf_conntrack_tuple_common.h:27:3: error: unknown type name 
‘__be16’
linux/netfilter/nf_conntrack_tuple_common.h:30:3: error: unknown type name 
‘__be16’
linux/netfilter/nf_conntrack_tuple_common.h:33:3: error: unknown type name 
‘__be16’

=== linux/netfilter/nf_nat.h ===
In file included from ./linux/netfilter.h:6:0,
                 from linux/netfilter/nf_nat.h:4:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from linux/netfilter/nf_nat.h:4:0:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type

=== linux/netfilter/xt_connlimit.h ===
In file included from ./linux/netfilter.h:6:0,
                 from linux/netfilter/xt_connlimit.h:5:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from linux/netfilter/xt_connlimit.h:5:0:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type

=== linux/netfilter/xt_conntrack.h ===
In file included from ./linux/netfilter.h:6:0,
                 from linux/netfilter/xt_conntrack.h:9:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from linux/netfilter/xt_conntrack.h:9:0:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type

=== linux/netfilter/xt_hashlimit.h ===
linux/netfilter/xt_hashlimit.h:40:13: error: ‘IFNAMSIZ’ undeclared here (not in 
a function)

=== linux/netfilter/xt_iprange.h ===
In file included from ./linux/netfilter.h:6:0,
                 from linux/netfilter/xt_iprange.h:5:
./linux/sysctl.h:40:2: error: unknown type name ‘size_t’
./linux/sysctl.h:42:2: error: unknown type name ‘size_t’
In file included from linux/netfilter/xt_iprange.h:5:0:
./linux/netfilter.h:68:17: error: field ‘in’ has incomplete type
./linux/netfilter.h:69:18: error: field ‘in6’ has incomplete type

=== linux/netfilter/xt_ipvs.h ===
linux/netfilter/xt_ipvs.h:19:21: error: field ‘vaddr’ has incomplete type
linux/netfilter/xt_ipvs.h:19:28: error: field ‘vmask’ has incomplete type

=== linux/netfilter/xt_mac.h ===
linux/netfilter/xt_mac.h:5:27: error: ‘ETH_ALEN’ undeclared here (not in a 
function)

=== linux/netfilter/xt_osf.h ===
linux/netfilter/xt_osf.h:79:24: error: ‘MAX_IPOPTLEN’ undeclared here (not in a 
function)
linux/netfilter/xt_osf.h:84:16: error: field ‘ip’ has incomplete type
linux/netfilter/xt_osf.h:85:17: error: field ‘tcp’ has incomplete type

=== linux/netfilter/xt_physdev.h ===
linux/netfilter/xt_physdev.h:15:17: error: ‘IFNAMSIZ’ undeclared here (not in a 
function)

=== linux/netfilter/xt_policy.h ===
linux/netfilter/xt_policy.h:31:17: error: field ‘a4’ has incomplete type
linux/netfilter/xt_policy.h:32:18: error: field ‘a6’ has incomplete type

=== linux/netfilter/xt_rateest.h ===
linux/netfilter/xt_rateest.h:23:15: error: ‘IFNAMSIZ’ undeclared here (not in a 
function)

=== linux/netfilter/xt_RATEEST.h ===
linux/netfilter/xt_RATEEST.h:7:14: error: ‘IFNAMSIZ’ undeclared here (not in a 
function)

=== linux/netfilter/xt_recent.h ===
linux/netfilter/xt_recent.h:42:21: error: field ‘mask’ has incomplete type

=== linux/netfilter/xt_sctp.h ===
linux/netfilter/xt_sctp.h:70:1: error: unknown type name ‘bool’
linux/netfilter/xt_sctp.h: In function ‘__sctp_chunkmap_is_clear’:
linux/netfilter/xt_sctp.h:75:11: error: ‘false’ undeclared (first use in this 
function)
linux/netfilter/xt_sctp.h:75:11: note: each undeclared identifier is reported 
only once for each function it appears in
linux/netfilter/xt_sctp.h:76:9: error: ‘true’ undeclared (first use in this 
function)
linux/netfilter/xt_sctp.h: At top level:
linux/netfilter/xt_sctp.h:82:1: error: unknown type name ‘bool’
linux/netfilter/xt_sctp.h: In function ‘__sctp_chunkmap_is_all_set’:
linux/netfilter/xt_sctp.h:87:11: error: ‘false’ undeclared (first use in this 
function)
linux/netfilter/xt_sctp.h:88:9: error: ‘true’ undeclared (first use in this 
function)

=== linux/netfilter/xt_TEE.h ===
linux/netfilter/xt_TEE.h:5:21: error: field ‘gw’ has incomplete type

=== linux/netfilter/xt_TPROXY.h ===
linux/netfilter/xt_TPROXY.h:19:21: error: field ‘laddr’ has incomplete type

=== linux/nfc.h ===
linux/nfc.h:176:2: error: unknown type name ‘sa_family_t’
linux/nfc.h:184:2: error: unknown type name ‘sa_family_t’
linux/nfc.h:191:2: error: unknown type name ‘size_t’

=== linux/nfs4_mount.h ===
linux/nfs4_mount.h:23:20: error: expected ‘:’, ‘,’, ‘;’, ‘}’ or 
‘__attribute__’ before ‘*’ token
linux/nfs4_mount.h:48:25: error: expected ‘:’, ‘,’, ‘;’, ‘}’ or 
‘__attribute__’ before ‘*’ token

=== linux/nfsd/cld.h ===
linux/nfsd/cld.h:40:2: error: unknown type name ‘uint16_t’
linux/nfsd/cld.h:46:2: error: unknown type name ‘uint8_t’
linux/nfsd/cld.h:47:2: error: unknown type name ‘uint8_t’
linux/nfsd/cld.h:48:2: error: unknown type name ‘int16_t’
linux/nfsd/cld.h:49:2: error: unknown type name ‘uint32_t’
linux/nfsd/cld.h:51:3: error: unknown type name ‘int64_t’

=== linux/omapfb.h ===
linux/omapfb.h:184:2: error: unknown type name ‘size_t’

=== linux/packet_diag.h ===
linux/packet_diag.h:59:17: error: ‘MAX_ADDR_LEN’ undeclared here (not in a 
function)

=== linux/patchkey.h ===
linux/patchkey.h:14:2: error: #error "patchkey.h included directly"

=== linux/phonet.h ===
linux/phonet.h:106:23: error: invalid application of ‘sizeof’ to incomplete 
type ‘struct sockaddr’

=== linux/ppp-ioctl.h ===
linux/ppp-ioctl.h:55:14: error: field ‘mode’ has incomplete type

=== linux/rds.h ===
linux/rds.h:96:2: error: unknown type name ‘uint8_t’
linux/rds.h:97:2: error: unknown type name ‘uint64_t’
linux/rds.h:107:2: error: unknown type name ‘uint64_t’
linux/rds.h:108:2: error: unknown type name ‘uint64_t’
linux/rds.h:111:2: error: unknown type name ‘uint8_t’
linux/rds.h:112:2: error: unknown type name ‘uint8_t’
linux/rds.h:119:2: error: unknown type name ‘uint64_t’
linux/rds.h:120:2: error: unknown type name ‘uint32_t’
linux/rds.h:125:2: error: unknown type name ‘uint8_t’
linux/rds.h:129:2: error: unknown type name ‘uint32_t’
linux/rds.h:134:2: error: unknown type name ‘uint32_t’
linux/rds.h:135:2: error: unknown type name ‘uint64_t’
linux/rds.h:143:2: error: unknown type name ‘uint64_t’
linux/rds.h:144:2: error: unknown type name ‘uint64_t’
linux/rds.h:145:2: error: unknown type name ‘uint32_t’
linux/rds.h:146:2: error: unknown type name ‘uint32_t’
linux/rds.h:147:2: error: unknown type name ‘uint32_t’
linux/rds.h:154:2: error: unknown type name ‘uint8_t’
linux/rds.h:155:2: error: unknown type name ‘uint8_t’
linux/rds.h:157:2: error: unknown type name ‘uint32_t’
linux/rds.h:158:2: error: unknown type name ‘uint32_t’
linux/rds.h:159:2: error: unknown type name ‘uint32_t’
linux/rds.h:160:2: error: unknown type name ‘uint32_t’
linux/rds.h:161:2: error: unknown type name ‘uint32_t’
linux/rds.h:202:1: error: unknown type name ‘uint64_t’
linux/rds.h:205:2: error: unknown type name ‘uint64_t’
linux/rds.h:206:2: error: unknown type name ‘uint64_t’
linux/rds.h:211:2: error: unknown type name ‘uint64_t’
linux/rds.h:212:2: error: unknown type name ‘uint64_t’
linux/rds.h:216:26: error: field ‘dest_addr’ has incomplete type
linux/rds.h:218:2: error: unknown type name ‘uint64_t’
linux/rds.h:219:2: error: unknown type name ‘uint64_t’
linux/rds.h:224:2: error: unknown type name ‘uint64_t’
linux/rds.h:230:2: error: unknown type name ‘uint64_t’
linux/rds.h:231:2: error: unknown type name ‘uint64_t’
linux/rds.h:232:2: error: unknown type name ‘uint64_t’
linux/rds.h:233:2: error: unknown type name ‘uint64_t’
linux/rds.h:238:2: error: unknown type name ‘uint64_t’
linux/rds.h:239:2: error: unknown type name ‘uint64_t’
linux/rds.h:242:4: error: unknown type name ‘uint64_t’
linux/rds.h:243:4: error: unknown type name ‘uint64_t’
linux/rds.h:246:4: error: unknown type name ‘uint64_t’
linux/rds.h:249:4: error: unknown type name ‘uint64_t’
linux/rds.h:250:4: error: unknown type name ‘uint64_t’
linux/rds.h:251:4: error: unknown type name ‘uint64_t’
linux/rds.h:252:4: error: unknown type name ‘uint64_t’
linux/rds.h:255:4: error: unknown type name ‘uint64_t’
linux/rds.h:256:4: error: unknown type name ‘uint64_t’
linux/rds.h:259:2: error: unknown type name ‘uint64_t’
linux/rds.h:260:2: error: unknown type name ‘uint64_t’
linux/rds.h:264:2: error: unknown type name ‘uint64_t’
linux/rds.h:265:2: error: unknown type name ‘int32_t’

=== linux/reiserfs_xattr.h ===
linux/reiserfs_xattr.h:21:2: error: unknown type name ‘size_t’

=== linux/route.h ===
In file included from linux/route.h:26:0:
./linux/if.h:184:19: error: field ‘ifru_addr’ has incomplete type
./linux/if.h:185:19: error: field ‘ifru_dstaddr’ has incomplete type
./linux/if.h:186:19: error: field ‘ifru_broadaddr’ has incomplete type
./linux/if.h:187:19: error: field ‘ifru_netmask’ has incomplete type
./linux/if.h:188:20: error: field ‘ifru_hwaddr’ has incomplete type
linux/route.h:32:18: error: field ‘rt_dst’ has incomplete type
linux/route.h:33:18: error: field ‘rt_gateway’ has incomplete type
linux/route.h:34:18: error: field ‘rt_genmask’ has incomplete type

=== linux/scc.h ===
linux/scc.h:19:20: error: ‘SIOCDEVPRIVATE’ undeclared here (not in a function)

=== linux/sdla.h ===
linux/sdla.h:61:16: error: expected ‘:’, ‘,’, ‘;’, ‘}’ or ‘__attribute__’ 
before ‘*’ token

=== linux/signal.h ===
In file included from linux/signal.h:4:0:
/usr/include/asm/signal.h:135:2: error: unknown type name ‘size_t’

=== linux/sysctl.h ===
linux/sysctl.h:40:2: error: unknown type name ‘size_t’
linux/sysctl.h:42:2: error: unknown type name ‘size_t’

=== linux/usb/ch11.h ===
linux/usb/ch11.h:233:27: error: ‘USB_MAXCHILDREN’ undeclared here (not in a 
function)

=== linux/virtio_balloon.h ===
linux/virtio_balloon.h:55:2: error: unknown type name ‘u16’
linux/virtio_balloon.h:56:2: error: unknown type name ‘u64’

=== linux/virtio_net.h ===
linux/virtio_net.h:188:2: error: unknown type name ‘u16’

=== linux/wireless.h ===
In file included from linux/wireless.h:74:0:
./linux/if.h:184:19: error: field ‘ifru_addr’ has incomplete type
./linux/if.h:185:19: error: field ‘ifru_dstaddr’ has incomplete type
./linux/if.h:186:19: error: field ‘ifru_broadaddr’ has incomplete type
./linux/if.h:187:19: error: field ‘ifru_netmask’ has incomplete type
./linux/if.h:188:20: error: field ‘ifru_hwaddr’ has incomplete type
linux/wireless.h:751:19: error: field ‘addr’ has incomplete type
linux/wireless.h:777:18: error: field ‘bssid’ has incomplete type
linux/wireless.h:835:18: error: field ‘addr’ has incomplete type
linux/wireless.h:848:18: error: field ‘addr’ has incomplete type
linux/wireless.h:861:18: error: field ‘bssid’ has incomplete type
linux/wireless.h:869:18: error: field ‘src_addr’ has incomplete type
linux/wireless.h:880:18: error: field ‘bssid’ has incomplete type
linux/wireless.h:934:18: error: field ‘ap_addr’ has incomplete type
linux/wireless.h:935:18: error: field ‘addr’ has incomplete type

In addition to the above errors, there are some C++-specific issues. I'll post 
those once the C errors have been (mostly) corrected.
-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel Open Source Technology Center
