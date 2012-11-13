Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2KMTzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:55:39 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43471 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab2KMTzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:55:38 -0500
Message-ID: <50A2A5B6.4080600@suse.cz>
Date: Tue, 13 Nov 2012 20:55:34 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc()
References: <20121113052026.GA26289@localhost>
In-Reply-To: <20121113052026.GA26289@localhost>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 06:20 AM, Fengguang Wu wrote:
> Hi Jiri,

Hi,

> I got the following warning
> 
> cat: /proc/1/maps: No such file or directory
> [   72.249806] ------------[ cut here ]------------
> [   72.250807] WARNING: at /c/kernel-tests/src/tip/drivers/tty/tty_buffer.c:476 flush_to_ldisc+0x5a/0x1ad()
> [   72.252674] tty is NULL
> [   72.253182] Pid: 15, comm: kworker/0:1 Not tainted 3.7.0-rc4-05821-gdb38463 #166
> [   72.253672] Call Trace:
> [   72.253672]  [<ffffffff8103ccee>] warn_slowpath_common+0x62/0x79
> [   72.256297]  [<ffffffff8103cd73>] warn_slowpath_fmt+0x46/0x48
> [   72.257292]  [<ffffffff811e66c3>] flush_to_ldisc+0x5a/0x1ad
> [   72.258478]  [<ffffffff81053a6d>] process_one_work+0x246/0x44f
> [   72.259640]  [<ffffffff810539da>] ? process_one_work+0x1b3/0x44f
> [   72.260817]  [<ffffffff811e6669>] ? tty_buffer_free+0x61/0x61
> [   72.261820]  [<ffffffff81053fd2>] worker_thread+0x1ed/0x2c8
> [   72.262883]  [<ffffffff81053de5>] ? rescuer_thread+0x140/0x140
> [   72.263878]  [<ffffffff81058556>] kthread+0xd4/0xdc
> [   72.264980]  [<ffffffff810625d7>] ? finish_task_switch.constprop.79+0x7a/0xbf
> [   72.266150]  [<ffffffff81058482>] ? __kthread_parkme+0x61/0x61
> [   72.267145]  [<ffffffff81533bea>] ret_from_fork+0x7a/0xb0
> [   72.268361]  [<ffffffff81058482>] ? __kthread_parkme+0x61/0x61
> 
> and it's bisected to
> 
> commit ecbbfd44a08fa80e0d664814efd4c187721b85f6

Yes, I know about this already. Can you reproducible that easily given
you bisected that? I would love to be able to reproduce that...

thanks,
-- 
js
suse labs
