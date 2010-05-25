Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934311Ab0EYVfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:35:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:40908 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab0EYVft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:35:49 -0400
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code: 
 icedove-bin/5449
From: Peter Zijlstra <peterz@infradead.org>
To: Divyesh Shah <dpshah@google.com>
Cc: piotr@hosowicz.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <AANLkTimYiuKGPnYjEgf_vh7bGnZz30XS3ioiuDxWtOL7@mail.gmail.com>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <AANLkTimYiuKGPnYjEgf_vh7bGnZz30XS3ioiuDxWtOL7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 23:35:41 +0200
Message-ID: <1274823341.5882.2774.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 11:07 -0700, Divyesh Shah wrote:
> Peter, this only affects some stats collection and no scheduling
> behavior should be affected by this. Besides this call at rq_init() to
> sched_clock() there are other calls in the request dispatch and the
> request completion path. Not sure if those are problematic too.
> 
> @Ingo, about your concern of time going backwards. This could happen
> with sched_clock() as well when successive measurements were made on
> different cpus which are slightly out of sync. This case is handled
> well in all places where this was used. 

You really shouldn't be using sched_clock(), that thing can exhibit
unbounded drift between cpus.
