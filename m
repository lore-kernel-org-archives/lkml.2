Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1EaOH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:07:58 -0400
Received: from canuck.infradead.org ([134.117.69.58]:51810 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1EaOH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:07:57 -0400
X-Greylist: delayed 3324 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 10:07:57 EDT
Subject: Re: perf cgroup per-task attaching
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: Ben Blum <bblum@andrew.cmu.edu>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110531140359.GA13134@aftab>
References: <20110531140359.GA13134@aftab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 31 May 2011 16:07:40 +0200
Message-ID: <1306850860.2353.111.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 16:03 +0200, Borislav Petkov wrote:
> Just FYI:
> 
> I'm getting
> 
> kernel/events/core.c:7445: warning: initialization from incompatible pointer type
> 
> when building -rc1 with CONFIG_CGROUP_PERF enabled. AFAICT, this is
> due to the fact that f780bdb7c1c73009cb57adcf99ef50027d80bf3c dropped
> the threadgroup arg from cgroup_subsys->attach in favour of per-thread
> callbacks.
> 
> perf_cgroup_attach() actually does reschedule the task context after
> the cgroup changes so the perf cgroup code would need some non-trivial
> adjusting to the new APIs.

lkml.kernel.org/r/tip-74c355fbdfedd3820046dba4f537876cea54c207@git.kernel.org
