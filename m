Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0HCHhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:37:08 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:65364 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0HCHhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:37:06 -0400
Message-ID: <4C57C72C.3070902@dcl.info.waseda.ac.jp>
Date: Tue, 03 Aug 2010 16:37:16 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC] perf lock: Add new event "lock_acquired_waittime"
 for contention analysis
References: <1279990529-8798-1-git-send-email-mitake@dcl.info.waseda.ac.jp>	 <20100728163946.GB5394@nowhere>  <4C5507F2.7090503@dcl.info.waseda.ac.jp> <1280751784.1923.146.camel@laptop>
In-Reply-To: <1280751784.1923.146.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/10 21:23, Peter Zijlstra wrote:
> On Sun, 2010-08-01 at 14:36 +0900, Hitoshi Mitake wrote:
>> I want to make lockdep production kernel feature with dynamic
>> patching.
>
> Not really feasible. Note that enabling lockdep grows the size of
> spinlock_t (and others) quite significantly.
>
> Then there is the problem that you need to pass all tasks through some
> quiesent state in order to enable lockdep (there must be a guarantee of
> no locks held).
>
> Now, we could possibly make it all work, but I'm not at all convinced we
> want to pay the price, which is a much _much_ more complex
> infrastructure.
>
>

I have to agree with the problem of huge cost you mentioned above.

But, I believe that
  - lock validation
  - lock tracing
  - in kernel light weight lock usage statistics
should be divided into individual features, at least.
And tracing and statistics should be available for production kernel, 
ideally.

How do you think about this point?
