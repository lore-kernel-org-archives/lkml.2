Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0C2CAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:00:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56129 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab0C2CAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:00:41 -0400
Message-ID: <4BB00A08.2050702@cn.fujitsu.com>
Date: Mon, 29 Mar 2010 10:01:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [BUG] perf: hard lockup when using perf-sched
References: <4BA082EC.8030101@cn.fujitsu.com>	 <4BA9A885.9050105@cn.fujitsu.com>	 <1269415964.6530.25.camel@marge.simson.net>	 <1269418671.6465.6.camel@marge.simson.net>	 <4BAB1924.4060304@cn.fujitsu.com>	 <1269509241.8438.30.camel@marge.simson.net> <1269598293.6174.8.camel@marge.simson.net>
In-Reply-To: <1269598293.6174.8.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems to work, in contrast to everything I tried yesterday.  Not
> exactly a thing of beauty, but at least it's an option, so...
> 
> perf: fix perf sched record forkbomb deadlock
> 
> perf sched record can deadlock a box should the holder of handle->data->lock
> take an interrupt, and then attempt to acquire an rq lock held by a CPU trying
> to acquire the same lock.  Disable interrupts.
> 

This patch fixes the lockup on my box. Thanks!

> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> LKML-Reference: <new-submission>
> 
