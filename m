Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1AJSw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:52:57 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:60703 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1AJSw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:52:56 -0500
X-Greylist: delayed 1991 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jan 2011 13:52:56 EST
Message-ID: <4D2B4CE4.9080309@ahsoftware.de>
Date: Mon, 10 Jan 2011 19:16:04 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux@arm.linux.org.uk
Subject: ARM: relocation out of range (when loading a module)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've build a kernel 2.6.37 for an armv5-device which includes an 
initramfs of about 16MB (uncompressed, result is a kernel of about 6MB) 
and I now getting errors when trying to load a module (which is included 
in that initramfs):

----------------------------
# modprobe ipv6
modprobe: 'kernel/net/ipv6/ipv6.ko': invalid module format
# dmesg | tail -n 1
[  107.327672] ipv6: relocation out of range, section 2 reloc 0 sym 
'snmp_mib_free'
----------------------------

To compile the kernel I've used gcc 4.5.2 and binutils 2.21.

If I apply the patch found at

http://lists.arm.linux.org.uk/lurker/message/20100729.090437.85f82ebd.en.html

the output from dmesg will be
----------------------------
[   58.211776] ipv6: section 2 reloc 0 sym 'snmp_mib_free': relocation 
28 out of range (0xbf0000a4 -> 0xc11b4858)
----------------------------

I don't know much about how the memory is organized and the relocation 
is done for arm, but reading that output it seems the 32MB limit is 
reached. Is that because of the initramfs (just speculating) and is 
there a workaround to still include such an initramfs in the kernel?

An excerpt from my config:

----------------------------
CONFIG_ARM_THUMB=y
...
# CONFIG_HIGHMEM is not set
# CONFIG_ARCH_SPARSEMEM_DEFAULT is not set
# CONFIG_ARCH_SELECT_MEMORY_MODEL is not set
# CONFIG_HIGHMEM is not set
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
----------------------------

Regards,

Alexander
