Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2ILRpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:45:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:57354 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2ILRpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:45:16 -0400
Message-ID: <1347471911.15764.72.camel@twins>
Subject: Re: [RFC][PATCH] perf, intel: Don't touch MSR_IA32_DEBUGCTLMSR from
 NMI context
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Wed, 12 Sep 2012 19:45:11 +0200
In-Reply-To: <1347471446.15764.67.camel@twins>
References: <1347466967.15764.63.camel@twins>
	 <CABPqkBQsJr_Cp36Df-etOaHhGh8T6XVngraDQt52ZtKahr6KBQ@mail.gmail.com>
	 <1347471446.15764.67.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 19:37 +0200, Peter Zijlstra wrote:
> Ah, so I do think EIO will re-enable LBR,

OK, it does not, but the:

>  also the handler is wrapped in
> x86_pmu::{dis,en}able_all() which does end up calling
> intel_pmu_lbr_{dis,en}able_all().

Thing does the re-enable for us,

>  However that leaves the MSR in the
> exact same state on exit as it was on enter, so that's not a problem for
> the: read-modify-write change. 

in a safe way.
