Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1IZMaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 08:30:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49898 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1IZMaW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 08:30:22 -0400
Subject: Re: [PATCH v5 3.1.0-rc4-tip 2/26]   Uprobes: Allow multiple
 consumers for an uprobe.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 26 Sep 2011 14:29:26 +0200
In-Reply-To: <20110920120006.25326.81787.sendpatchset@srdronam.in.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
	 <20110920120006.25326.81787.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317040166.9084.90.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 17:30 +0530, Srikar Dronamraju wrote:
> +       con = uprobe->consumers;
> +       if (consumer == con) {
> +               uprobe->consumers = con->next;
> +               ret = true;
> +       } else {
> +               for (; con; con = con->next) {
> +                       if (con->next == consumer) {
> +                               con->next = consumer->next;
> +                               ret = true;
> +                               break;
> +                       }
> +               }
> +       } 

	struct uprobe_consumer **next = &uprobe->consumers;

	for (; *next; next = &(*next)->next) {
		if (*next == consumer) {
			*next = (*next)->next;
			ret = true;
			break;
		}
	}

Wouldn't something like that work?
