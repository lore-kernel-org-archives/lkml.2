Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0CWPpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:45:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0CWPpm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:45:42 -0400
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
 lock
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
In-Reply-To: <20100317153858.GA5059@nowhere>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere>
	 <4BA0852D.1090300@dcl.info.waseda.ac.jp>  <20100317153858.GA5059@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 16:45:34 +0100
Message-ID: <1269359134.5109.93.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 16:39 +0100, Frederic Weisbecker wrote:
> 
> might_lock_read() uses might_fault(), rcu, workqueues and probably
> yet some others use sequences of lock_acquire/lock_release to prove
> locking while there is actually no real lock operation involved, but
> this is to detect dependency/balance mistakes. 

might_fault() simply always takes the mmap_sem because actually hitting
the fault path (which otherwise would establish that relation) is very
rare for some cases, so by forcing that dependency we get better
coverage.

rcu_read_lock() is an actual lock :-)

workqueues use 'fake' locks to connect lock chains to flush, so that we
can detect things like trying to flush a workqueue while holding a lock
that is required to complete the work.


