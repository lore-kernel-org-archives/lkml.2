Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1ASSuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:50:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:56080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab1ASSug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:50:36 -0500
Subject: Re: [PATCH 2/2] perf: fix
 perf_event_init_task()/perf_event_free_task() interaction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110119182228.GC12183@redhat.com>
References: <20101108145647.GA3426@redhat.com>
	 <20101108145725.GA3434@redhat.com> <20110119182141.GA12183@redhat.com>
	 <20110119182228.GC12183@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 Jan 2011 19:51:13 +0100
Message-ID: <1295463073.28776.149.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 19:22 +0100, Oleg Nesterov wrote:
> perf_event_init_task() should clear child->perf_event_ctxp[] before
> anything else. Otherwise, if perf_event_init_context(perf_hw_context)
> fails, perf_event_free_task() can free perf_event_ctxp[perf_sw_context]
> copied from parent->perf_event_ctxp[] by dup_task_struct().
> 
> Also move the initialization of perf_event_mutex and perf_event_list
> from perf_event_init_context() to perf_event_init_context().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Another fine find.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
