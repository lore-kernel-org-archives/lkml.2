Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab1AZS57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:57:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab1AZS56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:57:58 -0500
Date: Wed, 26 Jan 2011 19:49:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110126184957.GA32578@redhat.com>
References: <20110119182141.GA12183@redhat.com> <20110120193033.GA13924@redhat.com> <1295611905.28776.269.camel@laptop> <20110121130323.GA12900@elte.hu> <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com> <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126175322.GA28617@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Oleg Nesterov wrote:
>
> Please see the untested patch below. It doesn't change perf_event_enable(),
> only perf_install_in_context().

Forgot to mention... Also, it doesn't try to fix the race with do_exit(),
this needs another change.

And, damn, can't resist. This is mostly cosmetic issue, but I feel
discomfort every time I look at task_oncpu_function_call(). It _looks_
obviously wrong, even if the problem doesn't exist in practice. I'll
send the pedantic fix to keep the maintainers busy ;)

Oleg.

