Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2JAKvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:51:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:35219 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2JAKvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:51:19 -0400
Message-ID: <1349088639.7780.4.camel@twins>
Subject: Re: task_work_add/scheduler_tick: possible circular locking
 dependency detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@kernel.org
Date: Mon, 01 Oct 2012 12:50:39 +0200
In-Reply-To: <20120928113402.GA577@localhost>
References: <20120928113402.GA577@localhost>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 19:34 +0800, Fengguang Wu wrote:
> Peter,
> 
> I got the warning
> 
> [   10.412023] 
> [   10.412611] ======================================================
> [   10.413014] [ INFO: possible circular locking dependency detected ]
> [   10.413014] 3.6.0-rc4-00098-g7eaffe9 #402 Not tainted
> [   10.413014] -------------------------------------------------------
> [   10.413014] init/1 is trying to acquire lock:
> [   10.413014]  (&p->pi_lock){-.-.-.}, at: [<ffffffff81088214>] task_work_add+0x28/0x82
> [   10.413014] 
> [   10.413014] but task is already holding lock:
> [   10.413014]  (&rq->lock){-.-.-.}, at: [<ffffffff8109c6ea>] scheduler_tick+0x3f/0xec
> [   10.413014] 
> [   10.413014] which lock already depends on the new lock.
> [   10.413014] 
> [   10.413014] 
> 

The commit ac3d0da8f3290b3d394cdb7f50604424a7cd6092 should avoid this
from happening, not sure what branch its on, but it was in tip before
all this landed, so I guess its due to you testing sched/numa branch and
not a merged branch like master or auto-next.


