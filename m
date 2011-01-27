Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1A0RKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 12:10:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:34022 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1A0RKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 12:10:53 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110127165712.GC25060@redhat.com>
References: <20110120193033.GA13924@redhat.com>
	 <1295611905.28776.269.camel@laptop> <20110121130323.GA12900@elte.hu>
	 <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com>
	 <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere>
	 <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com>
	 <1296134077.15234.161.camel@laptop>  <20110127165712.GC25060@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 18:11:34 +0100
Message-ID: <1296148294.15234.242.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 17:57 +0100, Oleg Nesterov wrote:
> 
> > With, however, things are more interesting. 2 seems to be adequately
> > covered by the patch I just send, the IPI will bail and the next
> > sched-in of the relevant task will pick matters up. 1 otoh doesn't seem
> > covered, the IPI will bail, leaving us stranded.
> 
> Hmm, yes... Strangely, I missed that when I was thinking about in_ctxsw.
> 
> Perhaps, we can change task_oncpu_function_call() so that it returns
> -EAGAIN in case it hits in_ctxsw != 0? If the caller sees -EAGAIN, it
> should always retry even if !ctx->is_active.

That would be very easy to do, we can pass a return value through the
task_function_call structure.
