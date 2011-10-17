Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1JQTBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:01:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1JQTBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:01:16 -0400
Date: Mon, 17 Oct 2011 20:55:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Paris <eparis@parisplace.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/X] uprobes: reimplement xol_add_vma() via
	install_special_mapping()
Message-ID: <20111017185526.GA9244@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com> <20111016161359.GA24893@redhat.com> <20111017105054.GC11831@linux.vnet.ibm.com> <1318858455.7251.12.camel@moss-pluto>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318858455.7251.12.camel@moss-pluto>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Stephen Smalley wrote:
>
> > Since selinux wasnt happy to have an anonymous vma attached, we would
> > create a pseudo file using shmem_file_setup. However after comments from
> > Peter and Stephan's suggestions we started using override_creds. Peter and
> > Oleg suggest that we use install_special_mapping.
> >
> > Are you okay with using install_special_mapping instead of
> > override_creds()?
>
> That's fine with me.

Good.

> But I'm still not clear on how you are controlling
> the use of this facility from userspace, which is my primary concern.

Yes, but just in case... Any security check in xol_add_vma() is pointless.
The task is already "owned" by uprobes when xol_add_vma() is called.

Oleg.

