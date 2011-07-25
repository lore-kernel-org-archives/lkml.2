Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab1GYNnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab1GYNnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:43:15 -0400
Date: Mon, 25 Jul 2011 09:42:26 -0400
From: Dave Jones <davej@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: DEBUG_LOCKS_WARN_ON() within lockdep trace_hardirqs_on_caller()
Message-ID: <20110725134226.GA10279@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org
References: <20110725120514.GA3174@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725120514.GA3174@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 03:05:14PM +0300, Sergey Senozhatsky wrote:
 > Hello,
 > 
 > Current 3.1.0-git3 (03873-g2c9c838), x86_64, has triggered an DEBUG_LOCKS_WARN_ON()
 > within trace_hardirqs_on_caller()
 > 
 > [ 4364.656167] ------------[ cut here ]------------
 > [ 4364.656186] WARNING: at kernel/lockdep.c:2532 trace_hardirqs_on_caller+0x6d/0x166()
 > [ 4364.656191] Hardware name: Aspire 5741G    
 > [ 4364.656264] Pid: 26796, comm: conftest Not tainted 3.1.0-dbg-03873-g2c9c838-dirty #652
 > [ 4364.656269] Call Trace:
 > [ 4364.656279]  [<ffffffff8103e970>] warn_slowpath_common+0x7e/0x96
 > [ 4364.656289]  [<ffffffff81477056>] ? __bad_area_nosemaphore+0x35/0x1b9
 > [ 4364.656296]  [<ffffffff8103e99d>] warn_slowpath_null+0x15/0x17
 > [ 4364.656303]  [<ffffffff81072770>] trace_hardirqs_on_caller+0x6d/0x166
 > [ 4364.656310]  [<ffffffff81072876>] trace_hardirqs_on+0xd/0xf
 > [ 4364.656317]  [<ffffffff81477056>] __bad_area_nosemaphore+0x35/0x1b9
 > [ 4364.656324]  [<ffffffff8147722f>] bad_area+0x45/0x4c
 > [ 4364.656333]  [<ffffffff814850f9>] do_page_fault+0x2da/0x48a
 > [ 4364.656343]  [<ffffffff810ec2d0>] ? do_brk+0x24e/0x2a2
 > [ 4364.656352]  [<ffffffff8124642d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 > [ 4364.656360]  [<ffffffff81482975>] page_fault+0x25/0x30
 > [ 4364.656366] ---[ end trace 9870b4ffc9ea6750 ]---

I hit this a few days ago too. http://lkml.org/lkml/2011/7/23/167
It started happening as soon as the x86 merge hit Linus tree (3.0 was fine).

	Dave

