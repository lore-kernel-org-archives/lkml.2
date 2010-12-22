Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab0LVNTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:19:05 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58435 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0LVNTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:19:03 -0500
Subject: Re: [tip:perf/core] tracing: Only trace sched_wakeup if it
 actually work something up
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-14bc7a06c6175cfa8070a5f5022210b648c3e0a7@git.kernel.org>
References: <tip-14bc7a06c6175cfa8070a5f5022210b648c3e0a7@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Dec 2010 14:19:05 +0100
Message-ID: <1293023945.2170.121.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 13:16 +0000, tip-bot for Steven Rostedt wrote:
> Commit-ID:  14bc7a06c6175cfa8070a5f5022210b648c3e0a7
> Gitweb:     http://git.kernel.org/tip/14bc7a06c6175cfa8070a5f5022210b648c3e0a7
> Author:     Steven Rostedt <srostedt@redhat.com>
> AuthorDate: Thu, 2 Dec 2010 16:56:14 -0500
> Committer:  Steven Rostedt <rostedt@goodmis.org>
> CommitDate: Fri, 3 Dec 2010 10:46:59 -0500
> 
> tracing: Only trace sched_wakeup if it actually work something up
> 
> Currently the tracepoint sched_wakeup traces the wakeup event even
> if the wakeup failed to wake anything up. This is quite stupid
> but it happens because we did not want to add a conditional
> to the core kernel code that would just slow down the wakeup events.
> 
> This patch changes the wakeup tracepoints to use the
> 
>  DEFINE_EVENT_CONDITIONAL()
> 
> to test the "success" parameter and will only trace the event if
> the wakeup was successfull.
> 
> The success field in the tracepoint is removed since it is no
> longer needed.

I NAKed this, its stupid.
