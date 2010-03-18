Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab0CRF7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 01:59:32 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61740 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0CRF7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 01:59:30 -0400
Message-ID: <4BA1C141.8050409@dcl.info.waseda.ac.jp>
Date: Thu, 18 Mar 2010 14:59:29 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       h.mitake@gmail.com, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
 lock
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere> <20100317095230.GD17146@elte.hu>
In-Reply-To: <20100317095230.GD17146@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/10 18:52, Ingo Molnar wrote:
 >
 > * Frederic Weisbecker<fweisbec@gmail.com>  wrote:
 >
 >>> You add chained indirect calls into all lock ops, that's got to hurt.
 >>
 >> Well, the idea was not bad at the first glance. It was separating 
lockdep
 >> and lock events codes.
 >>
 >> But indeed, the indirect calls plus the locking are not good for 
such a fast
 >> path.
 >
 > What would be nice to have is some sort of dynamic patching approach 
to enable
 > _both_ lockdep, lockstat and perf lock.
 >
 > If TRACE_EVENT() tracepoints were patchable we could use them. (but 
they arent
 > right now)

I'll try it!

And I have a question related to this dynamic patching approach for lockdep.
If dynamic proving turning on/off is provided,
lockdep will be confused by inconsistency of lock acquiring log.

Will the sequence,

lock_acquire(l) -> turning off -> lock_release(l) -> turning on -> 
lock_acquire(l)

detected as double acquiring?

Should turning on/off lockdep be done in the time
when every processes have no lock?

