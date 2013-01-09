Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664Ab3AIVRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:17:48 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:55064 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933433Ab3AIVRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:17:45 -0500
Message-ID: <50EDDE75.8080408@fold.natur.cuni.cz>
Date: Wed, 09 Jan 2013 22:17:41 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 3.7.1: BUG filp (Not tainted): Poison overwritten
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  today I received the following.

[  124.927854] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  124.987250] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[  124.992228] pci_bus 0000:11: dev 00, created physical slot 1
[  124.992448] acpiphp: Slot [1] registered
[  233.258244] =============================================================================
[  233.258247] BUG filp (Not tainted): Poison overwritten
[  233.258248] -----------------------------------------------------------------------------

[  233.258248] Disabling lock debugging due to kernel taint
[  233.258250] INFO: 0xffff880401020000-0xffff88040102001d. First byte 0x20 instead of 0x6b
[  233.258253] INFO: Slab 0xffffea0010040800 objects=21 used=21 fp=0x          (null) flags=0x20000000004080
[  233.258254] INFO: Object 0xffff880401020000 @offset=0 fp=0xffff880401021e00

[  233.258255] Object ffff880401020000: 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07   . . . . . . . .
[  233.258256] Object ffff880401020010: 20 07 20 07 20 07 20 07 20 07 20 07 20 07 6b 6b   . . . . . . .kk
[  233.258257] Object ffff880401020020: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258258] Object ffff880401020030: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258259] Object ffff880401020040: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258260] Object ffff880401020050: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258260] Object ffff880401020060: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258261] Object ffff880401020070: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258262] Object ffff880401020080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258263] Object ffff880401020090: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258264] Object ffff8804010200a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258265] Object ffff8804010200b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258265] Object ffff8804010200c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258266] Object ffff8804010200d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258267] Object ffff8804010200e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258268] Object ffff8804010200f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258269] Object ffff880401020100: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258269] Object ffff880401020110: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  233.258270] Object ffff880401020120: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
[  233.258271] Redzone ffff880401020130: bb bb bb bb bb bb bb bb                          ........
[  233.258272] Padding ffff880401020140: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[  233.258273] Padding ffff880401020150: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[  233.258274] Padding ffff880401020160: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[  233.258275] Padding ffff880401020170: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[  233.258277] Pid: 4440, comm: lspci Tainted: G    B        3.7.1-default #30
[  233.258277] Call Trace:
[  233.258283]  [<ffffffff8111085b>] ? print_section+0x38/0x3a
[  233.258285]  [<ffffffff81110d19>] print_trailer+0x105/0x10e
[  233.258287]  [<ffffffff81110fe9>] check_bytes_and_report+0xac/0xe5
[  233.258290]  [<ffffffff811110e1>] check_object+0xbf/0x1ad
[  233.258291]  [<ffffffff8111197f>] ? check_slab+0xaf/0xbd
[  233.258294]  [<ffffffff81119b04>] ? get_empty_filp+0x6f/0x155
[  233.258297]  [<ffffffff815d2a31>] alloc_debug_processing+0x61/0xed
[  233.258299]  [<ffffffff815d34dd>] __slab_alloc+0x344/0x3ba
[  233.258301]  [<ffffffff81119b04>] ? get_empty_filp+0x6f/0x155
[  233.258303]  [<ffffffff8100536b>] ? print_context_stack+0xa2/0xbe
[  233.258305]  [<ffffffff81119b04>] ? get_empty_filp+0x6f/0x155
[  233.258307]  [<ffffffff81119b04>] ? get_empty_filp+0x6f/0x155
[  233.258309]  [<ffffffff81112f50>] kmem_cache_alloc+0x50/0xb6
[  233.258310]  [<ffffffff81119b04>] get_empty_filp+0x6f/0x155
[  233.258313]  [<ffffffff81123e4b>] path_openat+0x35/0x313
[  233.258315]  [<ffffffff8112440b>] do_filp_open+0x33/0x81
[  233.258317]  [<ffffffff815d9b93>] ? _raw_spin_unlock+0x23/0x27
[  233.258320]  [<ffffffff8112e4cb>] ? __alloc_fd+0xe4/0xf6
[  233.258322]  [<ffffffff81118403>] do_sys_open+0x68/0xfa
[  233.258323]  [<ffffffff811184b1>] sys_open+0x1c/0x1e
[  233.258325]  [<ffffffff815da756>] system_call_fastpath+0x1a/0x1f
[  233.258327] FIX filp: Restoring 0xffff880401020000-0xffff88040102001d=0x6b

[  233.258327] FIX filp: Marking all objects used


If you need .config or full dmesg please let me know and please Cc: me, ideally.
Martin
