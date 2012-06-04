Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829Ab2FDPm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:42:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab2FDPmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:42:53 -0400
Date: Mon, 4 Jun 2012 17:40:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: document uprobe_register() vs
	uprobe_mmap() race
Message-ID: <20120604154058.GA9045@redhat.com>
References: <20120604145238.GA6408@redhat.com> <20120604145331.GC6416@redhat.com> <1338822048.28282.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338822048.28282.59.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04, Peter Zijlstra wrote:
>
> On Mon, 2012-06-04 at 16:53 +0200, Oleg Nesterov wrote:
>
> I didn't check if its my error or not, however:
>
> > @@ -850,6 +869,10 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
> >
> >  		if (is_register) {
> >  			err = install_breakpoint(uprobe, mm, vma, info->vaddr);
> > +			/*
> > +			 * We can race against uprobe_register(), see the
>
> that should be uprobe_mmap(), since this is the register path ;-)

Oops. Fixed. 2/2 is also changed as you suggested.

I'll wait a bit to collect more comments/reviews and resend.

Thanks!

Oleg.

