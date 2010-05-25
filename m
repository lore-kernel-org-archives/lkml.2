Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab0EYQPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:15:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:43664 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab0EYQPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:15:30 -0400
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
From: Peter Zijlstra <peterz@infradead.org>
To: piotr@hosowicz.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4BFBE357.2040602@example.com>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <20100525094347.GA7881@elte.hu>  <4BFB9F0A.9040803@example.com>
	 <1274781655.5882.765.camel@twins> <4BFBA0F8.9090908@example.com>
	 <4BFBA6A2.4070405@example.com> <4BFBDAF3.3020504@example.com>
	 <4BFBE004.5060101@example.com> <1274798197.5882.1491.camel@twins>
	 <4BFBE357.2040602@example.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 18:15:01 +0200
Message-ID: <1274804101.5882.1805.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 16:48 +0200, Piotr Hosowicz wrote:
> May 25 15:04:35 aapi205 kernel: [ 9694.523288] BUG: using smp_processor_id() in preemptible [00000000] code: shutdown/16256
> May 25 15:04:35 aapi205 kernel: [ 9694.523296] caller is dqstats_inc+0x19/0x2c
> May 25 15:04:35 aapi205 kernel: [ 9694.523299] Pid: 16256, comm: shutdown Tainted: P        W   2.6.34-20100524-1752-patched #1
> May 25 15:04:35 aapi205 kernel: [ 9694.523301] Call Trace:
> May 25 15:04:35 aapi205 kernel: [ 9694.523308]  [<ffffffff811a537b>] debug_smp_processor_id+0xc7/0xe0
> May 25 15:04:35 aapi205 kernel: [ 9694.523311]  [<ffffffff8112c0ad>] dqstats_inc+0x19/0x2c
> May 25 15:04:35 aapi205 kernel: [ 9694.523314]  [<ffffffff8112ee66>] vfs_quota_sync+0x1b1/0x293
> May 25 15:04:35 aapi205 kernel: [ 9694.523319]  [<ffffffff8103bf21>] ? wake_up_process+0x10/0x12

That's a different issue, see:

  http://lkml.org/lkml/2010/5/22/164
