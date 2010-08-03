Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab0HCIBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:01:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab0HCIBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:01:00 -0400
Subject: Re: [PATCH RFC] perf lock: Add new event "lock_acquired_waittime"
 for contention analysis
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4C57C72C.3070902@dcl.info.waseda.ac.jp>
References: <1279990529-8798-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100728163946.GB5394@nowhere>  <4C5507F2.7090503@dcl.info.waseda.ac.jp>
	 <1280751784.1923.146.camel@laptop> <4C57C72C.3070902@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 03 Aug 2010 10:00:40 +0200
Message-ID: <1280822440.1923.403.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 16:37 +0900, Hitoshi Mitake wrote:
> But, I believe that
>   - lock validation
>   - lock tracing
>   - in kernel light weight lock usage statistics
> should be divided into individual features, at least.
> And tracing and statistics should be available for production kernel, 
> ideally.
> 
> How do you think about this point? 

Both the lock usage and lock validation use the lock classification
scheme and thus require the bloated lock structures, and hence I don't
think its at all reasonable to do that runtime.

lock tracing could possibly be done by patching all lock sites, but we'd
have to be somewhat careful there too not to make the whole spinlock
code even worse than it already is.
