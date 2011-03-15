Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496Ab1COTvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:51:31 -0400
Received: from mout.perfora.net ([74.208.4.194]:55226 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758093Ab1COTva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:51:30 -0400
Date: Tue, 15 Mar 2011 15:49:14 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 17/20] 17: uprobes: filter chain
Message-ID: <20110315194914.GA24972@fibrous.localdomain>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6> <20110314133722.27435.55663.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314133722.27435.55663.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:pLgE5bChquLW7LOM+pNbqUTfcU1mZPoV9dNFNQ2CGgu
 z07ChtZt8QzFmNWYbdrgmC8KLDoUdcUrfslZGjQEVeb9F7volw
 qKyAYHlqyAF/PE0OHM7qNAeDBOitRYw58RSkCiybnD89uZN7PP
 +e1jkNjby0IgIPTRDnr39tod798vmZPg+rt+eOhxUCM8xNFJBe
 sZZwi0yUk4t3rnqCgBGLQ8EaJvIyMt/wMAgtxrSIkQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Mon, Mar 14, 2011 at 07:07:22PM +0530, Srikar Dronamraju wrote:
> 
> Loops through the filters callbacks of currently registered
> consumers to see if any consumer is interested in tracing this task.

Should this be part of the series?  It is not currently used.

>  /* Acquires uprobe->consumer_rwsem */
> +static bool filter_chain(struct uprobe *uprobe, struct task_struct *t)
> +{
> +	struct uprobe_consumer *consumer;
> +	bool ret = false;
> +
> +	down_read(&uprobe->consumer_rwsem);
> +	for (consumer = uprobe->consumers; consumer;
> +					consumer = consumer->next) {
> +		if (!consumer->filter || consumer->filter(consumer, t)) {

The implementation does not seem to match the changelog description.
Should this not be:

                if (consumer->filter && consumer->filter(consumer, t))

  ?

> +			ret = true;
> +			break;
> +		}
> +	}
> +	up_read(&uprobe->consumer_rwsem);
> +	return ret;
> +}
> +

-- 
steve

