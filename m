Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab1FPNxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:53:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab1FPNxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:53:52 -0400
Date: Thu, 16 Jun 2011 15:51:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 4/22]  4: Uprobes: register/unregister
	probes.
Message-ID: <20110616135114.GA22131@redhat.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6> <20110607125900.28590.16071.sendpatchset@localhost6.localdomain6> <1308159719.2171.57.camel@laptop> <20110616041137.GG4952@linux.vnet.ibm.com> <1308217582.15315.94.camel@twins> <20110616095412.GK4952@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616095412.GK4952@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16, Srikar Dronamraju wrote:
>
> In which case, shouldnt traversing all the tasks of all siblings of
> parent of mm->owner should provide us all the the tasks that have linked
> to mm. Right?

I don't think so.

Even if the initial mm->ovner never exits (iow, mm->owner is never changed),
the "deep" CLONE_VM child can be reparented to init if its parent exits.

> Agree that we can bother about this a little later.

Agreed.


Oh. We should move ->mm from task_struct to signal_struct, but we need to
change the code like get_task_mm(). And then instead of mm->owner we can
have mm->processes list. Perhaps. This can be used by zap_threads() too.

Oleg.

