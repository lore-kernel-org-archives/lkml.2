Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab2IDLqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 07:46:19 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:20888 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab2IDLqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 07:46:17 -0400
Date: Tue, 4 Sep 2012 13:46:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, bjorn@mork.no,
        chunkeey@googlemail.com, linville@tuxdriver.com,
        LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: input0: bad kobj_uevent_env content in show_uevent()
Message-ID: <20120904134604.7d95ab2b@endymion.delvare>
In-Reply-To: <20120902083402.GA21787@localhost>
References: <20120902075946.GA21198@localhost>
	<20120902083402.GA21787@localhost>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2012 16:34:02 +0800, Fengguang Wu wrote:
> It's more than the input device that can trigger the panic.
> Here is another trace which panics on accessing dmi/id/uevent:
> 
> [   32.380795] sysfs_read_file: /sys/devices/virtual/dmi/id/uevent
> [   32.399379] dmi id: uevent 73 env[1677721600]: id/.../id
> [   32.400780] uevent 0 env[0]: (null)
> [   32.401695] uevent 7 env[1]: (null)
> ...
> [   32.478415] general protection fault: 0000 [#1] PREEMPT 
> [   32.479953] CPU 0 
> [   32.480433] Pid: 114, comm: trinity-child0 Not tainted 3.6.0-rc4-bisect2-00001-gb6d86d3-dirty #26 Bochs Bochs
> [   32.482995] RIP: 0010:[<ffffffff81266c33>]  [<ffffffff81266c33>] strnlen+0x23/0x70
> ...
> [   32.486234] Call Trace:
> [   32.486234]  [<ffffffff81268d5c>] string.isra.4+0x4c/0x120
> [   32.486234]  [<ffffffff81269f19>] vsnprintf+0x2c9/0x900
> [   32.486234]  [<ffffffff8126a9c9>] vscnprintf+0x19/0x50
> [   32.486234]  [<ffffffff8105f8c7>] vprintk_emit+0xe7/0x750
> [   32.486234]  [<ffffffff81a49ba9>] printk+0x4f/0x58
> [   32.486234]  [<ffffffff8150522b>] show_uevent+0x1cb/0x220
> [   32.486234]  [<ffffffff81501dcb>] dev_attr_show+0x2b/0x90
> [   32.486234]  [<ffffffff81174bea>] ? sysfs_read_file+0x18a/0x320
> [   32.486234]  [<ffffffff810f2974>] ? __get_free_pages+0x24/0xc0
> [   32.486234]  [<ffffffff81174c2d>] sysfs_read_file+0x1cd/0x320

I can't reproduce this, sorry, so I can't look into it. If it takes
special steps to reproduce, please tell me, as I wasn't part of the
original discussion.

-- 
Jean Delvare
