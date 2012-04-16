Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab2DPH1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:27:30 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48996 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163Ab2DPH13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:27:29 -0400
Message-ID: <1334561244.3339.7.camel@aep-desktop>
Subject: BUG: sleeping function called from invalid context at
 kernel/mutex.c:271
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: linux-kernel@vger.kernel.org
Date: Mon, 16 Apr 2012 13:27:24 +0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

With linux-3.3.0, my computer at work is rather unstable. The kernel
seems to leak memory, however, kmemleak finds nothing significant.

Finally, the computer started swapping heavily and responded only via
ssh. In dmesg, I found this (repeated every two seconds):

[ 6709.483956] BUG: sleeping function called from invalid context at
kernel/mutex.c:271
[ 6709.483968] in_atomic(): 0, irqs_disabled(): 0, pid: 1210, name:
NetworkManager
[ 6709.483974] INFO: lockdep is turned off.
[ 6709.483981] Pid: 1210, comm: NetworkManager Tainted: G          I
3.3.0-gentoo #4
[ 6709.483987] Call Trace:
[ 6709.484006]  [<ffffffff810683fc>] __might_sleep+0xff/0x103
[ 6709.484019]  [<ffffffff81548783>] mutex_lock_nested+0x2a/0x2ff
[ 6709.484031]  [<ffffffff811261b5>] ? fget_light+0x6a/0x118
[ 6709.484043]  [<ffffffff8115a738>] inotify_poll+0x35/0x53
[ 6709.484052]  [<ffffffff81135eb1>] do_sys_poll+0x266/0x3f2
[ 6709.484060]  [<ffffffff81134e33>] ? poll_freewait+0x8f/0x8f
[ 6709.484069]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
[ 6709.484076]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
[ 6709.484084]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
[ 6709.484092]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
[ 6709.484099]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
[ 6709.484107]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
[ 6709.484118]  [<ffffffff8112fde0>] ? putname+0x2d/0x36
[ 6709.484127]  [<ffffffff8112fde0>] ? putname+0x2d/0x36
[ 6709.484138]  [<ffffffff81045cb7>] ? timespec_add_safe+0x32/0x5f
[ 6709.484146]  [<ffffffff81018078>] ? read_tsc+0x9/0x1b
[ 6709.484155]  [<ffffffff8113509a>] ? poll_select_set_timeout+0x61/0x75
[ 6709.484163]  [<ffffffff811360d8>] sys_poll+0x4e/0xb7
[ 6709.484173]  [<ffffffff81552896>] sysenter_dispatch+0x7/0x21

The taint is due to nouveau. I am sure that this
"sleeping-in-invalid-context" report is a consequence of the memory leak
that I could not convert into something reportable. But still, it is
something that the kernel wants me to report, that's why this e-mail.

The kernel is configured as CONFIG_PREEMPT=y, if this is relevant.

-- 
Alexander E. Patrakov

