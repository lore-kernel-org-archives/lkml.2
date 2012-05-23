Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2EWQd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:33:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41535 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab2EWQd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:33:58 -0400
Subject: Re: [tip:perf/core] Revert "sched, perf: Use a single callback
 into the scheduler"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jolsa@redhat.com
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-ab0cce560ef177bdc7a8f73e9962be9d829a7b2c@git.kernel.org>
References: <20120523111302.GC1638@m.brq.redhat.com>
	 <tip-ab0cce560ef177bdc7a8f73e9962be9d829a7b2c@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 18:33:54 +0200
Message-ID: <1337790834.9783.30.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 09:09 -0700, tip-bot for Jiri Olsa wrote:
>  > I rather liked we could do away with both that black-spot and
>  > clean up the code a little, but apparently people rely on it.
> 
Ingo noted that inherited counters already are active over the context
switch (due to the lazy switch optimization) and thus profile the
context switch cost.

Regular per-task counters not including this are therefore not
consistent.

So it would be good to find a way to fix the tracing fallout
differently. A well..

