Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1K1KLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 05:11:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:51839 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1K1KLN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 05:11:13 -0500
Message-ID: <1322475060.2921.95.camel@twins>
Subject: Re: [PATCH] perf_event: fix loss of notification with multi-event
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Mon, 28 Nov 2011 11:11:00 +0100
In-Reply-To: <20111126014731.GA7030@quad>
References: <20111126014731.GA7030@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-26 at 02:47 +0100, Stephane Eranian wrote:
> Here is a fixed version of Peter's patch.
> I fixed the compilation errors + added the missing
> linked list + spinlock initializations.
> 
> I also added the mmap_mutex in perf_poll() to avoid the
> race with perf_set_output(). It's not pretty but it solves
> the problem of a process getting stuck on a sampling buffer
> which is never going to get any samples. This was an unlikely
> scenario but we should take care of it anyway.
> 
> This patch solves the issue with loss of buffer notifications
> when sampling on multiple events at the same time. In that
> case fewer than expected samples would be captured.

Hehe, so it actually works eh.. amazing stuff ;-)

OK, I'll stick it in perf/urgent.. Thanks Stephane!

If anybody happens upon a prettier solution, don't be shy and please do
tell us ;-)


