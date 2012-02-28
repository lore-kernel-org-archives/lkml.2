Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2B1Qsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:48:41 -0500
Received: from mga12.intel.com ([143.182.124.36]:25432 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754385Ab2B1Qsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:48:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dan.j.williams@intel.com designates 10.182.51.73 as permitted sender) smtp.mail=dan.j.williams@intel.com
MIME-Version: 1.0
In-Reply-To: <1330422535.11248.78.camel@twins>
References: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
	<1330422535.11248.78.camel@twins>
Date: Tue, 28 Feb 2012 08:48:38 -0800
Message-ID: <CABE8wwtv2YDCYkk5C5waZCkdG3+9pMbwsKvuce0q-Kj=pnduwg@mail.gmail.com>
Subject: Re: [RFC PATCH] kick ksoftirqd more often to please soft lockup detector
From: Dan Williams <dan.j.williams@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org, Lukasz Dorau <lukasz.dorau@intel.com>,
        James Bottomley <JBottomley@parallels.com>,
        Andrzej Jakowski <andrzej.jakowski@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 1:48 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1:78]
>
> So you're stuck in softirq for 22s+, max_restart is 10, this gives that
> on average you spend 2.2s+ per softirq invocation, this is completely
> absolutely bonkers. Softirq handlers should never consume significant
> amount of cpu-time.

I'm not sure whether this was just one __do_softirq() invocation, or
multiple.  I'll see if I can instrument this, but the suspicion is
that max_restart can't help when softirq is constantly re-triggered.
I'll also add the below patch to see if any single invocation is
violating these expectations.

--
Dan
