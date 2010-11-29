Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0K2Xpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:45:46 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:33572 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab0K2Xpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:45:45 -0500
Content-Type: text/plain; charset=UTF-8
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/6] perf: Add timestamp to COMM and MMAP events
From: Ian Munsie <imunsie@au1.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
In-reply-to: <1291031690.32004.20.camel@laptop>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com> <1290490544-14349-4-git-send-email-imunsie@au1.ibm.com> <1290510512.2072.387.camel@laptop> <20101123124121.GA11101@ghostprotocols.net> <20101125154718.GE15875@ghostprotocols.net> <1291009409-sup-4332@au1.ibm.com> <1291031690.32004.20.camel@laptop>
Date: Tue, 30 Nov 2010 10:45:40 +1100
Message-Id: <1291073899-sup-7083@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Excerpts from Peter Zijlstra's message of Mon Nov 29 22:54:50 +1100 2010:
> On Mon, 2010-11-29 at 17:06 +1100, Ian Munsie wrote:
> > This goes away if PERF_SAMPLE_CPU is added to the mix so that the
> > timestamps are offset from the first event of *their* CPU, otherwise
> > time-epoch can go negative, as it has done here. 
> 
> How does that happen, I though the power7 sched_clock() was fully
> synchronized and monotonic across all cores?

Oh the timestamps coming from the kernel are fine, I should have been
clearer in my email. This bug is purely restricted to the userspace code
that prints them out - in the perf_session__print_tstamp function. It
tries to print the timestamps out so that they start at 0 and if it
doesn't know what CPU the events came from it uses the very first event
it sees as epoch, but at the moment that is not necessarily going to be
the earliest event.

Thinking about it overnight, I realise that this should also go away if
we sort them before printing things out at all, which is exactly what
I'm proposing to do in my patches.

Cheers,
-Ian
