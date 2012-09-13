Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab2IMMM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:12:26 -0400
Received: from [205.233.59.134] ([205.233.59.134]:52298 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab2IMMMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:12:25 -0400
Message-ID: <1347538265.15764.129.camel@twins>
Subject: Re: [RFC][PATCH] perf, intel: Don't touch MSR_IA32_DEBUGCTLMSR from
 NMI context
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Thu, 13 Sep 2012 14:11:05 +0200
In-Reply-To: <CABPqkBQk2TsnyZF52rvcH9wKO=P7=RAgTTjYPQjeAjOFUob4_g@mail.gmail.com>
References: <1347466967.15764.63.camel@twins>
	 <1347531789.15764.124.camel@twins>
	 <CABPqkBQk2TsnyZF52rvcH9wKO=P7=RAgTTjYPQjeAjOFUob4_g@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 13:49 +0200, Stephane Eranian wrote:
> Should be, though it is pretty ugly to stash all of this in the
> put/get constraints.

Agreed, I almost added two extra functions for it but when I went to
look at where to call them I ended up next to get/put constraints.

> I will run some tests.
> 
> I wonder what this does when you come in to get/put with a fake cpuc. You don't
> want to perturb the local lbr which may be in use. 

Fake cpu will never set ->alloc and thus intel_pmu_has_lbr() should fail
and we don't do anything.
