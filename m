Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0EYKBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 06:01:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:57049 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab0EYKBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 06:01:14 -0400
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
From: Peter Zijlstra <peterz@infradead.org>
To: piotr@hosowicz.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4BFB9F0A.9040803@example.com>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <20100525094347.GA7881@elte.hu>  <4BFB9F0A.9040803@example.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 12:00:55 +0200
Message-ID: <1274781655.5882.765.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 11:57 +0200, Piotr Hosowicz wrote:
> On 25.05.2010 11:43, Ingo Molnar wrote:
> 
> > This doesnt fix the whole issue. cpu_clock() is local, while the measurements
> > done in the blk code are global ...
> >
> > While the warning is fixed this way, the far more serious issue is still
> > there: time can go backwards if two points of time measurement are on
> > different CPUs and can mess up the statistics with negative values, etc...
> 
> How serious is this? Can it damage my data? I ask because the machine is 
> my private computer, not any test machine.

I'm not sure, since I didn't really look what they use the timestamps
for, but a guess would say your data is safe, it might schedule the io
funny, but it should not compromise integrity. At best its used purely
for statistics and not even behaviour is affected.
