Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab0JLKgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:36:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:54837 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0JLKgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:36:42 -0400
Subject: Re: [RFC PATCH 2/2] lockdep: caching subclasses
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1286269311-28336-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1286269311-28336-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1286269311-28336-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Oct 2010 12:36:12 +0200
Message-ID: <1286879772.29097.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 18:01 +0900, Hitoshi Mitake wrote:
> Current lockdep_map only caches one class with subclass == 0,
> and looks up hash table of classes when subclass != 0.
> 
> It seems that this has no problem because the case of
> subclass != 0 is rare. But locks of struct rq are
> acquired with subclass == 1 when task migration is executed.
> Task migration is high frequent event, so I modified lockdep
> to cache subclasses.
> 
> I measured the score of perf bench sched messaging.
> This patch has slightly but certain (order of milli seconds
> or 10 milli seconds) effect when lots of tasks are running.
> I'll show the result in the tail of this description.
> 
> NR_LOCKDEP_CACHING_CLASSES specifies how many classes can be
> cached in the instances of lockdep_map.
> I discussed with Peter Zijlstra in LinuxCon Japan about
> this approach and he taught me that caching every subclasses(8)
> is cleary waste of memory. So number of cached classes
> should be configurable.
> 
> I think that this patch has a little effect for making lockdep
> as a production feature, I'd like to hear your comments.
> 
> Thanks,
> 
> === Score comparison of benchmarks ===
> # "min" means best score, and "max" means worst score
> 
> for i in `seq 1 10`; do ./perf bench -f simple sched messaging; done
> 
> before: min: 0.565000, max: 0.583000, avg: 0.572500
> after:  min: 0.559000, max: 0.568000, avg: 0.563300
> 
> # with more processes
> for i in `seq 1 10`; do ./perf bench -f simple sched messaging -g 40; done
> 
> before: min: 2.274000, max: 2.298000, avg: 2.286300
> after:  min: 2.242000, max: 2.270000, avg: 2.259700

Very nice numbers, I'll queue this patch.

Thanks!
