Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2KWU2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:28:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab2KWU2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:28:01 -0500
Date: Fri, 23 Nov 2012 21:27:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] uprobes: register/unregister preparations for filtering
Message-ID: <20121123202741.GA18858@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Srikar, it is not clear if you was convinced or not during the
last discussion. We will discuss this again probably. So far
I am sending the initial changes which (I think) make sense in
any case. Please review.

The next step is locking. Alas, we can not use consumer_rwsem
to protect the list in filter_chain(). Whatever we do, at least
uprobe_mmap() needs to do this under mm->mmap_sem. And we do
want to allow uc->handler() to play with current->mm.

Then we will actually immplement filter_chain(), this should be
trivial unless you insist we need for_each_mm_user() (cough, I
hope you do not ;).

Then we will try to solve the problem with fork.

Oleg.

