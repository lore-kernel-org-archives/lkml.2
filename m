Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab3AHO1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:27:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756424Ab3AHO1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:27:39 -0500
Date: Tue, 8 Jan 2013 15:27:15 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>
Subject: Re: [RFC PATCH 5/6] uprobes: add bp_vaddr argument to consumer
 handler
Message-ID: <20130108142715.GA16849@bandura.brq.redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com>
 <1356088596-17858-6-git-send-email-anton@redhat.com>
 <20121222163545.GE18082@redhat.com>
 <20121222171329.GA20691@redhat.com>
 <20121223154910.GA7106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121223154910.GA7106@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 04:49:10PM +0100, Oleg Nesterov wrote:
> On 12/22, Oleg Nesterov wrote:
> >
> > Forgot to ask...
> >
> > On 12/22, Oleg Nesterov wrote:
> > >
> > > On 12/21, Anton Arapov wrote:
> > > >
> > > >  struct uprobe_consumer {
> > > > -	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
> > > > +	int (*handler)(struct uprobe_consumer *self, unsigned long bp_vaddr, struct pt_regs *regs);
> > >
> > > It seems that we can do better...
> > >
> > > Just change regs->ip before calling ->handler().
> >
> > Josh, Frank, will it work for you?
> 
> Wait, probably I was confused by this patch and 4/6...
> 
> To simplify, lets ignore the normal uprobes. Yes I still think that it
> would be better to set "regs->ip = orig_return_vaddr" before calling
> ->handler() and not pass it as an argument.
> 
> But, probably uprobe_consumer also needs to know bp_vaddr? IOW, the
> address of the function which we are going to return from? In this case,
> yes, we also need another argument. And prepare_uretprobe/etc should
> be changed to record bp_vaddr passed from handle_swbp(). And
> uretprobe_run_handlers() should pass this bp_vaddr, not orig_return_vaddr.
> 
> Or I am confused.
> 
> Anton?

  Oleg, you are absolutely right and change the ip before calling the
->handle is much better then what I 'invented'.
 
  I'm working on v2 to address this and other issues, will post it soon.

Anton.
