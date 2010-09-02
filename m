Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab0IBIXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:23:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34774 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0IBIXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:23:49 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 3/15]  3: uprobes: Slot allocation
 for Execution out of line(XOL)
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 02 Sep 2010 10:23:32 +0200
Message-ID: <1283415812.2059.1825.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 19:11 +0530, Srikar Dronamraju wrote:
> Current slot allocation mechanism:
> 1. Allocate one dedicated slot per user breakpoint. Each slot is big
> enuf to accomodate the biggest instruction for that architecture. (16
> bytes for x86).
> 2. We currently allocate only one page for slots. Hence the number of
> slots is limited to active breakpoint hits on that process.
> 3. Bitmap to track used slots. 

An alternative method would be to have 1 slot per cpu, and manage the
slot content using preemption notifiers. That gives you a fixed number
of slots and an unlimited number of probe points.

If the preemption happens to be a migration you need to rewrite the
userspace IP to point to the new slot -- if indeed the task was inside
one when it got preempted -- but that all should be doable.


