Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab1FVREe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:04:34 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:35565 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1FVREc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:04:32 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jun 2011 13:04:32 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
X-Fcc: ~/Mail/lkml
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 14/22] 14: x86: uprobes exception
 notifier for x86.
In-Reply-To: Srikar Dronamraju's message of  Wednesday, 22 June 2011 20:24:24 +0530 <20110622145424.GG16471@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	<20110607130101.28590.99984.sendpatchset@localhost6.localdomain6>
	<1308663084.26237.145.camel@twins>
	<1308663167.26237.146.camel@twins>
	<20110622145424.GG16471@linux.vnet.ibm.com>
X-Zippy-Says: CONGRATULATIONS!  Now should I make thinly veiled comments about
   DIGNITY, self-esteem and finding TRUE FUN in your RIGHT VENTRICLE??
Message-Id: <20110622164055.1F5162C11F@topped-with-meat.com>
Date: Wed, 22 Jun 2011 09:40:55 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=apHJ+VlV c=1 sm=1 a=yF3wy6qf-dwA:10
		a=kj9zAlcOel0A:10 a=9x4yVyg41yZ_bGffBgQA:9 a=CjuIK1q_8ugA:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oleg, Roland, do you know why do_notify_resume() gets called with
> interrupts disabled on i386? 

It was that way for a long time.  My impression was that it was just not
bothering to reenable before do_signal->get_signal_to_deliver would shortly
disable (via spin_lock_irq) anyway.  It's possible there was something more
to it, but I don't know of anything.


Thanks,
Roland
