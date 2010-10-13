Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0JMOvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:51:06 -0400
Received: from canuck.infradead.org ([134.117.69.58]:57424 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0JMOvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:51:04 -0400
Date: Wed, 13 Oct 2010 10:51:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs: Inode cache scalability V3
Message-ID: <20101013145102.GA12155@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got an interesting oops running xfsqa 030 on this series.  Not
sure it's a new one, though:

Entering kdb (current=0xf6ff7270, pid 2274) on processor 0 Oops: (null)
due to oops @ 0xc022de60
<d>Modules linked in:
<c>
<d>Pid: 2274, comm: flush-252:16 Not tainted 2.6.36-rc7+ #399 /Bochs
<d>EIP: 0060:[<c022de60>] EFLAGS: 00010246 CPU: 0 EIP is at redirty_tail+0x90/0xa0
<d>EAX: c0d6cda0 EBX: f54b67fc ECX: 00000000 EDX: 00000000
<d>ESI: f7808c88 EDI: f685a308 EBP: f4109e78 ESP: f4109e70
<d> DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
<0>Process flush-252:16 (pid: 2274, ti=f4108000 task=f6ff7270 task.ti=f4108000)
<0>Stack: f685a2a4 f54b67fc f4109ea4 c022e7df f4109e90 f685a310 f685a318 f4109ed8
<0> 014b6804 f5d29260 f5d29260 f685a2a4 00000000 f4109f18 c022ef78 00000001
<0> f4109ed8 00000000 00000000 c018bb4d f6ff7270 f685a310 f6ff7714 f685a308
<0>Call Trace:
<0> [<c022e7df>] ? writeback_sb_inodes+0x6f/0x1a0
<0> [<c022ef78>] ? wb_writeback+0x118/0x320
<0> [<c018bb4d>] ? local_clock+0x6d/0x70
<0> [<c016f0bc>] ? local_bh_enable_ip+0x6c/0xd0
<0> [<c022f1f5>] ? wb_do_writeback+0x75/0x190
<0> [<c0175d44>] ? del_timer+0x74/0xc0
