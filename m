Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0FLJmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 05:42:49 -0400
Received: from [18.85.46.34] ([18.85.46.34]:52813 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab0FLJmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 05:42:45 -0400
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code: 
 icedove-bin/5449
From: Peter Zijlstra <peterz@infradead.org>
To: Divyesh Shah <dpshah@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>,
       piotr@hosowicz.com, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTilDRP8WX62NwnjgBROf3hWsI5BHPJf__Aw77-la@mail.gmail.com>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <20100601064120.GA3407@elte.hu> <20100601064726.GG1660@kernel.dk>
	 <20100601065500.GA7876@elte.hu> <20100601075345.GP1660@kernel.dk>
	 <AANLkTilDRP8WX62NwnjgBROf3hWsI5BHPJf__Aw77-la@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 12 Jun 2010 11:42:24 +0200
Message-ID: <1276335744.2077.3093.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 18:54 -0700, Divyesh Shah wrote:
> I was able to repro the issue and and have a patch that
> replaces use of sched_clock() in block layer w/
> ktime_to_ns(ktime_get()). 

You know ktime_get() is terrifyingly expensive, right?
