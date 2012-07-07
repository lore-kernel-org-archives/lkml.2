Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2GGBLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 21:11:32 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64665 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2GGBLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 21:11:31 -0400
X-AuditID: 9c93016f-b7c7eae0000025c5-3b-4ff78cc0360f
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf lock record fails
References: <4FF7200B.5060008@gmail.com>
Date: Sat, 07 Jul 2012 10:06:56 +0900
In-Reply-To: <4FF7200B.5060008@gmail.com> (David Ahern's message of "Fri, 06
	Jul 2012 11:27:39 -0600")
Message-ID: <874npkidlb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

On Fri, 06 Jul 2012 11:27:39 -0600, David Ahern wrote:
> What config options need to be enabled for 'perf lock record' to work?
> I tried a number of custom builds and stock Fedora kernels. I always
> get:
>
> $ perf lock record -- sleep 1
> invalid or unsupported event: 'lock:lock_acquire'
>
> Though trace_lock_acquire exists, CONFIG_LOCKDEP is set, and ftrace is
> enabled.
>
> What am I missing?
>

Weird. AFAICS lock_acquire and lock_release depend on CONFIG_LOCKDEP,
and lock_acquired and lock_contented depend on CONFIG_LOCK_STAT (I guess
it should be warned/commented somewhere?). Maybe CONFIG_EVENT_TRACING?

Thanks,
Namhyung
