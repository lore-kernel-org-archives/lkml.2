Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2FOPua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:50:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab2FOPu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:50:28 -0400
Date: Fri, 15 Jun 2012 17:48:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: write_opcode()->__replace_page() can race
	with try_to_unmap()
Message-ID: <20120615154810.GA9662@redhat.com>
References: <20120607165942.GA31966@redhat.com> <20120607170041.GC31974@redhat.com> <20120608165551.GA30683@redhat.com> <20120615061217.GC12051@linux.vnet.ibm.com> <20120615121151.GB28541@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615121151.GB28541@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15, Ingo Molnar wrote:
>
> * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
>
> > > @@ -228,9 +210,10 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
> > >  	void *vaddr_old, *vaddr_new;
> > >  	struct vm_area_struct *vma;
> > >  	struct uprobe *uprobe;
> > > +	unsigned long pgoff;
> > >  	loff_t addr;
> > >  	int ret;
> > > -
> > > +retry:
> >
> > Just a check on coding style: Shouldnt we have a preceeding blank
> > line before the goto label.
>
> Yeah, that's most likely helpful to readability.

Aaah. Srikar, sorry, I didn't notice this comment and I already
sent 1-15. But I added the blank line in 2/15 ;)

Ingo, please let me know if I need to re-diff and resend. Otherwise
I'll add the blank line later, write_opcode() needs more changes
anyway.

Oleg.

