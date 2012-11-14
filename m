Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422945Ab2KNNwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:52:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:22608 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab2KNNwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:52:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,250,1352102400"; 
   d="scan'208";a="219499788"
Date: Wed, 14 Nov 2012 21:52:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc()
Message-ID: <20121114135229.GA9917@localhost>
References: <20121113052026.GA26289@localhost>
 <50A2A5B6.4080600@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A2A5B6.4080600@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, Nov 13, 2012 at 08:55:34PM +0100, Jiri Slaby wrote:
> On 11/13/2012 06:20 AM, Fengguang Wu wrote:
> > Hi Jiri,
> 
> Hi,
> 
> > I got the following warning
> > 
> > cat: /proc/1/maps: No such file or directory
> > [   72.249806] ------------[ cut here ]------------
> > [   72.250807] WARNING: at /c/kernel-tests/src/tip/drivers/tty/tty_buffer.c:476 flush_to_ldisc+0x5a/0x1ad()
> > [   72.252674] tty is NULL
> > [   72.253182] Pid: 15, comm: kworker/0:1 Not tainted 3.7.0-rc4-05821-gdb38463 #166
> > [   72.253672] Call Trace:
> > [   72.253672]  [<ffffffff8103ccee>] warn_slowpath_common+0x62/0x79
> > [   72.256297]  [<ffffffff8103cd73>] warn_slowpath_fmt+0x46/0x48
> > [   72.257292]  [<ffffffff811e66c3>] flush_to_ldisc+0x5a/0x1ad
> > [   72.258478]  [<ffffffff81053a6d>] process_one_work+0x246/0x44f
> > [   72.259640]  [<ffffffff810539da>] ? process_one_work+0x1b3/0x44f
> > [   72.260817]  [<ffffffff811e6669>] ? tty_buffer_free+0x61/0x61
> > [   72.261820]  [<ffffffff81053fd2>] worker_thread+0x1ed/0x2c8
> > [   72.262883]  [<ffffffff81053de5>] ? rescuer_thread+0x140/0x140
> > [   72.263878]  [<ffffffff81058556>] kthread+0xd4/0xdc
> > [   72.264980]  [<ffffffff810625d7>] ? finish_task_switch.constprop.79+0x7a/0xbf
> > [   72.266150]  [<ffffffff81058482>] ? __kthread_parkme+0x61/0x61
> > [   72.267145]  [<ffffffff81533bea>] ret_from_fork+0x7a/0xb0
> > [   72.268361]  [<ffffffff81058482>] ? __kthread_parkme+0x61/0x61
> > 
> > and it's bisected to
> > 
> > commit ecbbfd44a08fa80e0d664814efd4c187721b85f6
> 
> Yes, I know about this already. Can you reproducible that easily given
> you bisected that? I would love to be able to reproduce that...

I checked the bisect log (attached in the original email) and it shows
that it may take several hundreds of boots to reproduce the error once.
So in the bisect, it regards 7540 repeated good boots as one success.

Thanks,
Fengguang
