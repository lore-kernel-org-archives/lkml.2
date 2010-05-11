Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab0EKU7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:59:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab0EKU67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:58:59 -0400
Date: Tue, 11 May 2010 16:57:59 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
Message-ID: <20100511205759.GD14992@redhat.com>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6> <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6> <20100413183537.GA17538@redhat.com> <20100415093506.GA2064@linux.vnet.ibm.com> <20100419193139.GA24080@redhat.com> <20100420124358.GA20675@linux.vnet.ibm.com> <20100420153023.GA9351@redhat.com> <1273609938.1810.81.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273609938.1810.81.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, May 11, 2010 at 10:32:18PM +0200, Peter Zijlstra wrote:
> [...]
> Right so what I've suggested several times it to simply call the same
> handler in both contexts. If it returns -EFAULT, set TIF_UPROBE or
> whatever and try again from task context.

That could work, but random partial execution & restart of the handler
will make it tricky to write a single handler that reliably produces
results.  It would likely need a flag to indicate that it failed
previously so as to throw away partial results.

- FChE
